#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import requests
from datetime import datetime
from urllib.parse import urlparse

HEADER = """# Scratch520 Hosts Start
# Last updated: {update_time}
# Project URL: https://github.com/yhjyhjlqx/Scratch520
# 此文件由Scratch520项目自动生成，请勿手动修改

"""
FOOTER = """
# Scratch520 Hosts End
"""

SCRATCH_DOMAINS_URL = "https://raw.githubusercontent.com/yhjyhjlqx/Scratch520/main/domains.txt"

def fetch_domains():
    """获取域名列表"""
    try:
        with open('domains.txt', 'r', encoding='utf-8') as f:
            domains = [line.strip() for line in f if line.strip() and not line.startswith('#')]
        if not domains:
            raise FileNotFoundError()
        return domains
    except:
        try:
            response = requests.get(SCRATCH_DOMAINS_URL, timeout=10)
            response.raise_for_status()
            return [line.strip() for line in response.text.split('\n') if line.strip() and not line.startswith('#')]
        except:
            return [
                "scratch.mit.edu",
                "api.scratch.mit.edu",
                "projects.scratch.mit.edu",
                "assets.scratch.mit.edu"
            ]

def generate_hosts_content():
    """生成hosts文件内容"""
    update_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    domains = fetch_domains()
    
    try:
        ip_info = requests.get('https://api.ipify.org?format=json', timeout=5).json()
        target_ip = ip_info.get('ip', '127.0.0.1')
    except:
        target_ip = '127.0.0.1'
    
    content = HEADER.format(update_time=update_time)
    content += "\n".join([f"{target_ip} {domain}" for domain in domains])
    content += FOOTER
    
    return content

def update_hosts_file():
    """更新hosts文件"""
    content = generate_hosts_content()
    with open("hosts", "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Scratch520 Hosts文件已更新，使用IP: {content.split()[4]}")

if __name__ == "__main__":
    update_hosts_file()
