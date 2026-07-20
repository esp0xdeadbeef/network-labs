# GAMP SMT Workspace

This directory is the controlled Software Module Testing workspace for
`network-labs`.

Each SMS has one row-local directory:

```text
GAMP/SMT/<full-trace-id>/
```

The directory contains the row declaration, controlled source fixtures, and
evidence notes. It never assigns a bespoke public runner name. The trace ID is
the only dispatch key.

## Public test interface

Construction tests use:

```text
tests/<full-trace-id>.sh
```

Live tests use:

```text
network-codex-agent/scripts/live-<full-trace-id>.sh
```

The entrypoints are thin symlinks to generic dispatchers. Unique cases live in
`tests/lib/<full-trace-id>/`; reusable behavior lives in `tests/lib/shared/`.
Descriptive suffixes are permitted only for those internal cases.

The complete catalog is discovered from the row directories by
`GAMP/SMT/mini-smt/tests.nix`. Do not maintain a second row table, runner map,
or command list in this document or in `default.nix` files.

## Evidence boundaries

SMT proves one software module atom. It may use static evaluation for a purely
construction-level claim. A claim about adapters, bridges, namespaces,
containers, routes, service activation, or packet behavior requires a bounded
real runtime test.

SIT integrates SMS atoms at the SDS boundary. HAT and SAT remain separate
controlled validation levels. An SMT result cannot promote a SIT, HAT, or SAT
row.

Aggregate checks may prove catalog wiring but cannot replace row-local
evidence. A row without an executable implementation remains `NOT OK`; do not
add a no-op wrapper.

## Runtime constraints

- Use the smallest target set that can prove the atom.
- Keep `s-router-nixos`, `s-router-clab`, and `s-router-test-clients` coverage
  explicit when the specification requires those substrates.
- Use the real shutdown, rebuild, and fresh-boot lifecycle for live host
  evidence.
- Do not use VLAN2 as an SMT/SIT dataplane. VLAN2 is the management path.
- Model internet behavior with a bounded emulated provider through VLAN4 or
  VLAN5 for SMT/SIT.
- Do not treat parse checks, dry builds, or renderer JSON inspection as runtime
  proof.

## Controlled source ownership

Row-specific intent and replacement artifacts live below the full SMT trace
directory. SDS and SMS define the design and module contract. SIT references
its SMS inputs by trace ID. The deterministic validation scheme resolves those
identities without storing shell paths in controlled metadata.

For on-prem management attachment, use:

```text
GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix
```

The template models VLAN2 management only. A row must declare any separate
test dataplane explicitly.

## Commands

List all executable SMS rows:

```sh
tests/run-active-lab-mini-smt.sh --list
```

Inspect normalized source data:

```sh
tests/run-active-lab-mini-smt.sh --source <full-trace-id>
```

Run one row:

```sh
tests/run-active-lab-mini-smt.sh <full-trace-id>
```

Validate the catalog convention:

```sh
bash tests/FS-981-HDS-010-SDS-010-SMS-030.sh
```

The FS-981 gate calculates the current catalog size and runnable status. These
values are deliberately not copied into documentation.
