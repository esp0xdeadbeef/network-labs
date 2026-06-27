# FS-350-HDS-010-SDS-010-SMS-010 SMT

Row-local source stub for prefix subdivision authority.

## Evidence Boundary

**Construction-only.** All SMS predicates are provable at construction time with
nix eval against local fixtures. No live host, container, runtime, or HAT/SAT
evidence required.

## SMS Predicates Covered

| Predicate | Description | Proven By |
|-----------|-------------|-----------|
| MR1 | Consume source prefix authority, child purpose, role, site, tenant, address family | intent.nix fixture + NFM construction test |
| MR2 | Derive deterministic child prefixes only from modeled authority | intent.nix fixture: `subdivide-access-v4-site-1`, `subdivide-access-v6-site-1`, `subdivide-mgmt` |
| MR3 | Emit subdivision plan naming source authority and child purpose | intent.nix fixture: expected.authorityRef on accepted subdivisions |
| FC1 | Missing source authority → rejection with diagnostic | intent.nix fixture: `subdivide-missing-authority` → `missing-source-authority` |
| FC2 | Ambiguous child prefix purpose → rejection with diagnostic | intent.nix fixture: `subdivide-ambiguous-purpose`, `subdivide-no-purpose` |
| FC3 | Missing authority reference → rejection | intent.nix fixture: `subdivide-no-authority-ref` → `missing-authority-reference` |
| SN1 | Missing source authority on child prefix → REJECT | intent.nix fixture: `subdivide-missing-authority` |
| SN2 | Ambiguous child prefix purpose → REJECT + recovery | intent.nix fixture: `subdivide-ambiguous-purpose` (REJECT), `subdivide-ambiguous-purpose-recovered` (ACCEPT) |

## Construction Test

Existing construction test in `network-forwarding-model`:
```
bash tests/test-fs350-prefix-authority-consumer-eligibility.sh
```
PASS at HEAD (2026-06-27): covers SMS-010/020/040 authority class separation,
consumer eligibility, reserved-space denial, and unassigned-space rejection.

## Row-Local Files

- `intent.nix` — prefix subdivision authority fixture with source authorities,
  subdivision requests, and expected results for FS-350-HDS-010-SDS-010-SMS-010
- `default.nix` — row metadata pointing to network-forwarding-model construction test
- `README.md` — this file

No mini-smt/tests.nix registration required — this is a construction-only SMS trace.
