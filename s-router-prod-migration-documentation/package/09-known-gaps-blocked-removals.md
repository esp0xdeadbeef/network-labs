# Known Gaps and Blocked Removals

Trace: FS-950-HDS-010-SDS-010-SMS-050

- Nebula 4242 DNAT/SNAT/forward and return-route assertions are currently missing upstream and must be asserted before the ingress hotpatch removal can be considered
- VLAN2->VLAN3 return hotpatch removal remains blocked pending the exact offline parity predicate
- BLOCKED REMOVAL: `vlan2-vlan3-return-hotpatch` — audit-fact:candidate-evaluation — removal is blocked until the exact offline parity predicate for VLAN2->VLAN3 return traffic passes
