"""
Simple progress monitor for the literature mining pipeline
"""

import time
import os
from pathlib import Path

def monitor_progress():
    """Monitor the progress by checking the latest log file"""
    log_dir = Path("/home/bharath/Documents/Material/project/LiteratureMiningLLM/logs")
    
    # Find the most recent log file
    log_files = list(log_dir.glob("literature_mining_*.log"))
    if not log_files:
        print("No log files found")
        return
    
    latest_log = max(log_files, key=os.path.getctime)
    print(f"Monitoring: {latest_log.name}")
    
    last_position = 0
    
    while True:
        try:
            with open(latest_log, 'r') as f:
                f.seek(last_position)
                new_content = f.read()
                
                if new_content:
                    # Print only progress-related lines
                    for line in new_content.strip().split('\n'):
                        if any(keyword in line for keyword in ['Progress:', 'Processing paper', 'Extraction completed', 'Database loading completed', 'Pipeline completed']):
                            print(line.split(' - ')[-1] if ' - ' in line else line)
                    
                    last_position = f.tell()
                
                # Check if pipeline is complete
                if 'Pipeline completed successfully!' in new_content:
                    print("\n🎉 Pipeline completed successfully!")
                    break
                    
        except FileNotFoundError:
            print("Log file not found")
            break
        except KeyboardInterrupt:
            print("\nMonitoring stopped")
            break
            
        time.sleep(2)  # Check every 2 seconds

if __name__ == "__main__":
    monitor_progress()
