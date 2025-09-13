#!/usr/bin/env python3
"""
Demo runner for Literature Mining LLM - processes only 5 papers
"""

import subprocess
import sys
from pathlib import Path

def main():
    """Run the literature mining pipeline in demo mode"""
    script_dir = Path(__file__).parent
    main_script = script_dir / "main.py"
    
    print("🚀 Starting Literature Mining LLM Demo (5 papers)")
    print("=" * 50)
    
    # Run main.py with demo flag
    try:
        result = subprocess.run([
            sys.executable, str(main_script), "--demo"
        ], cwd=str(script_dir))
        
        if result.returncode == 0:
            print("✅ Demo completed successfully!")
        else:
            print("❌ Demo failed!")
            sys.exit(1)
            
    except KeyboardInterrupt:
        print("\n🛑 Demo interrupted by user")
        sys.exit(0)
    except Exception as e:
        print(f"❌ Error running demo: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
