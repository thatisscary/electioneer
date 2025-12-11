# download_tiger_files.py
# ------------------------------------------------------------------    
import yaml
import asyncio
import aiohttp
from pathlib import Path
import sys
import datetime
import argparse
from file_definitions import definitions as get_definitions
from file_definitions import data_file_def
# ------------------------------------------------------------------
# Config
# ------------------------------------------------------------------


parser = argparse.ArgumentParser(
    prog='create_structure.py',
    usage='%(prog)s [options]',
    description='Creates a default structure for uncovered domains. Creates default structure... ',
    epilog='''
            Example usage: create_structure.py --domain_root ./my_project/domains''')
parser.add_argument('-y','--year', type=str, required=True, help='The year for which to download TIGER files.')
args = parser.parse_args()
def check_arguments():
    year = args.year
    
    if year  > datetime.datetime.now().year:
        print(f"Error: Invalid year '{year}'. Year must be the current year or earlier.")
        sys.exit(1)
    return year


YAML_FILE = Path("usa_states_fips.yaml")          # <-- your file from earlier
BASE_DIR = Path(f"./data/tiger{args.year}")              # <-- your desired output directory
BASE_URL = f"https://www2.census.gov/geo/tiger/TIGER{args.year}"

# Create output dirs

BASE_DIR.mkdir(parents=True, exist_ok=True)



# ------------------------------------------------------------------
# Load states
# ------------------------------------------------------------------
with open(YAML_FILE) as f:
    states = yaml.safe_load(f)["states"]

# ------------------------------------------------------------------
# Async downloader
# ------------------------------------------------------------------
async def download_file(session, url, dest_path):
    if dest_path.exists():
        print(f"✓ Already exists: {dest_path.name}")
        return

    print(f"↓ Downloading {dest_path.name} ...")
    try:
        async with session.get(url) as resp:
            if resp.status == 200:
                dest_path.parent.mkdir(parents=True, exist_ok=True)
                with open(dest_path, "wb") as f:
                    async for chunk in resp.content.iter_chunked(1024*1024):
                        f.write(chunk)
                print(f"  Saved {dest_path}")
            else:
                print(f"  Failed {url} → HTTP {resp.status}")
    except Exception as e:
        print(f"  Error {url}: {e}")

async def main():
    async with aiohttp.ClientSession(timeout=aiohttp.ClientTimeout(total=600)) as session:
        tasks = []
        definitions = get_definitions()
        for state in states:
            fips = state["fips"]
            abbr = state["abbreviation"].lower()
            for data_def in definitions:
                print("Downloading:", data_def.description, "for", state["name"])
                url = f"{BASE_URL}/{data_def.path}/{data_def.zip_path.format(fips)}"
                dest_path = BASE_DIR / data_def.path.lower() / abbr / data_def.zip_path.format(fips)
                dest_path.parent.mkdir(parents=True, exist_ok=True)
                tasks.append(download_file(session, url, dest_path))
            
        # Run all downloads in parallel (max ~20 concurrent is safe)
        for i in range(0, len(tasks), 20):
            await asyncio.gather(*tasks[i:i+20])

if __name__ == "__main__":
    print(f"Starting download of TIGER/{args.year} files (50 states + 6 territories x 3 layers)...")
    asyncio.run(main())
    print("All done!")
