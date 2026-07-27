"""
Renders a static, self-contained SVG leaderboard for embedding directly in README.md.

The interactive chart (benchmark/chart.py -> chart.html) doesn't render inline on GitHub -
markdown only shows it as a link. This emits plain SVG instead, which GitHub renders natively,
in light and dark variants so a <picture> element can serve the right one per theme.

Deliberately uses inline presentation attributes (fill=, font-size=) rather than a <style>
block: GitHub's markdown sanitizer strips <style> from embedded SVG, which would leave the
chart unstyled.

Plots mean F1 and groundedness as paired bars on one shared 0-1 axis. Both are rates on the
same scale, so this is a single-axis chart, not a dual-axis one - and pairing them is the
point: it shows directly that agreement-with-gold and faithfulness-to-source diverge
(GLM-5 low F1 / highest groundedness, Claude Sonnet 4.6 high F1 / lowest groundedness).
"""

import argparse
import json
from pathlib import Path
from typing import Any, Dict, List, Optional

import pandas as pd

from benchmark.chart import _groundedness_means

# Light/dark token pairs, matching benchmark/chart.py's palette (dataviz design system).
THEMES = {
    "light": {
        "surface": "#fcfcfb", "text": "#0b0b0b", "text2": "#52514e", "muted": "#898781",
        "grid": "#e1e0d9", "baseline": "#c3c2b7", "f1": "#2a78d6", "grounded": "#008300",
    },
    "dark": {
        "surface": "#1a1a19", "text": "#ffffff", "text2": "#c3c2b7", "muted": "#898781",
        "grid": "#2c2c2a", "baseline": "#383835", "f1": "#3987e5", "grounded": "#008300",
    },
}

FONT = "system-ui,-apple-system,Segoe UI,Helvetica,Arial,sans-serif"

ROW_H = 40
BAR_H = 13
BAR_GAP = 3
LABEL_W = 200
PLOT_W = 480
RIGHT_PAD = 62
# TOP must clear the legend (text baseline y=44, descenders to ~47) before the x-axis tick
# labels start at TOP-12; at TOP=62 the ticks sat directly under the legend at the same x
# positions and collided. BOTTOM likewise has to fit the noise-floor caption's descenders.
TOP = 74
BOTTOM = 24


def _esc(s: str) -> str:
    return (str(s).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))


