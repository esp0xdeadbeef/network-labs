# FS-320-HDS-010-SDS-010-SMS-010

This row-local SMT input provides a mini topology for verifying renderer layout
preservation: logical role identity, policy boundaries, and co-location rules
must survive renderer mapping without reinterpretation.

The intent defines a two-node, one-link topology with role co-location on the
access node (two tenant attachments: client + mgmt), exercising layout
preservation per SMS predicates MR1-MR4 and Seeded Negative SN1.

## Row-local files only

- `intent.nix` — mini topology with co-located client+mgmt tenants
- `default.nix` — metadata
- Focused test: `tests/FS-320-HDS-010-SDS-010-SMS-010.sh`

No shared files (mini-smt/default.nix, mini-smt/tests.nix, tests/test.sh)
were edited. Row-local files only per GAMP/SMT/README.md shared-file policy.

## Run

```sh
# Run the focused structural test directly
bash tests/FS-320-HDS-010-SDS-010-SMS-010.sh
```

## Evidence

This is structural construction evidence (10 predicates: node count, link
topology, role co-location, relation IDs, allow/deny policy boundary,
ownership prefixes, pool definitions).

Behavioral proof (renderer output with role identity preservation, target
limitation diagnostics, seeded negative exercise) requires RaTM work:
validators in mini-smt/default.nix and full compiler→NFM→CPM→renderer
pipeline per SMS Construction Handoff items 1-3. Route to manager for
shared infrastructure (mini-smt/default.nix).
