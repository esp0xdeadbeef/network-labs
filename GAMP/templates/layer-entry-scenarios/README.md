# Layer-Entry Scenario Examples

This directory carries placeholder examples for FS-166 style layer-entry
scenario manifests. These records are intentionally named with
`FS-TEMPLATE-RENAME-TO-CORRECT-*` IDs so the future owner has to rename them to
the real FS/HDS/SDS/SMS chain before using them as controlled validation rows.

The examples are not SAT or HAT evidence. They are source templates that show
how to declare a scenario that starts below the normal intent -> compiler -> NFM
-> CPM -> renderer pipeline without pretending the skipped stages were tested.

Template file:

```text
GAMP/templates/layer-entry-scenarios/scenarios.nix
```

Each scenario declares:

- `entryBoundary`: where the scenario starts;
- `suppliedArtifact`: the artifact class supplied at that boundary;
- `skippedUpstreamLayers`: upstream stages that are deliberately not tested;
- `expectedWarnings`: warning codes that must be surfaced for those skipped
  layers;
- `downstreamPath`: stages that are actually included;
- `expected`: positive processing/rendering or deterministic fail-closed result;
- `owningLayerForInvalidInput`: first layer that must reject invalid input;
- `evidenceContext`: what the template may support, and what it cannot claim.

`HAT` and `SAT` are full approval profiles. They must use `entryBoundary =
"intent-source"`, must not skip any upstream layer, and must include
network-labs, network-compiler, NFM, CPM, renderer, and NixOS runtime in the
executed path.

The current examples cover:

- a contract-valid but unusual forwarding-model input that skips intent and the
  compiler;
- a renderer-only PPPoE and port-forward input supplied as explicit CPM output;
- a CPM-entry public-ingress/provider handoff that still exercises CPM plus
  renderers;
- a renderer negative case with an incomplete public-ingress target;
- a runtime-artifact VLAN2 preservation guard.

Any on-prem host scenario must reference:

```text
GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix
```

That keeps VLAN2 as an explicit controlled GAMP requirement without forcing
ordinary `examples/` fixtures to grow management-host details.