def render_svg(rows: List[Dict[str, Any]], theme: str, noise_floor: Optional[float]) -> str:
    t = THEMES[theme]
    plot_h = len(rows) * ROW_H
    width = LABEL_W + PLOT_W + RIGHT_PAD
    height = TOP + plot_h + BOTTOM

    def x(v: float) -> float:
        return LABEL_W + PLOT_W * v

    o: List[str] = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
        f'viewBox="0 0 {width} {height}" font-family="{FONT}">',
        f'<rect width="{width}" height="{height}" rx="10" fill="{t["surface"]}"/>',
        f'<text x="{LABEL_W}" y="24" font-size="14" font-weight="600" fill="{t["text"]}">'
        f'MXene extraction benchmark &#183; 60 papers &#183; {len(rows)} models</text>',
    ]

    # Legend (two series -> legend always present)
    lx = LABEL_W
    o.append(f'<rect x="{lx}" y="34" width="11" height="11" rx="2" fill="{t["f1"]}"/>')
    o.append(f'<text x="{lx + 17}" y="44" font-size="11.5" fill="{t["text2"]}">Mean F1 vs. consensus gold</text>')
    lx += 200
    o.append(f'<rect x="{lx}" y="34" width="11" height="11" rx="2" fill="{t["grounded"]}"/>')
    o.append(f'<text x="{lx + 17}" y="44" font-size="11.5" fill="{t["text2"]}">Groundedness (source-traceable)</text>')

    # Gridlines + x-axis ticks
    for v in (0, 0.25, 0.5, 0.75, 1.0):
        gx = x(v)
        stroke = t["baseline"] if v == 0 else t["grid"]
        o.append(f'<line x1="{gx:.1f}" x2="{gx:.1f}" y1="{TOP - 6}" y2="{TOP + plot_h}" '
                 f'stroke="{stroke}" stroke-width="1"/>')
        o.append(f'<text x="{gx:.1f}" y="{TOP - 12}" font-size="10.5" fill="{t["muted"]}" '
                 f'text-anchor="middle">{v:.2f}</text>')

    # Noise-floor reference line (applies to the F1 series)
    if noise_floor is not None:
        nx = x(noise_floor)
        o.append(f'<line x1="{nx:.1f}" x2="{nx:.1f}" y1="{TOP - 6}" y2="{TOP + plot_h}" '
                 f'stroke="{t["muted"]}" stroke-width="1.5" stroke-dasharray="4 3"/>')
        o.append(f'<text x="{nx:.1f}" y="{TOP + plot_h + 12}" font-size="10.5" '
                 f'fill="{t["text2"]}" text-anchor="middle">'
                 f'noise floor {noise_floor:.3f} &#8212; panel&#39;s own agreement</text>')

    for i, r in enumerate(rows):
        row_y = TOP + i * ROW_H
        label = r["label"]
        sub = r.get("sublabel")

        ly = row_y + ROW_H / 2 + (-3 if sub else 4)
        o.append(f'<text x="{LABEL_W - 12}" y="{ly:.1f}" font-size="11.5" font-weight="600" '
                 f'fill="{t["text"]}" text-anchor="end">{_esc(label)}</text>')
        if sub:
            o.append(f'<text x="{LABEL_W - 12}" y="{row_y + ROW_H / 2 + 11:.1f}" font-size="10" '
                     f'fill="{t["muted"]}" text-anchor="end">{_esc(sub)}</text>')

        # Paired bars: F1 on top, groundedness below, 3px surface gap between them.
        pair_top = row_y + (ROW_H - (BAR_H * 2 + BAR_GAP)) / 2

        # Value labels sit on a small surface-colored plate: the mid-cluster of F1 bars ends
        # right at the dashed noise-floor line, which would otherwise cut through the digits.
        # An explicit <rect> is used rather than SVG paint-order (stroke halo) because
        # paint-order is not universally supported - cairosvg renders it as stroke-over-fill,
        # which erases the text entirely. A plate renders identically everywhere.
        def plate(px: float, py: float) -> str:
            return (f'<rect x="{px - 2:.1f}" y="{py - 9:.1f}" width="34" height="12" '
                    f'fill="{t["surface"]}"/>')

        f1_w = max(PLOT_W * r["mean_f1"], 2)
        f1_lx, f1_ly = LABEL_W + f1_w + 7, pair_top + BAR_H - 2.5
        o.append(f'<rect x="{LABEL_W}" y="{pair_top:.1f}" width="{f1_w:.1f}" height="{BAR_H}" '
                 f'rx="4" fill="{t["f1"]}"/>')
        o.append(plate(f1_lx, f1_ly))
        o.append(f'<text x="{f1_lx:.1f}" y="{f1_ly:.1f}" '
                 f'font-size="10.5" fill="{t["text"]}">{r["mean_f1"]:.3f}</text>')

        g = r.get("groundedness")
        if g is not None:
            gy = pair_top + BAR_H + BAR_GAP
            g_w = max(PLOT_W * g, 2)
            g_lx, g_ly = LABEL_W + g_w + 7, gy + BAR_H - 2.5
            o.append(f'<rect x="{LABEL_W}" y="{gy:.1f}" width="{g_w:.1f}" height="{BAR_H}" '
                     f'rx="4" fill="{t["grounded"]}"/>')
            o.append(plate(g_lx, g_ly))
            o.append(f'<text x="{g_lx:.1f}" y="{g_ly:.1f}" '
                     f'font-size="10.5" fill="{t["text2"]}">{g:.3f}</text>')

    o.append("</svg>")
    return "\n".join(o)


def build_rows(summary_df: pd.DataFrame, gold_model: str,
               groundedness: Dict[str, float]) -> List[Dict[str, Any]]:
    df = summary_df[summary_df["model"] != gold_model].copy()
    df = df.sort_values("mean_f1", ascending=False)

    rows = []
    for _, r in df.iterrows():
        level = r.get("thinking_level")
        rows.append({
            "label": r.get("family", r["model"]),
            "sublabel": level if isinstance(level, str) and level else None,
            "mean_f1": float(r["mean_f1"]),
            "groundedness": groundedness.get(r["model"]),
        })
    return rows


def main():
    p = argparse.ArgumentParser(description="Render static SVG leaderboards for the README")
    p.add_argument("--summary-csv", default="results/benchmark_report/summary.csv")
    p.add_argument("--groundedness-json", default="results/benchmark_report/groundedness_report.json")
    p.add_argument("--reference-agreement-json", default="results/benchmark/reference_agreement_report.json")
    p.add_argument("--gold-model", default="consensus-gold")
    p.add_argument("--out-dir", default="results/benchmark_report")
    args = p.parse_args()

    summary_df = pd.read_csv(args.summary_csv)

    groundedness = {}
    gp = Path(args.groundedness_json)
    if gp.exists():
        groundedness = _groundedness_means(json.load(open(gp, encoding="utf-8")))

    noise_floor = None
    rp = Path(args.reference_agreement_json)
    if rp.exists():
        report = json.load(open(rp, encoding="utf-8"))
        f1s = [v["f1"] for v in (report.get("agreement_micro") or {}).values()]
        if f1s:
            noise_floor = sum(f1s) / len(f1s)

    rows = build_rows(summary_df, args.gold_model, groundedness)

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    for theme in ("light", "dark"):
        path = out_dir / f"leaderboard-{theme}.svg"
        path.write_text(render_svg(rows, theme, noise_floor), encoding="utf-8")
        print(f"Wrote {path}")


if __name__ == "__main__":
    main()
