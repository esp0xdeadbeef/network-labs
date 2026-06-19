# PPPoE Evidence — s-router-clab (Condensed)

**Timestamp:** 2026-06-15 00:52
**Source:** Extracted from `intent.nix` diagnostic comment block (commit `867567c`)
**Full evidence:** `s-router-hat-sat-manager/lanes/LIVE-PPPOE-EVIDENCE.md`

---

## Status at Capture Time

PPPoE links are ESTABLISHED at L2/L3 but access→core communication is broken
due to firewall/routing realization gaps. The intent relations are correct:
client→testnet-host-isp and client→testnet-routed-isp already have
trafficType "any" (priorities 100-101). The rendered nftables/routes do not
fulfill the intent.

## PPPoE Topology (verified live)

```
Link A (host-isp):
  provider-handoff-access-a:ppp0  203.0.113.5 ↔ 203.0.113.4  core-testnet-host-isp:ppp0

Link B (routed-isp):
  provider-handoff-access-b:ppp0  203.0.113.1 ↔ 203.0.113.2  core-testnet-routed-isp:ppp1
```

## Reachability (live probes)

| Source | Target | Result |
|--------|--------|--------|
| testnet-host-isp → provider-handoff-access-a (203.0.113.5) | ✓ 0.080ms |
| testnet-routed-isp → provider-handoff-access-b (203.0.113.1) | ✓ 0.082ms |
| provider-handoff-access-a → testnet-host-isp (203.0.113.4) | ✗ 100% loss |
| provider-handoff-access-b → testnet-routed-isp (203.0.113.2) | ✗ 100% loss |
| access-client → 203.0.113.4 (through fabric) | ✗ 100% loss |
| access-client → 8.8.8.8 (egress through ISP) | ✗ 100% loss |

## Realization Gap Inventory (6 items)

| # | Location | Direction | What's Missing |
|---|----------|-----------|----------------|
| L1 | downstream-selector ROUTE | forward | no 203.0.113.0/24 → provider-handoff |
| L1b | upstream-selector ROUTE | forward | no 203.0.113.0/24 → provider-handoff |
| L2a | provider-handoff FORWARD | forward | missing ens21→ppp0 (access fabric → PPP) |
| L2b | provider-handoff FORWARD | return | missing ens20→ens21 (direct return path) |
| L2c | provider-handoff FORWARD | return | missing ppp0→ens21 (ISP-default-route return) |
| L3 | ISP INPUT | forward | only SSH on ppp0/ppp1 (policy drop otherwise) |

P2P addressing DOES track end-to-end. Every hop has correct point-to-point
IPs and kernel routes. Gaps are all in nftables FORWARD/INPUT chains and
fabric routing tables.

ISP default route goes through ppp0 (not ens80), creating asymmetric path:
forward via ens20/ens21, return via ppp0. ISP ECMP splits return traffic
50/50 between direct (ens20→provider-handoff, blocked by L2b) and indirect
(ens21→upstream-selector→downstream, works via ct state established/related).

## What Is Already Correct

- ISP FORWARD: ppp0→ens21, ppp0→ens80 with DNS rules (forwarding works)
- ISP NAT: masquerade for access subnets on ens80
- Provider-handoff FORWARD: if-1520c4ed917e→ppp0 (selector-fabric path)
- Intent relations: client→testnet-*isp with trafficType "any" at priorities 100-101
