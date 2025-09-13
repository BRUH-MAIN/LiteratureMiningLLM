#!/usr/bin/env python3
"""
Network diagnostic script for LM Studio connectivity
"""

import os
import socket
import subprocess
import requests
from dotenv import load_dotenv

load_dotenv()

def test_network_connectivity():
    """Test basic network connectivity to LM Studio"""
    
    lm_studio_url = os.getenv('LM_STUDIO_PORT', 'http://localhost:1234')
    ip_address = os.getenv('IP_ADDRESS', '10.174.244.51')
    
    # Extract IP and port from URL
    if 'http://' in lm_studio_url:
        url_part = lm_studio_url.replace('http://', '')
        if ':' in url_part:
            ip, port = url_part.split(':')
            port = int(port)
        else:
            ip = url_part
            port = 1234
    else:
        ip = ip_address
        port = 1234
    
    print(f"🔍 Network Diagnostics for LM Studio")
    print(f"Target IP: {ip}")
    print(f"Target Port: {port}")
    print(f"Full URL: {lm_studio_url}")
    print("-" * 50)
    
    # Test 1: Ping test
    print("1. Testing basic connectivity (ping)...")
    try:
        result = subprocess.run(['ping', '-c', '3', ip], 
                              capture_output=True, text=True, timeout=15)
        if result.returncode == 0:
            print(f"   ✅ Ping successful!")
            # Extract ping time if available
            lines = result.stdout.split('\n')
            for line in lines:
                if 'time=' in line:
                    print(f"   {line.strip()}")
        else:
            print(f"   ❌ Ping failed!")
            print(f"   Error: {result.stderr}")
    except Exception as e:
        print(f"   ❌ Ping test failed: {e}")
    
    # Test 2: Port connectivity test
    print(f"2. Testing port {port} connectivity...")
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(10)
        result = sock.connect_ex((ip, port))
        sock.close()
        
        if result == 0:
            print(f"   ✅ Port {port} is open and reachable!")
        else:
            print(f"   ❌ Port {port} is not reachable (error code: {result})")
    except Exception as e:
        print(f"   ❌ Port test failed: {e}")
    
    # Test 3: HTTP GET test
    print("3. Testing HTTP connectivity...")
    try:
        simple_url = f"http://{ip}:{port}"
        response = requests.get(simple_url, timeout=10)
        print(f"   ✅ HTTP connection successful! Status: {response.status_code}")
    except requests.exceptions.ConnectTimeout:
        print(f"   ❌ HTTP connection timed out")
    except requests.exceptions.ConnectionError as e:
        print(f"   ❌ HTTP connection failed: {e}")
    except Exception as e:
        print(f"   ❌ HTTP test failed: {e}")
    
    # Test 4: Alternative URLs
    print("4. Testing alternative endpoints...")
    alternative_ips = [
        os.getenv('IP_ADDRESS', '10.174.244.51'),  # From IP_ADDRESS env var
        '10.12.234.53',  # From LM_STUDIO_PORT
    ]
    
    for alt_ip in set(alternative_ips):  # Remove duplicates
        if alt_ip != ip:  # Don't test the same IP again
            print(f"   Testing alternative IP: {alt_ip}")
            try:
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                sock.settimeout(5)
                result = sock.connect_ex((alt_ip, port))
                sock.close()
                
                if result == 0:
                    print(f"   ✅ Alternative IP {alt_ip}:{port} is reachable!")
                else:
                    print(f"   ❌ Alternative IP {alt_ip}:{port} not reachable")
            except Exception as e:
                print(f"   ❌ Alternative IP test failed: {e}")
    
    print("-" * 50)
    print("🔧 Troubleshooting suggestions:")
    print("1. Verify LM Studio is running on the remote device")
    print("2. Check if LM Studio server is started and listening on the correct port")
    print("3. Verify firewall settings allow connections on port 1234")
    print("4. Confirm the IP address is correct and reachable")
    print("5. Try accessing http://IP:PORT directly in a web browser")
    print("6. Check if the remote device is on the same network")

if __name__ == "__main__":
    test_network_connectivity()
