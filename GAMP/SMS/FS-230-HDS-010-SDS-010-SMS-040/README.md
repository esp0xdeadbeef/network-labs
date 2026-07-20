# SMS Mirror: FS-230-HDS-010-SDS-010-SMS-040

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: Construction candidate only - SMT and SIT remain NOT OK pending the
isolated cold stage.

The canonical SMS title slug is
`s-router-prod-nebula-ipv6-ingress-compatibility`. The row-specific source
separates policy intent from inventory-owned endpoint/protected-source facts.
The current cold stage rejected a CLAB artifact that serialized the runtime
interface name `policy` as an unquoted nftables token. The canonical SMS now
requires target-safe string-literal serialization and a keyword-like interface
seeded negative. Construction and live validation must both pass before this
trace can become OK.
