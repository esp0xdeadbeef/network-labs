#!/usr/bin/env bash
set -euo pipefail
# LAB-SMT-ID: LAB-SMT-021
# LAB-SMT-SCOPE: examples-only; see tests/SMT.md

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - "${repo_root}" <<'PY'
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])

expected = {
    "single-wan": "198.18.0.1/24",
    "single-wan-any-to-any-fw": "198.18.0.1/24",
    "single-wan-bgp": "198.18.0.1/24",
    "single-wan-uplink-ebgp": "198.18.0.1/24",
    "single-wan-uplink-static-egress": "192.0.2.1/24",
    "single-wan-with-nebula": "198.18.0.1/24",
}

for example, address in sorted(expected.items()):
    text = (root / "examples" / example / "inventory-clab.nix").read_text()
    match = re.search(r'uplink0 = \{([^{}]|\{[^{}]*\})*bridge = "br-uplink0";([^{}]|\{[^{}]*\})*\};', text)
    if not match:
        raise SystemExit(f"{example}: missing uplink0 br-uplink0 inventory")
    block = match.group(0)
    required = [
        'mode = "nat";',
        'parent = "eth0";',
        f'address = "{address}";',
        'method = "dhcp";',
    ]
    missing = [needle for needle in required if needle not in block]
    if missing:
        raise SystemExit(f"{example}: missing explicit CLAB NAT realization fields: {missing}")

print("PASS clab-nat-uplink-examples")
PY
