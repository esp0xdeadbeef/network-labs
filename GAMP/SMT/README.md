# GAMP SMT Workspace

This directory is the controlled Software Module Testing workspace for
`network-labs` GAMP validation work.

Use this directory for source-local SMT stubs, row notes, and focused module
evidence that belongs inside the controlled GAMP tree. Examples-only SMT rows
are indexed in `../../tests/SMT.md`; those rows may reference `../examples/`
fixtures, but they are not live acceptance evidence.

## Hardware-Related SMT Evidence

Hardware-related SMT is not a dry-run bucket. If an SMS concerns host adapters,
bridges, VLANs, VM interfaces, NixOS renderer output, CLAB host attachment, or
an `s-router-*` harness, the SMT evidence must include a real executable test
that uses the controlled source under:

```text
/home/deadbeef/github/network-labs/GAMP/*
```

Put the `network-labs` side of that test under `../../tests/`. If the SMS is
owned by another repository, add the focused implementation test there too, but
keep a `network-labs/tests/` test or harness that proves the controlled GAMP
source still exercises the behavior.

Acceptable hardware-related SMT examples include:

- booting a minimal VM with the rendered adapter or route surface;
- running the smallest relevant `s-router-*` harness path;
- checking a live CLAB or NixOS fixture after it starts;
- recording bounded runtime probes from the VM or harness.

Static parsing, `nix-instantiate --parse`, renderer-only JSON inspection, and
`nix build --dry-run` can be prerequisites, but they must not be the final
evidence for hardware-related SMT.

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
