# Provenance and Redaction Manifest

Trace: FS-950-HDS-010-SDS-010-SMS-050

## Input Provenance (sha256 of consumed offline inputs)

- `audit-facts.json` sha256 `1762d1f79f6b45a29493240c3d60a3185c70b8463e3d3018e097403cd4db0d9d`
- `coherent-stack.json` sha256 `0934f1e01511762761653f3e343ed0be04268ebc28f148d8f2033c10e1083b0b`
- `migration-plan.json` sha256 `ad2639a3549d588e349833dae169803b12f54f5a54c7a402feae6126c5389bab`
- `parity-matrix.json` sha256 `fa82c0770be3b779060d49047644fba61b52149fb96616dab92a3578da5d1dfd`
- `source-pins.json` sha256 `cf7323c3497b1db33fcfd9e28b72c938f3ca84ce35538326a9e94c6483151e1f`
- `state-schema.json` sha256 `6178ce7330cd8b5f0fd8269a1804c25e552bf1a2e214ab50382bb19ef3a9404d`
- `target-pins.json` sha256 `51c9cdacb2becd1aad173e4ae749b15f78ce7f2193b6ddb1d93a7a7a4b108815`

## Redaction Statement

All secret material in consumed inputs is redacted to `secret://` references. Reservation overrides and Nebula/other secret material remain protected references; no plaintext secret was copied into this package.
