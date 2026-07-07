#!/bin/sh
set -e

export GRID_HOME="${GRID_HOME:-/config/.grid}"
export HOME="${HOME:-/config}"

# Ensure state directory exists
mkdir -p "${GRID_HOME}"

# Force local mode by writing the state file
cat > "${GRID_HOME}/state.json" <<EOF
{"mode": "local", "local_active_grid": null, "remote_active_grid": null}
EOF

# Run the grid server directly via Python — grid up spawns a daemon which
# doesn't work in a container. We initialize config and run uvicorn in foreground.
exec python -c "
import os, json, uuid
from pathlib import Path
from datetime import datetime, timezone

# Minimal grid config initialization without relying on grid CLI plumbing
grid_home = Path(os.environ.get('GRID_HOME', '/config/.grid'))
name = os.environ.get('GRID_NAME', 'home')
port = int(os.environ.get('GRID_PORT', '8090'))
host = os.environ.get('GRID_HOST', '0.0.0.0')

grid_id = f'ag-{name}-{uuid.uuid4().hex[:8]}'
grids_dir = grid_home / 'grids' / grid_id
grids_dir.mkdir(parents=True, exist_ok=True)

cfg = {
    'grid_id': grid_id,
    'name': name,
    'grid_type': 'lan-permissionless',
    'managed_server': True,
    'host': host,
    'port': port,
    'lan_signaling_url': f'http://{host}:{port}',
    'server_pid': os.getpid(),
    'created_at': datetime.now(timezone.utc).isoformat(),
    'updated_at': datetime.now(timezone.utc).isoformat(),
}

(grids_dir / 'config.json').write_text(json.dumps(cfg, indent=2))

# Update state to point at this grid
state = {'mode': 'local', 'local_active_grid': grid_id, 'remote_active_grid': None}
(grid_home / 'state.json').write_text(json.dumps(state, indent=2))

import uvicorn
from local.server import create_app
app = create_app(grid_id=grid_id, grid_name=name)
uvicorn.run(app, host=host, port=port)
"
