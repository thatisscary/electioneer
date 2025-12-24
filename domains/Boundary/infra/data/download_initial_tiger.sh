#! /bin/bash

pip install aiohttp 
pip install pyyaml 
pip install argparse

python download_tiger2023.py -y "${1:-2025}"
