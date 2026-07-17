# Override / Hotpatch Disposition Ledger

Trace: FS-950-HDS-010-SDS-010-SMS-050

- `hostName-lib.mkForce` — classification: **remove** — rationale: audit-fact:candidate-evaluation — effective hostname remains s-router-prod after removing the lib.mkForce hostname override; removal is safe and approved by user audit facts
- `qemu-mkForce` — classification: **retain** — rationale: audit-fact:candidate-evaluation — removal adds default user networking and duplicate vmbr4 NICs; retained conservatively
- `kea-legacy-lease-paths` — classification: **retain** — rationale: audit-fact:candidate-evaluation — removal loses StateDirectory=kea and /var/lib/kea/<vlan>.leases semantics; retained per FS-860/FS-880 durable-state contracts
- `nebula-public-ingress-hotpatch` — classification: **retain** — rationale: audit-fact:candidate-evaluation — removal loses all 4242 DNAT/SNAT/forward rules and required return routes; retained until parity assertions are constructed upstream
- `reservation-overrides-runtime-secret-bindings` — classification: **retain** — rationale: audit-fact:candidate-evaluation — reservation overrides bind runtime secret material; retained as protected references, never copied in plaintext
- `vlan2-vlan3-return-hotpatch` — classification: **conditional** — rationale: audit-fact:candidate-evaluation — removal is blocked until the exact offline parity predicate for VLAN2->VLAN3 return traffic passes
