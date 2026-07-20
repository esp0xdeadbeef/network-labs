# FS-200-HDS-010-SDS-010-SMS-010

This row-local SMT input provides a mini topology for the shared-service
exposure boundary module. The SMS governs binding shared-service exposure
boundary tuples (requester scope, responder scope, discovery protocol,
payload protocol, ports, direction, return behavior, exposure class,
authentication boundary, denied paths, cloud dependency).

## Row-local files only

- `intent.nix` — mini topology with client-edge → core-vlan4-client-dhcp-slaac, one allow relation
- `default.nix` — metadata
- Focused test: `tests/FS-200-HDS-010-SDS-010-SMS-010.sh`

No shared files (mini-smt/default.nix, mini-smt/tests.nix, tests/test.sh)
were edited. Row-local files only per GAMP/SMT/README.md shared-file policy.

## Run

```sh
# Run the focused structural test directly
bash tests/FS-200-HDS-010-SDS-010-SMS-010.sh
```

## Evidence

This is structural construction evidence. Construction proof for the SMS
predicates (11 boundary fields, missing-field diagnostics, discovery/payload
separation, seeded negative CUPS printer conflict) is provided by:

- `network-compiler/tests/FS-200-HDS-010-SDS-010-SMS-010.sh` — PASS at HEAD
- `network-labs/tests/test-fs200-shared-service-source-matrix.sh` — PASS at HEAD

SMS Validation Evidence Boundary: construction-only. No live host, HAT, or
SAT evidence required.
