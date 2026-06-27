# FS-240-HDS-010-SDS-010-SMS-020 SMT

Row-local source for management-plane authority exclusion SMT.

The focused test validates SAT source fixture data for management access
authority and core-host exception tuples, proving management reachability
remains excluded from non-management paths per SMS predicates.

## Run

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-FS-240-HDS-010-SDS-010-SMS-020-management-plane-authority.sh
```

## What it validates

- Management access authority: policyClass=management, required fields
  (sourceScope, targetRole, targetHost, protocol, ports,
  authenticationBoundary, recoveryMode), nonManagementAuthority=false
- Core-host exception tuples: trafficClass restricted to host-management
  or control-plane, forwardingSideEffects=false, serviceExposure=false
- Seeded negatives: missing sourceScope, missing targetHost, missing
  authenticationBoundary, missing recoveryMode, non-management authority
  reuse, non-core targets, payload traffic exemption, forwarding side effects

## Fixture dependencies

- `GAMP/SAT/management-core-host-authority.nix` (3 sites: site-clab,
  site-hetz, site-nixos, each with managementAccess + coreHostExceptions)
- `GAMP/SAT/site-role-map.nix` (source site verification)

## Evidence classification

construction-only — all predicates provable via nix eval against SAT
source fixtures. No live runtime surface required.
