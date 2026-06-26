# FS-200-HDS-010-SDS-010-SMS-010

SMS template row for the `shared-service-exposure-boundary` mini-SMT input.

The authoritative SMS lives in `network-codex-agent/GAMP/SMS/FS-200-HDS-010-SDS-010-SMS-010-shared-service-exposure-boundary.md`.
This template row provides the network-labs source anchor for row-local mini-SMT evidence.

The intent fixture models a two-node topology (client-edge → testnet-edge) with one tenant-to-external allow relation through the full compiler pipeline. The shared-service exposure boundary predicates are verified by focused construction tests in `network-compiler/tests/test-FS-200-HDS-010-SDS-010-SMS-010.sh` and `network-labs/tests/test-fs200-shared-service-source-matrix.sh`.

Intended for focused deterministic SMT construction evidence, not HAT/SAT.
