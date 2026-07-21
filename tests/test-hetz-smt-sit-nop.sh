#!/usr/bin/env bash
set -euo pipefail

exec "$(dirname "${BASH_SOURCE[0]}")/lib/shared/test-hetz-smt-sit-nop.sh"
