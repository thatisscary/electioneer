# download_tiger2023.py
import yaml
import asyncio
import aiohttp
from pathlib import Path
import sys

# ------------------------------------------------------------------
# Config
# ------------------------------------------------------------------
YAML_FILE = Path("usa_states_fips.yaml")          # <-- your file from earlier
BASE_DIR = Path("./data/tiger2023")
BASE_URL = "https://www2.census.gov/geo/tiger/TIGER2023"

# Create output dirs
VTD_DIR = BASE_DIR / "vtd"
CONG_DIR = BASE_DIR / "cong"
VTD_DIR.mkdir(parents=True, exist_ok=True)
CONG_DIR.mkdir(parents=True, exist_ok=True)

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

        for state in states:
            fips = state["fips"]
            abbr = state["abbreviation"].lower()

            # 1. Voting Districts
            vtd_url = f"{BASE_URL}/VTD/tl_2023_{fips}_vtd23.zip"
            vtd_path = VTD_DIR / abbr / f"tl_2023_{fips}_vtd23.zip"

            # 2. Congressional Districts
            cong_url = f"{BASE_URL}/CONG/tl_2023_{fips}_cong23.zip"
            cong_path = CONG_DIR / abbr / f"tl_2023_{fips}_cong23.zip"

            tasks.append(download_file(session, vtd_url, vtd_path))
            tasks.append(download_file(session, cong_url, cong_path))

        # Run all downloads in parallel (max ~20 concurrent is safe)
        for i in range(0, len(tasks), 20):
            await asyncio.gather(*tasks[i:i+20])

if __name__ == "__main__":
    print(f"Starting download of 102 TIGER/2023 files (51 states × 2 layers)...")
    asyncio.run(main())
    print("All done!"
)
