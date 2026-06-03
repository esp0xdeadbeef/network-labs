# HAT Fixture Index

This file indexes host-acceptance preparation fixtures. Rows here are not SAT
evidence and do not mark HAT `OK`; they identify the static fixture and render
checks that must pass before an owning runtime harness can collect live HAT
evidence.

| HAT ID | FIXTURE | TEST SCRIPT | WHAT IT PREPARES | REQUIRED LIVE FOLLOW-UP |
| --- | --- | --- | --- | --- |
| `LAB-HAT-001` | `HAT/emulated-isp-residential-testnet` | `network-labs/tests/test-hat-emulated-isp-residential-testnet.sh` | Shared intent builds through CPM for CLAB and NixOS inventories; the fixture carries IPv4 `203.0.113.0/30` plus IPv6 `/48`, IPv4 `203.0.113.4/32` plus IPv6 `/64`, explicit NAT64 probe metadata, and no translation-implying or overlay-provider naming. PPPoE preparation uses split per-harness isolated Ethernet bridge surfaces with Linux-valid names. | Owning `s-router-clab` and `s-router-nixos` HAT harnesses must start the substrate and record bridge/container names, DHCP lease state, PPPoE session state, route/nft state, NAT64 probe state, no inferred NAT66, and bounded reachability probes. |
