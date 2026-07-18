# FS-540-HDS-010-SDS-010-SMS-020

SMS template row for `FS-540-HDS-010-SDS-010-SMS-020`.

The row owns the normalized CPM DNS authority: exact relation-terminal
listeners/forwarders, explicit recursion mode and egress selection, requester
ACLs, forwarding-compatible local namespaces, and redacted reproducibility
warnings. The revised row includes `DNS_CORE_ENDPOINT_PATH_MISMATCH` and
`DNS_LOCAL_NAMESPACE_SHADOWED`; the existing fixture is not acceptance
evidence until those predicates pass. Intended for focused deterministic POC
tests, not HAT/SAT.
