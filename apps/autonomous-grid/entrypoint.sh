#!/bin/sh
set -e

# Initialize the grid in local mode and run the server in the foreground.
# grid up normally detaches; we use the internal __server command directly
# after initializing the config via `grid up` (which will fail to health-check
# since it expects detached mode, but the config will be written).

export GRID_HOME="${GRID_HOME:-/config/.grid}"

# Ensure local mode
grid mode local 2>/dev/null || true

# Create the grid config if it doesn't exist, then run the server foreground.
# We use python to call the server directly since `grid up` spawns a daemon.
exec python -c "
import uvicorn
from local.server import create_app
from local import config, runtime

import os

name = os.environ.get('GRID_NAME', 'home')
port = int(os.environ.get('GRID_PORT', '8090'))
host = os.environ.get('GRID_HOST', '0.0.0.0')

# Initialize grid config
cfg = config.select_grid(name)
if not cfg:
    cfg = runtime.init_grid_config(name=name, port=port, host=host)
    config.select_grid_by_id(cfg['grid_id'])

app = create_app(grid_id=cfg['grid_id'], grid_name=cfg['name'])
uvicorn.run(app, host=host, port=port)
"
