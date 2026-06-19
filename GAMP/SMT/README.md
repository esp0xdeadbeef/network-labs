# GAMP SMT Workspace

This directory is the controlled Software Module Testing workspace for
`network-labs` GAMP validation work.

Use this directory for source-local SMT stubs, row notes, and focused module
evidence that belongs inside the controlled GAMP tree. Examples-only SMT rows
are indexed in `../../tests/SMT.md`; those rows may reference `../examples/`
fixtures, but they are not live acceptance evidence.

## On-Prem Host Adapter

Any SMT stub that needs an on-prem host attachment must use or reference:

```text
GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix
```

The template provides only the required VLAN2 management uplink: bridge
`vlan2`, parent `eth0`, VLAN ID `2`, IPv4 DHCP enabled, and IPv6 disabled.

VLAN2 missing from examples is allowed. VLAN2 missing from controlled `GAMP/**`
validation surfaces is not allowed.

## Status

No SMT rows are promoted by this directory yet. Add executable evidence before
changing any row to `OK`.
