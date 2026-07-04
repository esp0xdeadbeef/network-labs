# SIT Runtime Path: FS-060-HDS-010-SDS-010

Status: Pending live parent execution.

This SDS-scoped SIT row selects the child
`FS-060-HDS-010-SDS-010-SMS-010` active-lab mini path and is validated by the
network-codex-agent parent live wrapper
`scripts/sit-live-FS-060-HDS-010-SDS-010.sh`.

The parent wrapper must write evidence under the parent trace directory while
checking the child full-trace artifacts on `s-router-nixos`, `s-router-clab`,
and `s-router-test-clients`.
