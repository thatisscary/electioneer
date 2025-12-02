#!/usr/bin/env bash
set -euo pipefail

pip install pyyaml
pip install asyncio
pip install aiohttp



echo "Downloading TIGER/2023 files..."
python download_tiger2023.py

echo "Creating import volume symlink..."
mkdir -p ./domains/Boundary/persistence/sql/imports
ln -sf "$(pwd)/data/tiger2023" ./domains/Boundary/persistence/sql/imports/tiger2023

echo "Starting PostGIS (if not running)..."
docker compose up -d postgis

echo "Waiting for PostGIS to be ready..."
until pg_isready -h localhost -p 5432 -U electioneer; do
  sleep 2
done

echo "Running full import..."
python import_tiger2023_to_postgis.py

echo "All done! You now have boundary.vtd2023.* and boundary.cd118.us_cd118 tables."
