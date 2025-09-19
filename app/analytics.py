"""
Analytics Agent for Literature Mining

This module provides functions to query the database and generate insights:
- List all conductivity values with MXene composition
- Find papers with sensor applications  
- Plot histogram of conductivity values
- Various other analytics queries
"""

import logging
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from typing import List, Dict, Any, Optional
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.models import Paper, Material, Property, Application, get_session


class Analytics:
    """Analytics agent for querying and analyzing stored data"""
    
    def __init__(self):
        self.logger = logging.getLogger(__name__)
    
    def get_conductivity_data(self) -> pd.DataFrame:
        """Get all conductivity values with MXene composition"""
        session = get_session()
        
        try:
            # Query conductivity properties with material and paper info
            query = session.query(
                Paper.title,
                Paper.year,
                Material.mxene_composition,
                Material.composite_material,
                Property.value,
                Property.unit,
                Property.test_conditions
            ).join(
                Material, Paper.paper_id == Material.paper_id
            ).join(
                Property, Material.material_id == Property.material_id
            ).filter(
                Property.property_type == 'Conductivity'
            )
            
            results = query.all()
            
            # Convert to DataFrame
            df = pd.DataFrame(results, columns=[
                'title', 'year', 'mxene_composition', 'composite_material',
                'conductivity_value', 'unit', 'test_conditions'
            ])
            
            self.logger.info(f"Retrieved {len(df)} conductivity records")
            return df
            
        except Exception as e:
            self.logger.error(f"Error getting conductivity data: {e}")
            return pd.DataFrame()
        finally:
            session.close()
    
    def get_sensor_applications(self) -> pd.DataFrame:
        """Find papers with sensor applications"""
        session = get_session()
        
        try:
            query = session.query(
                Paper.title,
                Paper.authors,
                Paper.year,
                Paper.journal,
                Material.mxene_composition,
                Application.application_type,
                Application.metric,
                Application.value,
                Application.unit,
                Application.notes
            ).join(
                Material, Paper.paper_id == Material.paper_id
            ).join(
                Application, Material.material_id == Application.material_id
            ).filter(
                Application.application_type.ilike('%sensor%')
            )
            
            results = query.all()
            
            df = pd.DataFrame(results, columns=[
                'title', 'authors', 'year', 'journal', 'mxene_composition',
                'application_type', 'metric', 'value', 'unit', 'notes'
            ])
            
            self.logger.info(f"Retrieved {len(df)} sensor application records")
            return df
            
        except Exception as e:
            self.logger.error(f"Error getting sensor applications: {e}")
            return pd.DataFrame()
        finally:
            session.close()
    
    def get_property_statistics(self, property_type: str) -> Dict[str, Any]:
        """Get statistics for a specific property type"""
        session = get_session()
        
        try:
            query = session.query(Property).filter(
                Property.property_type == property_type,
                Property.value.isnot(None)
            )
            
            values = [prop.value for prop in query.all()]
            
            if not values:
                return {}
            
            stats = {
                'count': len(values),
                'mean': sum(values) / len(values),
                'min': min(values),
                'max': max(values),
                'median': sorted(values)[len(values) // 2]
            }
            
            return stats
            
        except Exception as e:
            self.logger.error(f"Error getting property statistics: {e}")
            return {}
        finally:
            session.close()
    
    def get_mxene_composition_distribution(self) -> pd.DataFrame:
        """Get distribution of MXene compositions"""
        session = get_session()
        
        try:
            query = session.query(
                Material.mxene_composition,
                func.count(Material.material_id).label('count')
            ).filter(
                Material.mxene_composition != ''
            ).group_by(
                Material.mxene_composition
            ).order_by(
                func.count(Material.material_id).desc()
            )
            
            results = query.all()
            
            df = pd.DataFrame(results, columns=['mxene_composition', 'count'])
            
            self.logger.info(f"Retrieved {len(df)} unique MXene compositions")
            return df
            
        except Exception as e:
            self.logger.error(f"Error getting MXene composition distribution: {e}")
            return pd.DataFrame()
        finally:
            session.close()
    
    def get_yearly_publication_trends(self) -> pd.DataFrame:
        """Get publication trends by year"""
        session = get_session()
        
        try:
            query = session.query(
                Paper.year,
                func.count(Paper.paper_id).label('count')
            ).filter(
                Paper.year.isnot(None)
            ).group_by(
                Paper.year
            ).order_by(
                Paper.year
            )
            
            results = query.all()
            
            df = pd.DataFrame(results, columns=['year', 'count'])
            
            return df
            
        except Exception as e:
            self.logger.error(f"Error getting publication trends: {e}")
            return pd.DataFrame()
        finally:
            session.close()
    
    def plot_conductivity_histogram(self, save_path: Optional[str] = None):
        """Plot histogram of conductivity values"""
        df = self.get_conductivity_data()
        
        if df.empty:
            self.logger.warning("No conductivity data available for plotting")
            return
        
        plt.figure(figsize=(10, 6))
        
        # Convert decimal values to float for matplotlib
        values = df['conductivity_value'].dropna()
        values = values.astype(float)  # Convert Decimal to float
        
        # Filter out extreme outliers for better visualization
        q1 = values.quantile(0.25)
        q3 = values.quantile(0.75)
        iqr = q3 - q1
        lower_bound = q1 - 1.5 * iqr
        upper_bound = q3 + 1.5 * iqr
        
        filtered_values = values[(values >= lower_bound) & (values <= upper_bound)]
        
        plt.hist(filtered_values, bins=20, alpha=0.7, edgecolor='black')
        plt.xlabel('Conductivity (S/m)')
        plt.ylabel('Frequency')
        plt.title('Distribution of MXene Conductivity Values')
        plt.grid(True, alpha=0.3)
        
        # Add statistics text
        stats_text = f'Count: {len(filtered_values)}\nMean: {filtered_values.mean():.2f}\nMedian: {filtered_values.median():.2f}'
        plt.text(0.7, 0.8, stats_text, transform=plt.gca().transAxes, 
                verticalalignment='top', bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))
        
        plt.tight_layout()
        
        if save_path:
            plt.savefig(save_path, dpi=300, bbox_inches='tight')
            self.logger.info(f"Conductivity histogram saved to {save_path}")
        
        plt.show()
    
    def plot_mxene_composition_distribution(self, save_path: Optional[str] = None):
        """Plot MXene composition distribution"""
        df = self.get_mxene_composition_distribution()
        
        if df.empty:
            self.logger.warning("No MXene composition data available for plotting")
            return
        
        plt.figure(figsize=(12, 6))
        
        # Show top 10 compositions
        top_compositions = df.head(10)
        
        plt.bar(range(len(top_compositions)), top_compositions['count'])
        plt.xlabel('MXene Composition')
        plt.ylabel('Number of Papers')
        plt.title('Top 10 MXene Compositions in Literature')
        plt.xticks(range(len(top_compositions)), top_compositions['mxene_composition'], rotation=45)
        plt.grid(True, alpha=0.3)
        
        plt.tight_layout()
        
        if save_path:
            plt.savefig(save_path, dpi=300, bbox_inches='tight')
            self.logger.info(f"MXene composition plot saved to {save_path}")
        
        plt.show()
    
    def generate_summary_report(self) -> str:
        """Generate a comprehensive summary report"""
        try:
            # Get basic statistics
            session = get_session()
            
            total_papers = session.query(Paper).count()
            total_materials = session.query(Material).count()
            total_properties = session.query(Property).count()
            total_applications = session.query(Application).count()
            
            # Get property type distribution
            property_types = session.query(
                Property.property_type,
                func.count(Property.property_id).label('count')
            ).group_by(Property.property_type).all()
            
            # Get application type distribution
            app_types = session.query(
                Application.application_type,
                func.count(Application.app_id).label('count')
            ).group_by(Application.application_type).all()
            
            session.close()
            
            # Generate report
            report = f"""
Literature Mining Database Summary Report
========================================

Database Overview:
- Total Papers: {total_papers}
- Total Materials: {total_materials}
- Total Properties: {total_properties}
- Total Applications: {total_applications}

Property Types Distribution:
"""
            
            for prop_type, count in property_types:
                report += f"- {prop_type}: {count}\n"
            
            report += "\nApplication Types Distribution:\n"
            for app_type, count in app_types:
                report += f"- {app_type}: {count}\n"
            
            # Add conductivity statistics
            conductivity_stats = self.get_property_statistics('Conductivity')
            if conductivity_stats:
                report += f"\nConductivity Statistics:\n"
                report += f"- Count: {conductivity_stats['count']}\n"
                report += f"- Mean: {conductivity_stats['mean']:.2f} S/m\n"
                report += f"- Min: {conductivity_stats['min']:.2f} S/m\n"
                report += f"- Max: {conductivity_stats['max']:.2f} S/m\n"
                report += f"- Median: {conductivity_stats['median']:.2f} S/m\n"
            
            return report
            
        except Exception as e:
            self.logger.error(f"Error generating summary report: {e}")
            return "Error generating report"
    
    def export_data_to_csv(self, output_dir: str):
        """Export all data to CSV files"""
        try:
            # Export conductivity data
            conductivity_df = self.get_conductivity_data()
            if not conductivity_df.empty:
                conductivity_path = f"{output_dir}/conductivity_data.csv"
                conductivity_df.to_csv(conductivity_path, index=False)
                self.logger.info(f"Conductivity data exported to {conductivity_path}")
            
            # Export sensor applications
            sensor_df = self.get_sensor_applications()
            if not sensor_df.empty:
                sensor_path = f"{output_dir}/sensor_applications.csv"
                sensor_df.to_csv(sensor_path, index=False)
                self.logger.info(f"Sensor applications exported to {sensor_path}")
            
            # Export MXene composition distribution
            composition_df = self.get_mxene_composition_distribution()
            if not composition_df.empty:
                composition_path = f"{output_dir}/mxene_compositions.csv"
                composition_df.to_csv(composition_path, index=False)
                self.logger.info(f"MXene compositions exported to {composition_path}")
            
        except Exception as e:
            self.logger.error(f"Error exporting data to CSV: {e}")
    
    def evaluate_property_relevance(self, batch_size: int = 5) -> pd.DataFrame:
        """
        Evaluate relevance between paper abstracts/conclusions and extracted properties.
        
        Args:
            batch_size: Number of papers to process in each batch
            
        Returns:
            DataFrame with paper_id, material_id, property_id, relevance_score (0 or 1)
        """
        from app.llm_interface import LLMInterface
        
        session = get_session()
        evaluation_results = []
        
        try:
            # Query all papers with their materials and properties
            query = session.query(
                Paper.paper_id,
                Paper.title,
                Paper.abstract,
                Paper.conclusion,
                Material.material_id,
                Material.mxene_composition,
                Property.property_id,
                Property.property_type,
                Property.value,
                Property.unit,
                Property.test_conditions
            ).join(
                Material, Paper.paper_id == Material.paper_id
            ).join(
                Property, Material.material_id == Property.material_id
            )
            
            results = query.all()
            
            if not results:
                self.logger.warning("No papers with properties found for evaluation")
                return pd.DataFrame()
            
            self.logger.info(f"Found {len(results)} paper-property combinations to evaluate")
            
            # Initialize LLM interface
            llm = LLMInterface()
            
            # Process in batches to avoid overwhelming the LLM
            for i in range(0, len(results), batch_size):
                batch = results[i:i + batch_size]
                self.logger.info(f"Processing batch {i//batch_size + 1}/{(len(results) + batch_size - 1)//batch_size}")
                
                for result in batch:
                    try:
                        paper_id, title, abstract, conclusion, material_id, mxene_comp, \
                        property_id, prop_type, prop_value, prop_unit, test_conditions = result
                        
                        # Skip if abstract or conclusion is missing
                        if not abstract and not conclusion:
                            self.logger.warning(f"Paper {paper_id} has no abstract or conclusion, skipping")
                            continue
                        
                        # Combine abstract and conclusion
                        text_content = ""
                        if abstract:
                            text_content += f"Abstract: {abstract}\n\n"
                        if conclusion:
                            text_content += f"Conclusion: {conclusion}"
                        
                        # Format property information
                        property_info = f"Property Type: {prop_type}"
                        if prop_value is not None:
                            property_info += f", Value: {prop_value}"
                        if prop_unit:
                            property_info += f" {prop_unit}"
                        if test_conditions:
                            property_info += f", Test Conditions: {test_conditions}"
                        if mxene_comp:
                            property_info += f", MXene Composition: {mxene_comp}"
                        
                        # Create evaluation prompt
                        prompt = self._create_evaluation_prompt(text_content, property_info)
                        
                        # Get LLM evaluation
                        response = llm.generate_response(prompt)
                        
                        if response:
                            # Extract JSON response
                            parsed_response = llm.extract_json_from_response(response)
                            
                            if parsed_response and 'relevance_score' in parsed_response:
                                score = int(parsed_response['relevance_score'])
                                # Ensure score is binary (0 or 1)
                                score = 1 if score > 0 else 0
                                
                                evaluation_results.append({
                                    'paper_id': paper_id,
                                    'material_id': material_id,
                                    'property_id': property_id,
                                    'property_type': prop_type,
                                    'mxene_composition': mxene_comp,
                                    'relevance_score': score,
                                    'reasoning': parsed_response.get('reasoning', ''),
                                    'title': title
                                })
                                
                                self.logger.debug(f"Paper {paper_id}, Property {property_id}: Score {score}")
                            else:
                                self.logger.warning(f"Failed to parse evaluation for paper {paper_id}, property {property_id}")
                                # Default to 0 if evaluation fails
                                evaluation_results.append({
                                    'paper_id': paper_id,
                                    'material_id': material_id,
                                    'property_id': property_id,
                                    'property_type': prop_type,
                                    'mxene_composition': mxene_comp,
                                    'relevance_score': 0,
                                    'reasoning': 'Evaluation failed',
                                    'title': title
                                })
                        else:
                            self.logger.warning(f"No response from LLM for paper {paper_id}, property {property_id}")
                            evaluation_results.append({
                                'paper_id': paper_id,
                                'material_id': material_id,
                                'property_id': property_id,
                                'property_type': prop_type,
                                'mxene_composition': mxene_comp,
                                'relevance_score': 0,
                                'reasoning': 'No LLM response',
                                'title': title
                            })
                            
                    except Exception as e:
                        self.logger.error(f"Error evaluating paper {paper_id}, property {property_id}: {e}")
                        continue
            
            # Convert to DataFrame
            df = pd.DataFrame(evaluation_results)
            
            if not df.empty:
                self.logger.info(f"Evaluation completed. Average relevance score: {df['relevance_score'].mean():.2f}")
                self.logger.info(f"Total relevant properties: {df['relevance_score'].sum()}/{len(df)}")
            
            return df
            
        except Exception as e:
            self.logger.error(f"Error in property relevance evaluation: {e}")
            return pd.DataFrame()
        
        finally:
            session.close()
    
    def _create_evaluation_prompt(self, text_content: str, property_info: str) -> str:
        """Create prompt for evaluating relevance between text and property"""
        prompt = f"""
You are a scientific literature analysis expert. Your task is to determine if the extracted property information is relevant to and supported by the given abstract and conclusion text.

**Text Content:**
{text_content}

**Extracted Property Information:**
{property_info}

**Instructions:**
1. Carefully read the abstract and conclusion text
2. Analyze if the extracted property information is:
   - Explicitly mentioned or discussed in the text
   - Relevant to the research topic and findings
   - Supported by the experimental work described
3. Consider that properties might be mentioned indirectly through related concepts or applications

**Evaluation Criteria:**
- Score 1 (Relevant) if:
  - The property type is explicitly mentioned in the text
  - The property is directly related to the main research focus
  - The text discusses measurements, characterization, or applications related to this property
  - The property values or test conditions align with what's described in the text

- Score 0 (Not Relevant) if:
  - The property type is not mentioned or discussed in the text
  - The property seems unrelated to the research described
  - The extracted property appears to be an error or misinterpretation
  - There's no clear connection between the text content and the property

**Response Format:**
Please respond with valid JSON only:
{{
    "relevance_score": 0 or 1,
    "reasoning": "Brief explanation for your decision (max 2 sentences)"
}}
"""
        return prompt
    
    def generate_evaluation_report(self, evaluation_df: pd.DataFrame, output_path: str = None) -> str:
        """
        Generate a comprehensive evaluation report
        
        Args:
            evaluation_df: DataFrame from evaluate_property_relevance()
            output_path: Optional path to save the report
            
        Returns:
            Report string
        """
        try:
            if evaluation_df.empty:
                return "No evaluation data available"
            
            report_lines = []
            report_lines.append("=" * 60)
            report_lines.append("PROPERTY RELEVANCE EVALUATION REPORT")
            report_lines.append("=" * 60)
            report_lines.append("")
            
            # Overall statistics
            total_evaluations = len(evaluation_df)
            relevant_count = evaluation_df['relevance_score'].sum()
            relevance_rate = (relevant_count / total_evaluations) * 100
            
            report_lines.append("OVERALL STATISTICS:")
            report_lines.append(f"Total Evaluations: {total_evaluations}")
            report_lines.append(f"Relevant Properties: {relevant_count}")
            report_lines.append(f"Not Relevant Properties: {total_evaluations - relevant_count}")
            report_lines.append(f"Relevance Rate: {relevance_rate:.1f}%")
            report_lines.append("")
            
            # Statistics by property type
            if 'property_type' in evaluation_df.columns:
                report_lines.append("RELEVANCE BY PROPERTY TYPE:")
                prop_stats = evaluation_df.groupby('property_type').agg({
                    'relevance_score': ['count', 'sum', 'mean']
                }).round(2)
                
                for prop_type in prop_stats.index:
                    count = prop_stats.loc[prop_type, ('relevance_score', 'count')]
                    relevant = prop_stats.loc[prop_type, ('relevance_score', 'sum')]
                    rate = prop_stats.loc[prop_type, ('relevance_score', 'mean')] * 100
                    report_lines.append(f"  {prop_type}: {relevant}/{count} ({rate:.1f}%)")
                report_lines.append("")
            
            # Low relevance papers (potential issues)
            report_lines.append("PAPERS WITH LOW RELEVANCE SCORES:")
            paper_relevance = evaluation_df.groupby(['paper_id', 'title']).agg({
                'relevance_score': ['count', 'sum', 'mean']
            }).round(2)
            
            low_relevance_papers = paper_relevance[
                paper_relevance[('relevance_score', 'mean')] < 0.5
            ].sort_values(('relevance_score', 'mean'))
            
            if not low_relevance_papers.empty:
                for (paper_id, title) in low_relevance_papers.index[:10]:  # Top 10
                    count = low_relevance_papers.loc[(paper_id, title), ('relevance_score', 'count')]
                    relevant = low_relevance_papers.loc[(paper_id, title), ('relevance_score', 'sum')]
                    rate = low_relevance_papers.loc[(paper_id, title), ('relevance_score', 'mean')] * 100
                    report_lines.append(f"  Paper {paper_id}: {relevant}/{count} ({rate:.1f}%) - {title[:80]}...")
            else:
                report_lines.append("  No papers with consistently low relevance scores found.")
            report_lines.append("")
            
            # Sample of irrelevant extractions
            irrelevant = evaluation_df[evaluation_df['relevance_score'] == 0]
            if not irrelevant.empty:
                report_lines.append("SAMPLE OF IRRELEVANT EXTRACTIONS:")
                sample_size = min(5, len(irrelevant))
                sample = irrelevant.sample(n=sample_size)
                
                for _, row in sample.iterrows():
                    report_lines.append(f"  Paper {row['paper_id']}: {row['property_type']}")
                    if 'reasoning' in row and row['reasoning']:
                        report_lines.append(f"    Reason: {row['reasoning']}")
                report_lines.append("")
            
            # Recommendations
            report_lines.append("RECOMMENDATIONS:")
            if relevance_rate < 70:
                report_lines.append("  - Consider improving extraction prompts or validation logic")
                report_lines.append("  - Review papers with consistently low relevance scores")
            if relevance_rate > 95:
                report_lines.append("  - Evaluation criteria might be too lenient")
                report_lines.append("  - Consider making evaluation more stringent")
            else:
                report_lines.append("  - Relevance rate appears reasonable")
                report_lines.append("  - Continue monitoring extraction quality")
            
            report = "\n".join(report_lines)
            
            # Save report if path provided
            if output_path:
                with open(output_path, 'w', encoding='utf-8') as f:
                    f.write(report)
                self.logger.info(f"Evaluation report saved to {output_path}")
            
            return report
            
        except Exception as e:
            self.logger.error(f"Error generating evaluation report: {e}")
            return f"Error generating evaluation report: {e}"
