# SMS Lab Source: FS-166-HDS-010-SDS-010-SMS-020

Canonical specification:
`network-codex-agent/GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-020-controlled-scenario-orchestrator.md`.

`packages.validation-scheme` owns the deterministic control-flow and artifact-
flow validator. It covers compiler-, NFM-, CPM-, and realization-input
boundaries and executes all eight exact `NS-FLOW-*` negative and recovery
cases. The trace-derived construction entrypoint selects this test without a
manifest script mapping.
