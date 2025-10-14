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
