#!/usr/bin/env bash
set -euo pipefail

pip install pyyaml
pip install asyncio
pip install aiohttp
pip install argparse

year ="${1:-2025}"

echo "Downloading TIGER/${year} files..."
python download_tiger_files.py -y "${year}"

echo "Creating import volume symlink..."
mkdir -p ./domains/Boundary/persistence/sql/imports
ln -sf "$(pwd)/data/tiger${year}" ./domains/Boundary/persistence/sql/imports/tiger${year}
echo "Starting PostGIS (if not running)..."
docker compose up -d postgis

echo "Waiting for PostGIS to be ready..."
until pg_isready -h localhost -p 5432 -U electioneer; do
  sleep 2
done

echo "Running full import..."
python import_tiger_to_postgis.py -y "${year}"

echo "All done! You now have boundary.vtd${year}.* and boundary.cd118.us_cd118 tables."
