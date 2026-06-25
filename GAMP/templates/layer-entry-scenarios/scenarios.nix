{
  meta = {
    contract = "FS-166 layer-entry scenario examples";
    status = "template-only";
    renameRequired = true;
    placeholderIdPrefix = "FS-TEMPLATE-RENAME-TO-CORRECT-";
    vlan2Template = "GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix";
    allowedEntryBoundaries = [
      "intent-source"
      "compiler-output"
      "forwarding-model-input"
      "control-plane-input"
      "renderer-input"
      "runtime-artifact"
    ];
    expectedWarningBySkippedLayer = {
      intent-source = "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE";
      network-compiler = "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER";
      network-forwarding-model = "WARN_LAYER_ENTRY_SKIPS_NFM";
      network-control-plane-model = "WARN_LAYER_ENTRY_SKIPS_CPM";
      renderer = "WARN_LAYER_ENTRY_SKIPS_RENDERER";
    };
    approvalProfiles = {
      HAT = {
        entryBoundary = "intent-source";
        skippedUpstreamLayers = [ ];
        requiredPath = [
          "network-labs"
          "network-compiler"
          "network-forwarding-model"
          "network-control-plane-model"
          "network-renderer-nixos"
          "nixos-runtime"
        ];
      };
      SAT = {
        entryBoundary = "intent-source";
        skippedUpstreamLayers = [ ];
        requiredPath = [
          "network-labs"
          "network-compiler"
          "network-forwarding-model"
          "network-control-plane-model"
          "network-renderer-nixos"
          "nixos-runtime"
        ];
      };
    };
  };

  scenarios = {
    "FS-TEMPLATE-RENAME-TO-CORRECT-NFM-WEIRD-STAGED-FORWARDING-SMS-001" = {
      id = "FS-TEMPLATE-RENAME-TO-CORRECT-NFM-WEIRD-STAGED-FORWARDING-SMS-001";
      renameRequired = true;
      description = "Start at NFM input with a compact but contract-valid staged site shape so unusual topology is tested downstream without claiming compiler coverage.";
      entryBoundary = "forwarding-model-input";
      suppliedArtifact = {
        kind = "synthetic-contract-valid-compiler-output";
        contract = "compiled site payload only; no intent.nix or inventory files are consumed by this scenario";
        requiredShape = [
          "canonical staged roles remain explicit even when later realization may co-locate roles"
          "tenant, service, and relation records are explicit"
          "uplink and overlay semantics are present as compiler-owned semantics"
          "no renderer bridge, VLAN, or interface names appear in the supplied artifact"
        ];
      };
      skippedUpstreamLayers = [
        "intent-source"
        "network-compiler"
      ];
      expectedWarnings = [
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"
      ];
      downstreamPath = [
        "network-forwarding-model"
        "network-control-plane-model"
        "renderer"
      ];
      expected = {
        kind = "positive-process";
        includedLayers = [
          "network-forwarding-model"
          "network-control-plane-model"
          "renderer"
        ];
        assertions = [
          "NFM accepts unusual but contract-valid compiler output"
          "downstream layers consume explicit NFM/CPM fields instead of rediscovering intent"
        ];
      };
      owningLayerForInvalidInput = "network-forwarding-model";
      evidenceContext = {
        kind = "template-source";
        maySupport = [ "SMT" "SIT" ];
        mustNotClaim = [ "HAT" "SAT" ];
        requiredBeforePromotion = [
          "replace placeholder ID with the real trace chain"
          "add executable NFM/CPM/renderer fixture generation"
        ];
      };
      onPremHostAttachment = {
        required = false;
      };
    };

    "FS-TEMPLATE-RENAME-TO-CORRECT-RENDERER-PPPOE-PORTFORWARD-SMS-002" = {
      id = "FS-TEMPLATE-RENAME-TO-CORRECT-RENDERER-PPPOE-PORTFORWARD-SMS-002";
      renameRequired = true;
      description = "Start at renderer input with explicit CPM data for a PPPoE server/client handoff plus public-ingress port-forward behavior.";
      entryBoundary = "renderer-input";
      suppliedArtifact = {
        kind = "synthetic-contract-valid-cpm-output";
        contract = "renderer input only; compiler, NFM, and CPM are not part of this scenario";
        requiredShape = [
          "PPPoE access concentrator and client attachment are explicit CPM facts"
          "public-ingress tuple declares protocol, public port, target endpoint, target port, and return path"
          "routing mode and interface identities are explicit CPM fields"
          "provider-emulation capability is explicit and not inferred from names"
        ];
      };
      skippedUpstreamLayers = [
        "intent-source"
        "network-compiler"
        "network-forwarding-model"
        "network-control-plane-model"
      ];
      expectedWarnings = [
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"
        "WARN_LAYER_ENTRY_SKIPS_NFM"
        "WARN_LAYER_ENTRY_SKIPS_CPM"
      ];
      downstreamPath = [
        "network-renderer-nixos"
        "network-renderer-containerlab-linux-backend"
      ];
      expected = {
        kind = "positive-render";
        includedLayers = [
          "network-renderer-nixos"
          "network-renderer-containerlab-linux-backend"
        ];
        assertions = [
          "renderers materialize only explicit CPM public-ingress and PPPoE facts"
          "renderers do not infer PPPoE or port-forward behavior from interface, bridge, or provider names"
        ];
      };
      owningLayerForInvalidInput = "renderer";
      evidenceContext = {
        kind = "template-source";
        maySupport = [ "SMT" "SIT" ];
        mustNotClaim = [ "HAT" "SAT" ];
        requiredBeforePromotion = [
          "replace placeholder ID with the real trace chain"
          "add renderer-local fixtures and network-labs guard consuming this manifest"
        ];
      };
      onPremHostAttachment = {
        required = true;
        template = "GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix";
        reason = "NixOS on-prem renderer checks must keep the management VLAN2 attachment explicit.";
      };
    };

    "FS-TEMPLATE-RENAME-TO-CORRECT-CPM-PUBLIC-INGRESS-HANDOFF-SMS-003" = {
      id = "FS-TEMPLATE-RENAME-TO-CORRECT-CPM-PUBLIC-INGRESS-HANDOFF-SMS-003";
      renameRequired = true;
      description = "Start at CPM input with explicit forwarding plus inventory handoff data for public ingress so CPM and renderers are tested together.";
      entryBoundary = "control-plane-input";
      suppliedArtifact = {
        kind = "forwarding-model-plus-realization-inventory";
        contract = "CPM input boundary; intent, compiler, and NFM execution are skipped";
        requiredShape = [
          "forwarding model names the public-ingress forwarding consequence"
          "inventory binds the provider handoff and target endpoint realization"
          "CPM must join only matching explicit forwarding and realization records"
          "renderer output must preserve the CPM port-forward tuple"
        ];
      };
      skippedUpstreamLayers = [
        "intent-source"
        "network-compiler"
        "network-forwarding-model"
      ];
      expectedWarnings = [
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"
        "WARN_LAYER_ENTRY_SKIPS_NFM"
      ];
      downstreamPath = [
        "network-control-plane-model"
        "network-renderer-nixos"
        "network-renderer-containerlab-linux-backend"
      ];
      expected = {
        kind = "positive-process";
        includedLayers = [
          "network-control-plane-model"
          "network-renderer-nixos"
          "network-renderer-containerlab-linux-backend"
        ];
        assertions = [
          "CPM fails on missing realization coverage instead of repairing it"
          "renderers consume the emitted CPM tuple without parsing intent or inventory"
        ];
      };
      owningLayerForInvalidInput = "network-control-plane-model";
      evidenceContext = {
        kind = "template-source";
        maySupport = [ "SMT" "SIT" ];
        mustNotClaim = [ "HAT" "SAT" ];
        requiredBeforePromotion = [
          "replace placeholder ID with the real trace chain"
          "add a concrete CPM fixture and renderer artifact comparison"
        ];
      };
      onPremHostAttachment = {
        required = false;
      };
    };

    "FS-TEMPLATE-RENAME-TO-CORRECT-RENDERER-MISSING-PORTFORWARD-TARGET-FAIL-SMS-004" = {
      id = "FS-TEMPLATE-RENAME-TO-CORRECT-RENDERER-MISSING-PORTFORWARD-TARGET-FAIL-SMS-004";
      renameRequired = true;
      description = "Start at renderer input with invalid CPM-like public-ingress data that omits the target endpoint and must fail closed.";
      entryBoundary = "renderer-input";
      suppliedArtifact = {
        kind = "synthetic-invalid-cpm-output";
        contract = "renderer negative input; upstream layers are intentionally not tested";
        requiredShape = [
          "public-ingress declaration has protocol and public port"
          "target endpoint is absent"
          "renderer must report the missing explicit CPM field instead of guessing a target from names"
        ];
      };
      skippedUpstreamLayers = [
        "intent-source"
        "network-compiler"
        "network-forwarding-model"
        "network-control-plane-model"
      ];
      expectedWarnings = [
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"
        "WARN_LAYER_ENTRY_SKIPS_NFM"
        "WARN_LAYER_ENTRY_SKIPS_CPM"
      ];
      downstreamPath = [
        "network-renderer-nixos"
        "network-renderer-containerlab-linux-backend"
      ];
      expected = {
        kind = "negative-fail-closed";
        includedLayers = [
          "network-renderer-nixos"
          "network-renderer-containerlab-linux-backend"
        ];
        assertions = [
          "renderer evaluation fails deterministically"
          "diagnostic identifies the missing public-ingress target field"
        ];
      };
      owningLayerForInvalidInput = "renderer";
      evidenceContext = {
        kind = "template-source";
        maySupport = [ "SMT" "SIT" ];
        mustNotClaim = [ "HAT" "SAT" ];
        requiredBeforePromotion = [
          "replace placeholder ID with the real trace chain"
          "add negative renderer tests that assert the exact diagnostic"
        ];
      };
      onPremHostAttachment = {
        required = false;
      };
    };

    "FS-TEMPLATE-RENAME-TO-CORRECT-RUNTIME-VLAN2-PRESERVATION-SMS-005" = {
      id = "FS-TEMPLATE-RENAME-TO-CORRECT-RUNTIME-VLAN2-PRESERVATION-SMS-005";
      renameRequired = true;
      description = "Start at a rendered/runtime artifact boundary and guard that on-prem NixOS validation keeps the VLAN2 management adapter explicit.";
      entryBoundary = "runtime-artifact";
      suppliedArtifact = {
        kind = "rendered-host-artifact-or-runtime-harness-input";
        contract = "runtime artifact boundary; model, CPM, and renderer construction are not proven by this scenario";
        requiredShape = [
          "host adapter requirement references the controlled VLAN2 template"
          "runtime probe must check eth0.2 or equivalent VLAN2 management reachability before acceptance"
          "no extra WAN or access uplinks are hidden in the host-adapter template"
        ];
      };
      skippedUpstreamLayers = [
        "intent-source"
        "network-compiler"
        "network-forwarding-model"
        "network-control-plane-model"
        "renderer"
      ];
      expectedWarnings = [
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"
        "WARN_LAYER_ENTRY_SKIPS_NFM"
        "WARN_LAYER_ENTRY_SKIPS_CPM"
        "WARN_LAYER_ENTRY_SKIPS_RENDERER"
      ];
      downstreamPath = [
        "runtime-harness"
      ];
      expected = {
        kind = "runtime-guard";
        includedLayers = [
          "runtime-harness"
        ];
        assertions = [
          "validation fails before HAT/SAT promotion if VLAN2 management attachment is missing"
          "runtime result does not claim compiler, NFM, CPM, or renderer coverage"
        ];
      };
      owningLayerForInvalidInput = "runtime-harness";
      evidenceContext = {
        kind = "template-source";
        maySupport = [ "HAT-preparation" "SAT-preparation" ];
        mustNotClaim = [ "HAT" "SAT" ];
        requiredBeforePromotion = [
          "replace placeholder ID with the real trace chain"
          "run the owning VM or host harness and record live probes"
        ];
      };
      onPremHostAttachment = {
        required = true;
        template = "GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix";
        reason = "VLAN2 must remain explicit for controlled on-prem NixOS validation.";
      };
    };
  };
}
