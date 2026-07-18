# SMS Mirror: FS-540-HDS-010-SDS-010-SMS-035

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-035-renderer-dns-nft-materialization.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: Source stub only - not validation evidence.

The canonical SMS title slug is `renderer-dns-nft-materialization`. The
renderer must preserve the exact emitted relation endpoint and
forwarding-compatible namespace mode without loopback substitution or local
rediscovery. The selected egress must already govern the resolver's first
upstream route decision, the resolver and authorized listeners must remain
available, and unchanged dynamic next-hop state must converge without
self-sustaining refresh activity. That first decision must use a pre-socket
policy selector combining resolver runtime identity, UDP/TCP, and destination
port 53. An nft output mark alone is too late when the unselected table has no
route, while a process-wide UID selector incorrectly captures internal DNS
replies. Add row-specific lab source and focused validation evidence in the
SMT/SIT row before marking this trace OK.
