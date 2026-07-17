# s-router-prod Offline Latest-Pin Migration Package

Trace: FS-950-HDS-010-SDS-010-SMS-050
Owner: network-labs (supplier)

## No-Live Safety Boundary

This package is documentation/planning output only. It was produced offline
from versioned repo files, pin manifests, user-supplied audit facts, redacted
state-schema declarations, and optional user-copied offline-export content.

- No live data acquisition was performed: no SSH, no ping, no packet probe,
  no VM start, no image registration, no deploy, no reboot, no service
  query, no timer query, no Nix evaluation against live targets, no canary
  execution, no HAT, no SAT, and no production acceptance.
- Declarative path-class strings in this package (sourcePathClass,
  targetPathClass) name production path semantics as schema metadata only.
  Nothing in this package opened, stat'ed, read, hashed, enumerated, or
  executed against those live paths.
- This package asserts no acceptance status and no deployment readiness.
  Every promotion step requires separate explicit human authorization.
- Actual export of production state is a later, separately authorized
  maintenance operation; this package only defines the export contract.
