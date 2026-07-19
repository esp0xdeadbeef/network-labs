# FS-970-HDS-010-SDS-020 SIT

Status: OK for the integrated
`FS-970-HDS-010-SDS-020-SMS-040` evidence boundary.

The 2026-07-19 acceptance run used real isolated clients on both target
substrates. After enrollment, every owning `network-*` revision was present on
GitHub. `s-router-nixos`, `s-router-clab`, and `s-router-test-clients` were then
shut down together, all three were observed offline, and all three returned
with new boot IDs, new guest system closures, exact staged source hashes, exact
pins, and zero failed units.

The row-local live protocol proved equivalent protected-source delivery and
runtime DHCPv4/DHCPv6 materialization on NixOS and CLAB. The same real clients
reproduced their privately enrolled MAC, stable non-temporary IPv6 IID, DUID,
and IAID and obtained exactly their reserved IPv4 and IPv6 addresses. Public
source, diagnostics, logs, and Nix-store templates remained redacted.

The clients used lab VLAN397 and VLAN398 only. No production VLAN, VLAN2, or
public production address was used. This SIT result does not promote HAT, SAT,
or production activation. The sibling SMS inputs retain their own construction
boundaries.
