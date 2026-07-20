# Controlled SMS Catalog

`tests.nix` discovers every `GAMP/SMT/<trace-id>/default.nix` row. It is a
normalizer, not a hand-maintained test registry.

The trace ID is the only dispatch key. A row must not store a script, command,
runner, probe, or test path in SDS, SMS, SIT, or SMT metadata.

## Canonical entrypoints

Construction:

```text
tests/<full-trace-id>.sh
```

Live:

```text
network-codex-agent/scripts/live-<full-trace-id>.sh
```

Both names are stable symlinks to generic dispatchers. Row-specific test cases
live below `tests/lib/<full-trace-id>/`; shared behavior lives below
`tests/lib/shared/`. Descriptive suffixes are internal case names only and
must never become public entrypoints.

This gives each controlled row one address without repeating that address in
the row metadata. The dispatcher derives the test directory from the invoked
trace ID. It rejects ambiguous or non-canonical top-level entrypoints.

## Source normalization

The catalog derives the row directories from the trace ID:

```text
GAMP/SDS/<FS-HDS-SDS>/
GAMP/SMS/<FS-HDS-SDS-SMS>/
GAMP/SIT/<FS-HDS-SDS>/
GAMP/SMT/<FS-HDS-SDS-SMS>/
```

The row owns semantic source data only. An SMT row may declare an intent
source, a control-plane replacement artifact, a renderer input, or a
construction-only boundary. The catalog normalizes those declarations for the
generic runner. It does not infer missing network semantics and does not map a
trace ID to a bespoke shell filename.

## Running rows

List executable rows:

```sh
tests/run-active-lab-mini-smt.sh --list
```

Inspect a row's normalized source:

```sh
tests/run-active-lab-mini-smt.sh --source FS-500-HDS-010-SDS-010-SMS-040
```

Run one row:

```sh
tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-040
```

Run the executable catalog:

```sh
tests/run-active-lab-mini-smt.sh all
```

Rows without a canonical entrypoint remain explicit `NOT OK` source rows.
They must not receive an empty wrapper merely to make the catalog look
complete.

## Runtime scope

A mini SMT proves one SMS atom. Its runtime target set must be no larger than
the behavior requires and may never silently expand into HAT or SAT. Hardware
or lifecycle claims require the real bounded runtime lifecycle; parsing,
evaluation, schema validation, and dry builds are prerequisites rather than
runtime evidence.

Do not use VLAN2 as test dataplane infrastructure. It is the management path.
SMT/SIT internet fixtures use a bounded emulated provider through VLAN4 or
VLAN5. Live evidence uses the exact canonical live entrypoint and the declared
hosts for that row.

## Conformance gate

`FS-981-HDS-010-SDS-010-SMS-030` validates the complete catalog. It proves:

- automatic discovery of every SMS row;
- absence of runner-path metadata;
- canonical construction and live entrypoint names;
- rejection of suffix-based and `smt-live-` aliases;
- deterministic dispatch from one trace ID;
- explicit classification of rows without an implementation;
- seeded negative diagnostics and successful recovery.

The catalog count and runnable/unimplemented split are computed by the gate;
they are not duplicated in this document.
