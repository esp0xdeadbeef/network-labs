# SMT: FS-164-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-164-HDS-010-SDS-010-SMS-010-english-controlled-corpus.md`

Status: OK - construction evidence only.

The `network-labs#validation-scheme` package owns the versioned language rule,
the deterministic checker, and the focused DOC-LANG-N1 through DOC-LANG-N5
negative and recovery cases. Run the canonical trace-derived entrypoint:

```bash
bash tests/FS-164-HDS-010-SDS-010-SMS-010.sh
```

The test scans the current controlled corpus and validates exact diagnostics,
exit behavior, whole-word handling, UTF-8 rejection, unclassified text
rejection, and privacy-safe output. `source = null` and
`maxRuntimeTargets = 0`; this evidence does not claim SIT, HAT, SAT, or live
network behavior.

Title slug: `english-controlled-corpus`
