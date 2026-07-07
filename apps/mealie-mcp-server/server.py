"""
Wrapper for mealie-mcp-server that patches file logging to stdout.
"""
import logging
import sys
import os

# Patch: redirect any file-based log handler to stderr before importing the server
# This prevents the upstream code from writing to /app/mealie_mcp_server.log
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stderr)],
    force=True,
)

# Monkey-patch FileHandler to redirect to stderr
_original_file_handler = logging.FileHandler

class StdoutFileHandler(logging.StreamHandler):
    """Replaces FileHandler with a StreamHandler to stderr."""
    def __init__(self, filename, mode='a', encoding=None, delay=False, errors=None):
        super().__init__(sys.stderr)

logging.FileHandler = StdoutFileHandler

# Now import and run the actual server
from mealie_mcp_server.server import mcp

# Export for fastmcp discovery
app = mcp
