# FS-380-HDS-020-SDS-010-SMS-050

SMS template row for `FS-380-HDS-020-SDS-010-SMS-050`.

The source is a small row-local `intent.nix` proving SMT/SIT internet-mode
coverage through an emulated PPPoE provider. The provider upstream is limited
to VLAN4/VLAN5 DHCP, and skipped internet coverage is rejected. Intended for
focused deterministic POC tests, not HAT/SAT.
