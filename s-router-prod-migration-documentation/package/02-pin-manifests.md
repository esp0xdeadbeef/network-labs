# Pin Manifests

Trace: FS-950-HDS-010-SDS-010-SMS-050

## Source Baseline Pins (derived from versioned lock metadata)

- `network-compiler` -> `878f54c735165d37f73156a445cbe688db743f0a`
- `network-control-plane-model` -> `c2d6ea82cda48cb13afcef1f6e346a69d8eea2d7`
- `network-forwarding-model` -> `c351590f7d47791b0da2c6b7caac54cefa60334a`
- `network-renderer-nixos` -> `e9bf98b526275f2d5e01ac28ca0aaee79d875723`
- `nixos-network-compiler` -> `878f54c735165d37f73156a445cbe688db743f0a`

## Candidate Target Pins (user-supplied, parameterized)

- `network-compiler` -> `e2da177f747d295b2616ae26285a0c74aa568772`
- `network-control-plane-model` -> `15f8190ebf1ec7319301dbb64ee580539326acb4`
- `network-forwarding-model` -> `8894c5413f81d04d1c111e65581eecbe3f804423`
- `network-renderer-nixos` -> `ebbb3b0fea48f31ed2f16cd0b3a5cab70001f7e1`
- `nixos-network-compiler` -> `e2da177f747d295b2616ae26285a0c74aa568772`

Pins are recorded as the initial candidate/audit baseline, not as
timeless requirements. Per FS-985, `flake.nix` uses floating refs and
`flake.lock` is the sole authoritative revision-pinning surface.

## Coherent-Stack Relationship

- relation: latest coherent network-stack pin set: compiler, control-plane model, forwarding model, and NixOS renderer locked together via the versioned lab flake.lock lineage; NixOS compiler input tracks network-compiler
- member: `network-compiler`
- member: `network-control-plane-model`
- member: `network-forwarding-model`
- member: `network-renderer-nixos`
- member: `nixos-network-compiler`
