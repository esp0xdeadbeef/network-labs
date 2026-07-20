# SMS Mirror: FS-162-HDS-010-SDS-040-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: NOT OK - focused construction proof not executed.

The canonical SMS title slug is `s-router-prod-comparable-projection`. The
focused proof shall compile the pinned isolated FS-230 scenario once and pass
the same CPM identity directly to the OpenConfig path. It must prove the
IPv6 UDP/4242, no-NAT66, preserve-source, stateful-return, selected-path, and
no-inherited-egress posture without reading NixOS or CLAB output as input.
