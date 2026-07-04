# FS-100-HDS-010-SDS-010-SMS-030

Layer: SMS

This row-local source stub keeps the controlled GAMP input addressable from
`network-labs`. It is construction/integration preparation only and does not
claim HAT, SAT, or production readiness.

The row is construction-only. Active-lab selection must expose it as
`source = null`, `evidenceBoundary = "construction-only"`, and
`maxRuntimeTargets = 0`; the owning proof is the network-compiler signed-output
source containment construction test at HEAD `878f54c`, not a router runtime
topology.
