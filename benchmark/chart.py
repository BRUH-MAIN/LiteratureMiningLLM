"""
Renders results/benchmark_report/summary.csv (+ reference_agreement_report.json,
if present) into a self-contained, theme-aware interactive HTML chart at
results/benchmark_report/chart.html - a sorted horizontal-bar leaderboard (mean F1
vs. the consensus gold standard, HuggingFace-leaderboard style) plus a matching
latency leaderboard in the same row order, and a data table. Follows this repo's
dataviz design system (see the `dataviz` skill).

Earlier version used a grouped bar chart (thinking-level sub-bars crammed under
each family) and an accuracy-vs-latency scatter. Both broke down in practice: the
grouped bars' per-bar labels collided once family names got long, and the scatter's
8 points formed two tight latency clusters (Qwen's CPU-offloaded MoE run alone
near 130s, everything else bunched 41-50s) with overlapping markers and colliding
direct labels. A flat sorted-bar leaderboard has no such failure mode - row order
does the ranking job a scatter's y-position was doing, and bars never overlap
regardless of how close two values are.
"""

import argparse
import json
from pathlib import Path
from typing import Any, Dict, List, Optional

import pandas as pd

# Fixed family -> categorical slot assignment (palette.md slots 1-8: blue/green/magenta/
# yellow/aqua/orange/violet/red - the full safe ceiling for a bar chart's adjacent pairlist,
# validated via scripts/validate_palette.js). Fixed and hand-maintained rather than derived
# from whatever families happen to appear in a given run, so a family's color never shifts
# across regenerations (see dataviz skill: "color follows the entity, never its rank/filter
# state"). New families are appended to the next free slot, never inserted/resorted, so
# existing families keep their color.
#
# We're now AT the 8-hue ceiling with 8 actively-scored families - adding a 9th would mean
# a generated hue indistinguishable from an existing one under CVD (the skill explicitly
# prohibits this: fold into "Other," facet, or use composite encoding instead). gemini-3.5-flash
# previously held a "reserved" slot 1 despite never having actually been rendered (still
# quota-blocked, zero real visual presence to date) - that reservation is dropped here to make
# room; if it ever gets real data, slot assignment needs revisiting rather than silently
# generating a 9th hue.
FAMILY_COLOR_SLOTS = {
    'glm-5': 1,
    'gemma-4-12b-it': 2,
    'gpt-oss-20b': 3,
    'qwen3.6-35b-a3b': 4,
    'claude-sonnet-4.6': 5,
    'gpt-5.6-terra': 6,
    'gemini-3.6-flash': 7,
    'deepseek-v3.1': 8,
}

