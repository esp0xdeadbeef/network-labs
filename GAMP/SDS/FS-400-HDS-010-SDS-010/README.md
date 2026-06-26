# FS-400-HDS-010-SDS-010

SDS template row for the ULA NAT66 selection mini-SMT POC.

This row currently maps:

- `FS-400-HDS-010-SDS-010-SMS-010` for explicit IPv6 internet mode selection (upstream gate).
- `FS-400-HDS-010-SDS-010-SMS-020` for ULA NAT66 selection validation.
- `FS-400-HDS-010-SDS-010-SMS-030` for routed client GUA mode.
- `FS-400-HDS-010-SDS-010-SMS-040` for overlay client GUA mode.
- `FS-400-HDS-010-SDS-010-SMS-050` for ULA WAN denial.
- `FS-400-HDS-010-SDS-010-SMS-060` for renderer IPv6 internet mode.

The authoritative SDS lives in the FS-400 chain in `network-codex-agent/GAMP/`.
