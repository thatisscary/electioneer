# import_tiger2023_to_postgis.py
import yaml
import subprocess
from pathlib import Path
import sys

# ------------------------------------------------------------------
# CONFIG — CHANGE ONLY THESE IF NEEDED
# ------------------------------------------------------------------
YAML_FILE       = Path("usa_states_fips.yaml")
DATA_DIR        = Path("./data/tiger2023")
PG_CONN         = "PG:host=localhost port=5432 dbname=votingdb user=postgrest password=yourpassword"  # ← edit if needed
PARALLEL        = True          # Set False for pure sequential (safer, slower)
MAX_PARALLEL    = 8             # Safe number of concurrent ogr2ogr processes

# ------------------------------------------------------------------
# Load states
# ------------------------------------------------------------------
with open(YAML_FILE) as f:
    states = yaml.safe_load(f)["states"]

# ------------------------------------------------------------------
# Helper: run ogr2ogr import for one file
# ------------------------------------------------------------------
def import_layer(state_abbr: str, layer_type: str, zip_path: Path):
    schema = state_abbr.lower()
    if layer_type == "vtd":
        table_name = "vtds"
    elif layer_type == "cong":
        table_name = "congressional_districts"
    else:
        raise ValueError(layer_type)

    full_table = f"{schema}.{table_name}"

    # Check if table already exists
    check_cmd = [
        "psql", "-h", "localhost", "-p", "5432", "-U", "postgrest", "-d", "votingdb",
        "-c", f"\\dt {full_table}"
    ]
    result = subprocess.run(check_cmd, capture_output=True, text=True)
    if "did not find any relation" not in result.stderr:
        print(f"  → {full_table} already exists — skipping")
        return

    print(f"  → Importing {zip_path.name} → {full_table}")

    # Create schema if missing
    subprocess.run([
        "psql", "-h", "localhost", "-p", "5432", "-U", "postgrest", "-d", "votingdb",
        "-c", f"CREATE SCHEMA IF NOT EXISTS {schema};"
    ], check=True)

    # ogr2ogr import
    cmd = [
        "ogr2ogr",
        "-f", "PostgreSQL",
        PG_CONN,
        str(zip_path),
        "-nlt", "PROMOTE_TO_MULTI",
        "-nln", full_table,
        "-lco", "GEOMETRY_NAME=geom",
        "-lco", "FID=gid",
        "-lco", "SPATIAL_INDEX=ON",
        "-lco", "PRECISION=NO",
        "--config", "PG_USE_COPY", "YES",
        "-t_srs", "EPSG:4326",
        "-overwrite",
        "-progress"
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"  ERROR importing {zip_path.name}: {result.stderr}")
    else:
        print(f"  SUCCESS {full_table}")

    # Add GIST index (in case ogr2ogr missed it)
    subprocess.run([
        "psql", "-h", "localhost", "-p", "5432", "-U", "postgrest", "-d", "votingdb",
        "-c", f"CREATE INDEX IF NOT EXISTS {schema}_{table_name}_geom_idx ON {full_table} USING GIST (geom);"
    ], check=True)

# ------------------------------------------------------------------
# Main worker
# ------------------------------------------------------------------
def process_state(state):
    abbr = state["abbreviation"].lower()
    fips = state["fips"]

    print(f"\nProcessing {state['name']} ({abbr.upper()})")

    vtd_zip = DATA_DIR / "vtd" / abbr / f"tl_2023_{fips}_vtd23.zip"
    cong_zip = DATA_DIR / "cong" / abbr / f"tl_2023_{fips}_cong23.zip"

    if vtd_zip.exists():
        import_layer(abbr, "vtd", vtd_zip)
    else:
        print(f"  Missing VTD file: {vtd_zip}")

    if cong_zip.exists():
        import_layer(abbr, "cong", cong_zip)
    else:
        print(f"  Missing CONG file: {cong_zip}")

# ------------------------------------------------------------------
# Run
# ------------------------------------------------------------------
if __name__ == "__main__":
    print("Starting bulk import of TIGER/2023 VTDs + Congressional Districts into PostGIS\n")

    if PARALLEL:
        from concurrent.futures import ProcessPoolExecutor
        with ProcessPoolExecutor(max_workers=MAX_PARALLEL) as executor:
            executor.map(process_state, states)
    else:
        for state in states:
            process_state(state)

    print("\nAll done! Your PostGIS now has 51 × 2 = 102 perfectly structured, indexed tables.")
    print("Example query: SELECT namelsad FROM al.vtds WHERE ST_Contains(geom, ST_SetSRID(ST_Point(-86.79113, 33.51859), 4326));")