HTML_TEMPLATE = r"""<!doctype html>
<title>MXene Benchmark - Model Comparison</title>
<style>
  * { box-sizing: border-box; }
  html, body { margin: 0; padding: 0; }
  body {
    font-family: system-ui, -apple-system, "Segoe UI", sans-serif;
    background: var(--page-plane);
    color: var(--text-primary);
  }
  .viz-root {
    color-scheme: light;
    --page-plane:      #f9f9f7;
    --surface-1:        #fcfcfb;
    --text-primary:     #0b0b0b;
    --text-secondary:   #52514e;
    --text-muted:       #898781;
    --gridline:         #e1e0d9;
    --baseline:         #c3c2b7;
    --border:           rgba(11,11,11,0.10);
    --seq-100: #cde2fb; --seq-250: #86b6ef; --seq-450: #2a78d6; --seq-650: #104281;
    --cat-1: #2a78d6; --cat-2: #008300; --cat-3: #e87ba4; --cat-4: #eda100; --cat-5: #1baf7a; --cat-6: #eb6834; --cat-7: #4a3aa7; --cat-8: #e34948;
    --muted-mark:       #52514e;
  }
  @media (prefers-color-scheme: dark) {
    :root:where(:not([data-theme="light"])) .viz-root {
      color-scheme: dark;
      --page-plane:      #0d0d0d;
      --surface-1:        #1a1a19;
      --text-primary:     #ffffff;
      --text-secondary:   #c3c2b7;
      --text-muted:       #898781;
      --gridline:         #2c2c2a;
      --baseline:         #383835;
      --border:           rgba(255,255,255,0.10);
      --seq-100: #184f95; --seq-250: #1c5cab; --seq-450: #3987e5; --seq-650: #9ec5f4;
      --cat-1: #3987e5; --cat-2: #008300; --cat-3: #d55181; --cat-4: #c98500; --cat-5: #199e70; --cat-6: #d95926; --cat-7: #9085e9; --cat-8: #e66767;
      --muted-mark:       #c3c2b7;
    }
  }
  :root[data-theme="dark"] .viz-root {
    color-scheme: dark;
    --page-plane:      #0d0d0d;
    --surface-1:        #1a1a19;
    --text-primary:     #ffffff;
    --text-secondary:   #c3c2b7;
    --text-muted:       #898781;
    --gridline:         #2c2c2a;
    --baseline:         #383835;
    --border:           rgba(255,255,255,0.10);
    --seq-100: #184f95; --seq-250: #1c5cab; --seq-450: #3987e5; --seq-650: #9ec5f4;
    --cat-1: #3987e5; --cat-2: #008300; --cat-3: #d55181; --cat-4: #c98500; --cat-5: #199e70; --cat-6: #d95926; --cat-7: #9085e9; --cat-8: #e66767;
    --muted-mark:       #c3c2b7;
  }
  .viz-root { max-width: 1080px; margin: 0 auto; padding: 24px 20px 48px; }
  h1 { font-size: 20px; margin: 0 0 4px; }
  .subtitle { color: var(--text-secondary); font-size: 14px; margin: 0 0 24px; }
  .panel {
    background: var(--surface-1);
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 20px;
    overflow-x: auto;
  }
  .panel h2 { font-size: 15px; margin: 0 0 2px; }
  .panel .note { font-size: 12px; color: var(--text-muted); margin: 0 0 14px; }
  svg { display: block; }
  .axis text { fill: var(--text-muted); font-size: 11px; }
  .axis-title { fill: var(--text-secondary); font-size: 12px; }
  .grid line { stroke: var(--gridline); stroke-width: 1; }
  .baseline { stroke: var(--baseline); stroke-width: 1; }
  .ref-line { stroke: var(--text-muted); stroke-width: 1.5; stroke-dasharray: 4 3; }
  .ref-label { fill: var(--text-secondary); font-size: 11px; }
  .row-label-name { fill: var(--text-primary); font-size: 12px; font-weight: 600; }
  .row-label-level { fill: var(--text-muted); font-size: 10.5px; }
  .value-label { fill: var(--text-primary); font-size: 11.5px; font-variant-numeric: tabular-nums; }
  .bar-rect { cursor: pointer; transition: filter 0.1s; }
  .bar-rect:hover { filter: brightness(1.18); }
  .legend { display: flex; align-items: center; gap: 14px; font-size: 12px; color: var(--text-secondary); margin-top: 12px; flex-wrap: wrap; }
  .legend .swatch { display: inline-flex; align-items: center; gap: 6px; margin-right: 4px; }
  .legend .swatch-box { display: inline-block; width: 11px; height: 11px; border-radius: 2px; }
  .tooltip {
    position: fixed; pointer-events: none; z-index: 10;
    background: var(--surface-1); border: 1px solid var(--border); border-radius: 6px;
    padding: 8px 10px; font-size: 12px; color: var(--text-primary);
    box-shadow: 0 4px 16px rgba(0,0,0,0.15); display: none; max-width: 260px;
  }
  .tooltip .tt-title { font-weight: 600; display: block; margin-bottom: 4px; }
  .tooltip .tt-row { color: var(--text-secondary); }
  .tooltip .tt-row b { color: var(--text-primary); font-weight: 600; }
  table.data-table { width: 100%; border-collapse: collapse; font-size: 12px; margin-top: 4px; }
  table.data-table th, table.data-table td { text-align: left; padding: 6px 10px; border-bottom: 1px solid var(--gridline); }
  table.data-table th { color: var(--text-secondary); font-weight: 600; }
  table.data-table td { color: var(--text-primary); font-variant-numeric: tabular-nums; }
</style>
<div class="viz-root">
  <h1>MXene Literature-Mining Benchmark</h1>
  <p class="subtitle" id="subtitle">Candidate model extraction quality vs. the consensus gold standard, across thinking-effort levels.</p>

  <div class="panel">
    <h2>Extraction quality leaderboard</h2>
    <p class="note">Mean F1 across materials/properties/applications, sorted highest to lowest. Dashed lines mark the consensus-gold reference (1.000) and the reference panel's own mutual agreement rate - the noise floor no candidate should be expected to exceed.</p>
    <svg id="bar-chart"></svg>
    <div class="legend" id="legend"></div>
  </div>

  <div class="panel">
    <h2>Groundedness (faithfulness to source text)</h2>
    <p class="note">A second, fully independent axis: what share of each model's extracted items can actually be traced back to the paper text it was given - no gold standard involved (see benchmark/scoring/groundedness.py). High F1 with low groundedness means a model agrees with the panel partly by inferring from domain knowledge rather than reading. Bars show the mean across materials/properties/applications.</p>
    <svg id="groundedness-chart"></svg>
  </div>

  <div class="panel">
    <h2>Avg. latency per paper</h2>
    <p class="note">Same rows, same order as the leaderboard above - lower is faster. Kaggle GPU wall-clock times aren't directly comparable to a hosted API's network round-trip, so this is shown separately rather than mixed into the accuracy comparison.</p>
    <svg id="latency-chart"></svg>
  </div>

  <div class="panel">
    <h2>All runs</h2>
    <div id="table-container"></div>
  </div>

  <div class="tooltip" id="tooltip"></div>
</div>
<script id="chart-data" type="application/json">__CHART_DATA_JSON__</script>
<script>
(function () {
  const data = JSON.parse(document.getElementById('chart-data').textContent);
  // Sort once, descending by mean F1 - both panels share this exact row order so a
  // reader can scan the same row across panels for the accuracy/latency trade-off.
  const rows = data.rows.slice().sort((a, b) => b.mean_f1 - a.mean_f1);
  const goldF1 = data.gold_f1;
  const noiseFloor = data.reference_agreement_mean_f1;
  const tooltip = document.getElementById('tooltip');

  if (data.reference_panel && data.reference_panel.length) {
    document.getElementById('subtitle').textContent =
      'Candidate model extraction quality vs. the consensus gold standard (' +
      data.reference_panel.join(' + ') + ' reference panel), across thinking-effort levels.';
  }

  function svgEl(tag, attrs) {
    const el = document.createElementNS('http://www.w3.org/2000/svg', tag);
    for (const k in attrs) el.setAttribute(k, attrs[k]);
    return el;
  }

  function showTooltip(evt, r) {
    tooltip.textContent = '';
    const title = document.createElement('span');
    title.className = 'tt-title';
    title.textContent = r.model;
    tooltip.appendChild(title);

    const lines = [
      ['Mean F1', r.mean_f1.toFixed(3)],
      ['Materials F1', r.materials_f1.toFixed(3)],
      ['Properties F1', r.properties_f1.toFixed(3)],
      ['Applications F1', r.applications_f1.toFixed(3)],
    ];
    if (r.groundedness_mean != null) lines.push(['Groundedness', r.groundedness_mean.toFixed(3)]);
    if (r.avg_latency_s != null) lines.push(['Avg latency', r.avg_latency_s.toFixed(2) + 's']);
    if (r.est_cost_usd != null) lines.push(['Est. cost', '$' + r.est_cost_usd.toFixed(4)]);

    lines.forEach(([label, value]) => {
      const row = document.createElement('span');
      row.className = 'tt-row';
      row.style.display = 'block';
      row.appendChild(document.createTextNode(label + ': '));
      const b = document.createElement('b');
      b.textContent = value;
      row.appendChild(b);
      tooltip.appendChild(row);
    });

    tooltip.style.display = 'block';
    tooltip.style.left = (evt.clientX + 14) + 'px';
    tooltip.style.top = (evt.clientY + 14) + 'px';
  }
  function hideTooltip() { tooltip.style.display = 'none'; }

  const ROW_H = 42, BAR_H = 20;
  const LABEL_W = 190;

  // ---------- Panel 1: sorted F1 leaderboard ----------
  (function renderBarChart() {
    const margin = { top: 26, right: 56, bottom: 4, left: LABEL_W };
    const plotW = 560;
    const width = margin.left + plotW + margin.right;
    const plotH = rows.length * ROW_H;
    const height = margin.top + plotH + margin.bottom;

    const svg = svgEl('svg', { width, height, viewBox: '0 0 ' + width + ' ' + height });
    document.getElementById('bar-chart').replaceWith(svg);
    svg.id = 'bar-chart';

    const xMax = 1.0;
    const x = v => margin.left + plotW * (v / xMax);

    [0, 0.25, 0.5, 0.75, 1.0].forEach(v => {
      const gx = x(v);
      svg.appendChild(svgEl('line', {
        x1: gx, x2: gx, y1: margin.top - 6, y2: margin.top + plotH,
        class: v === 0 ? 'baseline' : 'grid',
      }));
      // 1.0 sits exactly on the plot's right edge, so a dashed reference line there
      // would just overlap the border - the axis tick itself carries the "gold" label.
      const t = svgEl('text', { x: gx, y: margin.top - 10, class: 'axis', 'text-anchor': v === 1.0 ? 'end' : 'middle' });
      t.textContent = v === 1.0 ? goldF1.toFixed(2) + ' (consensus gold)' : v.toFixed(2);
      svg.appendChild(t);
    });

    if (noiseFloor != null) {
      const nx = x(noiseFloor);
      svg.appendChild(svgEl('line', { x1: nx, x2: nx, y1: margin.top - 6, y2: margin.top + plotH, class: 'ref-line' }));
      const lbl = svgEl('text', { x: nx, y: margin.top - 10, class: 'ref-label', 'text-anchor': 'middle' });
      lbl.textContent = 'Reference-panel agreement (' + noiseFloor.toFixed(3) + ')';
      svg.appendChild(lbl);
    }

    rows.forEach((r, i) => {
      const rowY = margin.top + i * ROW_H;
      const barY = rowY + (ROW_H - BAR_H) / 2;
      const barW = Math.max(plotW * (r.mean_f1 / xMax), 2);
      const slot = r.family_color_slot || 1;

      const nameLbl = svgEl('text', { x: margin.left - 12, y: rowY + ROW_H / 2 - 3, class: 'row-label-name', 'text-anchor': 'end' });
      nameLbl.textContent = r.family;
      svg.appendChild(nameLbl);
      if (r.thinking_level) {
        const levelLbl = svgEl('text', { x: margin.left - 12, y: rowY + ROW_H / 2 + 11, class: 'row-label-level', 'text-anchor': 'end' });
        levelLbl.textContent = r.thinking_level;
        svg.appendChild(levelLbl);
      }

      const rect = svgEl('rect', {
        x: margin.left, y: barY, width: barW, height: BAR_H, rx: 4, ry: 4,
        fill: 'var(--cat-' + slot + ')', class: 'bar-rect',
      });
      rect.addEventListener('pointermove', (e) => showTooltip(e, r));
      rect.addEventListener('mouseleave', hideTooltip);
      svg.appendChild(rect);

      const valLbl = svgEl('text', { x: margin.left + barW + 8, y: barY + BAR_H / 2 + 4, class: 'value-label' });
      valLbl.textContent = r.mean_f1.toFixed(3);
      svg.appendChild(valLbl);
    });
  })();

  // ---------- Legend (family identity) ----------
  (function renderLegend() {
    const seen = new Map();
    rows.forEach(r => { if (!seen.has(r.family)) seen.set(r.family, r.family_color_slot || 1); });
    const legend = document.getElementById('legend');
    seen.forEach((slot, family) => {
      const span = document.createElement('span');
      span.className = 'swatch';
      const box = document.createElement('span');
      box.className = 'swatch-box';
      box.style.background = 'var(--cat-' + slot + ')';
      span.appendChild(box);
      span.appendChild(document.createTextNode(family));
      legend.appendChild(span);
    });
  })();

  // ---------- Panel 2: groundedness (same row order, independent of gold) ----------
  (function renderGroundednessChart() {
    const gRows = rows.filter(r => r.groundedness_mean != null);
    const container = document.getElementById('groundedness-chart');
    if (!gRows.length) { container.closest('.panel').style.display = 'none'; return; }

    const margin = { top: 26, right: 56, bottom: 4, left: LABEL_W };
    const plotW = 560;
    const width = margin.left + plotW + margin.right;
    const plotH = gRows.length * ROW_H;
    const height = margin.top + plotH + margin.bottom;

    const svg = svgEl('svg', { width, height, viewBox: '0 0 ' + width + ' ' + height });
    container.replaceWith(svg);
    svg.id = 'groundedness-chart';

    const x = v => margin.left + plotW * v;

    [0, 0.25, 0.5, 0.75, 1.0].forEach(v => {
      const gx = x(v);
      svg.appendChild(svgEl('line', {
        x1: gx, x2: gx, y1: margin.top - 6, y2: margin.top + plotH,
        class: v === 0 ? 'baseline' : 'grid',
      }));
      const t = svgEl('text', { x: gx, y: margin.top - 10, class: 'axis', 'text-anchor': v === 1.0 ? 'end' : 'middle' });
      t.textContent = v === 1.0 ? '1.00 (fully traceable)' : v.toFixed(2);
      svg.appendChild(t);
    });

    gRows.forEach((r, i) => {
      const rowY = margin.top + i * ROW_H;
      const barY = rowY + (ROW_H - BAR_H) / 2;
      const barW = Math.max(plotW * r.groundedness_mean, 2);
      const slot = r.family_color_slot || 1;

      const nameLbl = svgEl('text', { x: margin.left - 12, y: rowY + ROW_H / 2 - 3, class: 'row-label-name', 'text-anchor': 'end' });
      nameLbl.textContent = r.family;
      svg.appendChild(nameLbl);
      if (r.thinking_level) {
        const levelLbl = svgEl('text', { x: margin.left - 12, y: rowY + ROW_H / 2 + 11, class: 'row-label-level', 'text-anchor': 'end' });
        levelLbl.textContent = r.thinking_level;
        svg.appendChild(levelLbl);
      }

      const rect = svgEl('rect', {
        x: margin.left, y: barY, width: barW, height: BAR_H, rx: 4, ry: 4,
        fill: 'var(--cat-' + slot + ')', class: 'bar-rect',
      });
      rect.addEventListener('pointermove', (e) => showTooltip(e, r));
      rect.addEventListener('mouseleave', hideTooltip);
      svg.appendChild(rect);

      const valLbl = svgEl('text', { x: margin.left + barW + 8, y: barY + BAR_H / 2 + 4, class: 'value-label' });
      valLbl.textContent = r.groundedness_mean.toFixed(3);
      svg.appendChild(valLbl);
    });
  })();

  // ---------- Panel 3: latency leaderboard (same row order) ----------
  (function renderLatencyChart() {
    const latRows = rows.filter(r => r.avg_latency_s != null);
    const margin = { top: 26, right: 60, bottom: 4, left: LABEL_W };
    const plotW = 560;
    const width = margin.left + plotW + margin.right;
    const plotH = latRows.length * ROW_H;
    const height = margin.top + plotH + margin.bottom;

    const svg = svgEl('svg', { width, height, viewBox: '0 0 ' + width + ' ' + height });
    document.getElementById('latency-chart').replaceWith(svg);
    svg.id = 'latency-chart';

    // "Nice" tick step (1/2/5 * 10^n) sized for ~4-5 ticks, rather than quarter-fractions
    // of a rounded max - avoids ugly ticks like "38s"/"113s".
    const rawMax = Math.max(...latRows.map(r => r.avg_latency_s), 1);
    const roughStep = rawMax / 4;
    const magnitude = Math.pow(10, Math.floor(Math.log10(roughStep)));
    const niceStep = [1, 2, 5, 10].map(m => m * magnitude).find(s => s >= roughStep) || 10 * magnitude;
    const xMax = Math.ceil(rawMax / niceStep) * niceStep;
    const ticks = [];
    for (let v = 0; v <= xMax + 1e-9; v += niceStep) ticks.push(v);
    const x = v => margin.left + plotW * (v / xMax);

    ticks.forEach(v => {
      const gx = x(v);
      svg.appendChild(svgEl('line', {
        x1: gx, x2: gx, y1: margin.top - 6, y2: margin.top + plotH,
        class: v === 0 ? 'baseline' : 'grid',
      }));
      const t = svgEl('text', { x: gx, y: margin.top - 10, class: 'axis', 'text-anchor': 'middle' });
      t.textContent = v.toFixed(0) + 's';
      svg.appendChild(t);
    });

    latRows.forEach((r, i) => {
      const rowY = margin.top + i * ROW_H;
      const barY = rowY + (ROW_H - BAR_H) / 2;
      const barW = Math.max(plotW * (r.avg_latency_s / xMax), 2);

      const nameLbl = svgEl('text', { x: margin.left - 12, y: rowY + ROW_H / 2 - 3, class: 'row-label-name', 'text-anchor': 'end' });
      nameLbl.textContent = r.family;
      svg.appendChild(nameLbl);
      if (r.thinking_level) {
        const levelLbl = svgEl('text', { x: margin.left - 12, y: rowY + ROW_H / 2 + 11, class: 'row-label-level', 'text-anchor': 'end' });
        levelLbl.textContent = r.thinking_level;
        svg.appendChild(levelLbl);
      }

      const rect = svgEl('rect', {
        x: margin.left, y: barY, width: barW, height: BAR_H, rx: 4, ry: 4,
        fill: 'var(--seq-450)', class: 'bar-rect',
      });
      rect.addEventListener('pointermove', (e) => showTooltip(e, r));
      rect.addEventListener('mouseleave', hideTooltip);
      svg.appendChild(rect);

      const valLbl = svgEl('text', { x: margin.left + barW + 8, y: barY + BAR_H / 2 + 4, class: 'value-label' });
      valLbl.textContent = r.avg_latency_s.toFixed(1) + 's';
      svg.appendChild(valLbl);
    });
  })();

  // ---------- Data table ----------
  (function renderTable() {
    const cols = ['model', 'family', 'thinking_level', 'mean_f1', 'materials_f1', 'properties_f1', 'applications_f1', 'groundedness_mean', 'avg_latency_s', 'est_cost_usd'];
    const table = document.createElement('table');
    table.className = 'data-table';
    const thead = document.createElement('thead');
    const headRow = document.createElement('tr');
    cols.forEach(c => {
      const th = document.createElement('th');
      th.textContent = c;
      headRow.appendChild(th);
    });
    thead.appendChild(headRow);
    table.appendChild(thead);

    const tbody = document.createElement('tbody');
    rows.forEach(r => {
      const tr = document.createElement('tr');
      cols.forEach(c => {
        const td = document.createElement('td');
        const v = r[c];
        td.textContent = v == null ? '-' : (typeof v === 'number' ? v.toFixed(v <= 1 ? 3 : 2) : v);
        tr.appendChild(td);
      });
      tbody.appendChild(tr);
    });
    table.appendChild(tbody);

    const container = document.getElementById('table-container');
    container.textContent = '';
    container.appendChild(table);
  })();
})();
</script>
"""

