# FS-240-HDS-010-SDS-010-SMS-020 SMT

Row-local source for management-plane authority exclusion SMT.

The focused test validates SAT source fixture data for management access authority and core-host exception tuples, proving management reachability remains excluded from non-management paths per SMS predicates.

Run:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-management-core-host-authority-source.sh
```

This test validates:
- Management access authority (policyClass=management, required fields, nonManagementAuthority=false)
- Core-host exception tuples (trafficClass host-management/control-plane only, forwardingSideEffects=false, serviceExposure=false)
- Seeded negatives: missing sourceScope, targetHost, authenticationBoundary, recoveryMode; non-management authority reuse; non-core targets; payload traffic exemption; forwarding side effects
