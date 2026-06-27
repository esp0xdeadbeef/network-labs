# FS-500-HDS-010-SDS-010-SMS-020 SMT

Row-local intent-source fixture for reachability decision type preservation.

Validation Evidence Boundary: split
- Construction-provable (SMT): emission path scanning, relationId-based type tagging, missing-type detection (missingEvidence diagnostic), wrong-type/action mismatch detection (contractContradiction diagnostic)
- Live-required (HAT/SAT): trafficPathValidation diagnostic output correctness in downstream renderer pipeline

NFM checker validates that CPM traffic-path answer records carry correct type identifiers. Construction tests exist at network-forwarding-model: tests/fs-500-hds-010-sds-010-sms-020-decision-type-preservation.sh

Sibling traces: FS-500-HDS-010-SDS-010-SMS-010 (reachability-decision), FS-500-HDS-010-SDS-010-SMS-030 (decision-reason-diagnostic), FS-500-HDS-010-SDS-010-SMS-040 (p2p-next-hop).