THINKING_RANK_HINTS = {
    'low': 0, 'thinking-off': 0, 'off': 0,
    'medium': 1,
    'high': 2, 'thinking-on': 2, 'on': 2,
}


def _thinking_rank(level: Optional[str]) -> int:
    # pandas reads a missing CSV cell as float('nan'), not None/'' - `not nan` is False in
    # Python, so a plain falsy check lets it through to .lower() and crashes. isinstance
    # guards against any non-string (nan included) directly instead.
    if not isinstance(level, str) or not level:
        return 0
    return THINKING_RANK_HINTS.get(level.lower(), 0)


def _groundedness_means(groundedness_report: Optional[Dict[str, Any]]) -> Dict[str, float]:
    """run_key -> mean groundedness rate across the three categories (None rates skipped)"""
    if not groundedness_report:
        return {}
    means = {}
    for run_key, entry in groundedness_report.items():
        rates = [v for v in (entry.get('rates') or {}).values() if v is not None]
        if rates:
            means[run_key] = sum(rates) / len(rates)
    return means


def build_chart_data(summary_df: pd.DataFrame, gold_model: str,
                      reference_agreement_report: Optional[Dict[str, Any]] = None,
                      groundedness_report: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    candidate_rows = summary_df[summary_df['model'] != gold_model].copy()
    gold_rows = summary_df[summary_df['model'] == gold_model]
    gold_f1 = float(gold_rows.iloc[0]['mean_f1']) if not gold_rows.empty else 1.0

    reference_agreement_mean_f1 = None
    reference_panel = None
    if reference_agreement_report:
        cats = reference_agreement_report.get('agreement_micro', {})
        f1s = [v['f1'] for v in cats.values()] if cats else []
        if f1s:
            reference_agreement_mean_f1 = sum(f1s) / len(f1s)
        reference_panel = reference_agreement_report.get('reference_panel')

    groundedness_means = _groundedness_means(groundedness_report)

    rows: List[Dict[str, Any]] = []
    for _, r in candidate_rows.iterrows():
        family = r.get('family', r['model'])
        # A single-shot candidate (no thinking-level sweep) has a blank CSV cell here, which
        # pandas reads as float('nan') rather than None/'' - json.dumps(nan) emits the bare
        # token `NaN`, which is not valid JSON and breaks JSON.parse() in the browser.
        raw_level = r.get('thinking_level')
        thinking_level = raw_level if isinstance(raw_level, str) else None
        rows.append({
            'model': r['model'],
            'family': family,
            'family_color_slot': FAMILY_COLOR_SLOTS.get(family, 1),
            'thinking_level': thinking_level,
            'thinking_rank': _thinking_rank(thinking_level),
            'mean_f1': float(r['mean_f1']),
            'materials_f1': float(r['materials_f1']),
            'properties_f1': float(r['properties_f1']),
            'applications_f1': float(r['applications_f1']),
            'groundedness_mean': groundedness_means.get(r['model']),
            'avg_latency_s': float(r['avg_latency_s']) if pd.notna(r.get('avg_latency_s')) else None,
            'est_cost_usd': float(r['est_cost_usd']) if pd.notna(r.get('est_cost_usd')) else None,
        })

    return {
        'rows': rows,
        'gold_f1': gold_f1,
        'reference_agreement_mean_f1': reference_agreement_mean_f1,
        'reference_panel': reference_panel,
    }


def render_chart_html(chart_data: Dict[str, Any]) -> str:
    return HTML_TEMPLATE.replace('__CHART_DATA_JSON__', json.dumps(chart_data))


def main():
    parser = argparse.ArgumentParser(description="Render the benchmark summary into an interactive HTML chart")
    parser.add_argument('--summary-csv', default='results/benchmark_report/summary.csv')
    parser.add_argument('--reference-agreement-json', default='results/benchmark/reference_agreement_report.json')
    parser.add_argument('--groundedness-json', default='results/benchmark_report/groundedness_report.json',
                         help="Optional - adds the gold-independent groundedness panel if present")
    parser.add_argument('--gold-model', default='consensus-gold')
    parser.add_argument('--out', default='results/benchmark_report/chart.html')
    args = parser.parse_args()

    summary_df = pd.read_csv(args.summary_csv)

    reference_agreement_report = None
    ref_path = Path(args.reference_agreement_json)
    if ref_path.exists():
        reference_agreement_report = json.load(open(ref_path, encoding='utf-8'))

    groundedness_report = None
    g_path = Path(args.groundedness_json)
    if g_path.exists():
        groundedness_report = json.load(open(g_path, encoding='utf-8'))

    chart_data = build_chart_data(summary_df, args.gold_model, reference_agreement_report, groundedness_report)
    html = render_chart_html(chart_data)

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(html, encoding='utf-8')
    print(f"Wrote chart to {out_path}")


if __name__ == '__main__':
    main()
