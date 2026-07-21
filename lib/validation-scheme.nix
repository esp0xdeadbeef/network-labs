{
  inputs,
  system,
  rootLockIdentity,
  networkLabsRevision,
}:

let
  schema = inputs.network-realization-schema.lib;
  realization = inputs.network-realization-model.lib;

  replacementContract = "network-control-plane-artifact/v1";
  firstActiveBoundary = "network-realization-model";
  skipReason = "FS-166 controlled replacement-artifact construction scenario";

  stageDefinitions = [
    {
      flake = inputs.network-compiler;
      api = inputs.network-compiler.libBySystem.${system}.controlledSkip;
    }
    {
      flake = inputs.network-forwarding-model;
      api = inputs.network-forwarding-model.libBySystem.${system}.controlledSkip;
    }
    {
      flake = inputs.network-control-plane-model;
      api = inputs.network-control-plane-model.libBySystem.${system}.controlledSkip;
    }
  ];

  rendererDefinitions = {
    nixos = {
      repository = "network-renderer-nixos";
      validate = inputs.network-renderer-nixos.libBySystem.${system}.renderer.canonical.validateInput;
    };
    access-endpoint-nixos = {
      repository = "network-renderer-access-endpoint-nixos";
      validate =
        inputs.network-renderer-access-endpoint-nixos.libBySystem.${system}.renderer.canonical.validateInput;
    };
    clab = {
      repository = "network-renderer-containerlab-linux-backend";
      validate = inputs.network-renderer-containerlab-linux-backend.lib.renderer.canonical.validateInput;
    };
    wireguard = {
      repository = "network-renderer-wireguard";
      validate = inputs.network-renderer-wireguard.libBySystem.${system}.renderer.canonical.validateInput;
    };
    nebula = {
      repository = "network-renderer-nebula";
      validate = inputs.network-renderer-nebula.libBySystem.${system}.renderer.canonical.validateInput;
    };
    openconfig = {
      repository = "network-renderer-openconfig";
      validate =
        inputs.network-renderer-openconfig.libBySystem.${system}.renderer.canonical.validateInput;
    };
  };

  scenarioDefinitions = {
    "FS-166-HDS-010-SDS-010-SMS-901" = {
      target = "nixos";
      deploymentHost = "s-router-nixos";
      sourceArtifact = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/nixos-single.nix;
      expectedRuntimeTargets = 1;
      expectedTargetNames = [ "poc-router" ];
      interfaceBindings = { };
      secretBindings = { };
    };
    "FS-166-HDS-010-SDS-010-SMS-902" = {
      target = "nixos";
      deploymentHost = "s-router-nixos";
      sourceArtifact = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/nixos-p2p.nix;
      expectedRuntimeTargets = 2;
      expectedTargetNames = [
        "edge-a"
        "edge-b"
      ];
      interfaceBindings = {
        edge-a.edge-a-b.runtimeName = "eth1";
        edge-b.edge-a-b.runtimeName = "eth1";
      };
      secretBindings = { };
    };
    "FS-166-HDS-010-SDS-010-SMS-903" = {
      target = "access-endpoint-nixos";
      deploymentHost = "s-router-test-clients";
      sourceArtifact = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/access-endpoint.nix;
      expectedRuntimeTargets = 1;
      expectedTargetNames = [ "poc-client" ];
      interfaceBindings.poc-client.runtimeName = "eth1";
      secretBindings = { };
    };
    "FS-166-HDS-010-SDS-010-SMS-904" = {
      target = "clab";
      deploymentHost = "s-router-clab";
      sourceArtifact = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/clab-p2p.nix;
      expectedRuntimeTargets = 2;
      expectedTargetNames = [
        "edge-a"
        "edge-b"
      ];
      interfaceBindings = {
        edge-a.edge-a-b.runtimeName = "eth1";
        edge-b.edge-a-b.runtimeName = "eth1";
      };
      secretBindings = { };
    };
    "FS-166-HDS-010-SDS-010-SMS-905" = {
      target = "wireguard";
      deploymentHost = "s-router-nixos";
      sourceArtifact = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/wireguard.nix;
      expectedRuntimeTargets = 1;
      expectedTargetNames = [ "wireguard-egress" ];
      interfaceBindings.wireguard-egress.wg-lab.runtimeName = "wg-lab";
      secretBindings.profile = {
        reference = "sops:wireguard-lab-profile";
        destination = "/run/network-renderer-wireguard/profile.conf";
        readOnly = true;
      };
    };
    "FS-166-HDS-010-SDS-010-SMS-906" = {
      target = "nebula";
      deploymentHost = "s-router-nixos";
      sourceArtifact = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/nebula.nix;
      expectedRuntimeTargets = 2;
      expectedTargetNames = [
        "lab-client-nebula"
        "lab-lighthouse"
      ];
      interfaceBindings = {
        lab-client-nebula.nebula-lab.runtimeName = "nebula1";
        lab-lighthouse.nebula-lab.runtimeName = "nebula1";
      };
      secretBindings.identity = {
        reference = "sops:nebula-lab-identity";
        destination = "/run/network-renderer-nebula/identity";
        readOnly = true;
      };
    };
  };

  requiredManifestFields = [
    "traceId"
    "kind"
    "replacementContract"
    "declaredFirstActiveBoundary"
    "sourceArtifactIdentity"
    "rendererTarget"
    "sourceRendererTarget"
    "sourceTraceId"
    "deploymentHost"
    "sourceDeploymentHost"
    "maxRuntimeTargets"
    "expectedTargetNames"
    "observedTargetNames"
    "realizationCompleted"
    "schemaValidationCompleted"
    "evidencePhase"
    "evidenceIdentities"
  ];

  mkAccepted = traceId: {
    accepted = true;
    exit = 0;
    diagnostic = null;
    inherit traceId;
  };

  mkRejected =
    {
      traceId,
      code,
      detail,
      relatedDiagnostics ? [ ],
    }:
    {
      accepted = false;
      exit = 2;
      diagnostic = {
        inherit
          code
          detail
          relatedDiagnostics
          traceId
          ;
        message = "${code}: ${traceId}: ${detail}";
      };
      inherit traceId;
    };

  validateSourceArtifact =
    traceId: sourceArtifact:
    let
      controlPlaneModel = sourceArtifact.control_plane_model or null;
      computedDigest =
        if builtins.isAttrs controlPlaneModel then
          builtins.hashString "sha256" (builtins.toJSON controlPlaneModel)
        else
          null;
    in
    if
      !builtins.isAttrs sourceArtifact
      || !builtins.isAttrs controlPlaneModel
      || (sourceArtifact.kind or null) != "network-control-plane-artifact"
      || (sourceArtifact.artifactIdentity or null) != computedDigest
      || (sourceArtifact.artifactDigest or null) != computedDigest
      || (sourceArtifact.provenance.traceId or null) != traceId
      || (sourceArtifact.provenance.contract or null) != replacementContract
      || (sourceArtifact.provenance.declaredFirstActiveBoundary or null) != firstActiveBoundary
      || (controlPlaneModel.meta.traceId or null) != traceId
    then
      mkRejected {
        inherit traceId;
        code = "NS_REPLACEMENT_ARTIFACT_INVALID";
        detail = "source artifact does not satisfy ${replacementContract}";
      }
    else
      mkAccepted traceId;

  validateScenarioManifest =
    manifest:
    let
      traceId = manifest.traceId or "<missing-trace>";
      missingFields = builtins.filter (
        name: !(builtins.hasAttr name manifest) || manifest.${name} == null
      ) requiredManifestFields;
      missingField = if missingFields == [ ] then null else builtins.head missingFields;
      observedCount = builtins.length (manifest.observedTargetNames or [ ]);
      liveIdentityNames = [
        "bootId"
        "bundleIdentity"
        "bindingIdentity"
        "rendererIdentity"
        "rootLockIdentity"
        "sourceIdentity"
      ];
      missingLiveIdentities = builtins.filter (
        name:
        !(builtins.hasAttr name (manifest.evidenceIdentities or { }))
        || manifest.evidenceIdentities.${name} == null
      ) liveIdentityNames;
      missingLiveIdentity =
        if missingLiveIdentities == [ ] then null else builtins.head missingLiveIdentities;
    in
    if missingField != null then
      mkRejected {
        inherit traceId;
        code = "NS_MINI_MANIFEST_INCOMPLETE";
        detail = "missing required field ${missingField}";
      }
    else if
      manifest.kind != "replacement-cpm-artifact"
      || manifest.replacementContract != replacementContract
      || manifest.declaredFirstActiveBoundary != firstActiveBoundary
    then
      mkRejected {
        inherit traceId;
        code = "NS_REPLACEMENT_BOUNDARY_INVALID";
        detail = "replacement must be injected exactly once at ${firstActiveBoundary}";
        relatedDiagnostics = [ "NS_REALIZATION_GATE_MISSING" ];
      }
    else if !(manifest.realizationCompleted && manifest.schemaValidationCompleted) then
      mkRejected {
        inherit traceId;
        code = "NS_REALIZATION_GATE_MISSING";
        detail = "realization and schema validation must complete before renderer execution";
      }
    else if
      manifest.sourceTraceId != manifest.traceId
      || manifest.sourceRendererTarget != manifest.rendererTarget
      || manifest.sourceDeploymentHost != manifest.deploymentHost
    then
      mkRejected {
        inherit traceId;
        code = "NS_MINI_SOURCE_TARGET_MISMATCH";
        detail = "source trace, renderer target, or deployment host disagrees with the manifest";
      }
    else if
      observedCount > manifest.maxRuntimeTargets
      || manifest.observedTargetNames != manifest.expectedTargetNames
    then
      mkRejected {
        inherit traceId;
        code = "NS_RUNTIME_SCOPE_MISMATCH";
        detail = "expected ${builtins.toJSON manifest.expectedTargetNames}, observed ${builtins.toJSON manifest.observedTargetNames}";
      }
    else if manifest.evidencePhase == "live" && missingLiveIdentity != null then
      mkRejected {
        inherit traceId;
        code = "NS_EVIDENCE_IDENTITY_MISSING";
        detail = "missing live evidence identity ${missingLiveIdentity}";
      }
    else
      mkAccepted traceId;

  orderedFlowRepositories = [
    "network-compiler"
    "network-forwarding-model"
    "network-control-plane-model"
    "network-realization-model"
    "network-realization-schema"
    "network-renderer-nixos"
  ];

  replacementBoundaryByRepository = {
    network-compiler = {
      boundary = "network-compiler";
      contract = "network-intent-inventory/v1";
    };
    network-forwarding-model = {
      boundary = "network-forwarding-model";
      contract = "network-forwarding-input/v1";
    };
    network-control-plane-model = {
      boundary = "network-control-plane-model";
      contract = "network-control-plane-input/v1";
    };
    network-realization-model = {
      boundary = "network-realization-model";
      contract = replacementContract;
    };
  };

  isContiguousSkippedPrefix =
    modes:
    let
      visit =
        normalSeen: remaining:
        if remaining == [ ] then
          true
        else
          let
            mode = builtins.head remaining;
          in
          if mode == "skip" then
            !normalSeen && visit false (builtins.tail remaining)
          else if mode == "normal" then
            visit true (builtins.tail remaining)
          else
            visit normalSeen (builtins.tail remaining);
    in
    visit false modes;

  firstNormalRepository =
    stages:
    let
      normalStages = builtins.filter (stage: stage.mode == "normal") stages;
    in
    if normalStages == [ ] then null else (builtins.head normalStages).repository;

  validateFlowManifest =
    manifest:
    let
      traceId = manifest.traceId or "<missing-trace>";
      selectedRenderer = manifest.selectedRenderer or "network-renderer-nixos";
      expectedRepositories = [
        "network-compiler"
        "network-forwarding-model"
        "network-control-plane-model"
        "network-realization-model"
        "network-realization-schema"
      ]
      ++ [ selectedRenderer ];
      stages = manifest.stages or [ ];
      observedRepositories = map (stage: stage.repository or "<missing>") stages;
      observedModes = map (stage: stage.mode or "<missing>") stages;
      requiredLockNodes = expectedRepositories;
      missingLockNodes = builtins.filter (
        repository: !(builtins.elem repository (manifest.lockClosure or [ ]))
      ) requiredLockNodes;
      missingRepositories = builtins.filter (
        repository: !(builtins.elem repository observedRepositories)
      ) expectedRepositories;
      firstActiveRepository = firstNormalRepository stages;
      boundaryContract =
        if
          firstActiveRepository != null
          && builtins.hasAttr firstActiveRepository replacementBoundaryByRepository
        then
          replacementBoundaryByRepository.${firstActiveRepository}
        else
          null;
      skippedRepositories = map (stage: stage.repository) (
        builtins.filter (stage: stage.mode == "skip") stages
      );
      acknowledgedRepositories = manifest.skipAcknowledgements or [ ];
      uniqueAcknowledgements = uniqueNames acknowledgedRepositories;
      expectedNormalRepositories = map (stage: stage.repository) (
        builtins.filter (stage: stage.mode == "normal") stages
      );
      executedNormalRepositories = manifest.executedNormalStages or [ ];
      missingNormalRepositories = builtins.filter (
        repository: !(builtins.elem repository executedNormalRepositories)
      ) expectedNormalRepositories;
      invalidModes = builtins.filter (
        mode:
        !(builtins.elem mode [
          "normal"
          "skip"
        ])
      ) observedModes;
    in
    if missingLockNodes != [ ] then
      mkRejected {
        inherit traceId;
        code = "NS_LOCK_CLOSURE_INCOMPLETE";
        detail = "missing locked repository ${builtins.head missingLockNodes}";
      }
    else if observedRepositories != expectedRepositories || missingRepositories != [ ] then
      mkRejected {
        inherit traceId;
        code = "NS_HOP_MISSING";
        detail = "expected ordered hops ${builtins.toJSON expectedRepositories}, observed ${builtins.toJSON observedRepositories}";
      }
    else if !(isContiguousSkippedPrefix observedModes) then
      mkRejected {
        inherit traceId;
        code = "NS_SKIP_PREFIX_NONCONTIGUOUS";
        detail = "skip mode must form one contiguous prefix";
      }
    else if
      acknowledgedRepositories != skippedRepositories
      || builtins.length uniqueAcknowledgements != builtins.length acknowledgedRepositories
    then
      mkRejected {
        inherit traceId;
        code = "NS_ACK_CHAIN_INVALID";
        detail = "expected acknowledgements ${builtins.toJSON skippedRepositories}, observed ${builtins.toJSON acknowledgedRepositories}";
      }
    else if manifest.directEntryUncontrolled or false then
      mkRejected {
        inherit traceId;
        code = "NS_DIRECT_ENTRY_UNCONTROLLED";
        detail = "direct renderer or runtime entry is not a controlled flow";
      }
    else if (manifest.replacement.count or 0) != 1 then
      mkRejected {
        inherit traceId;
        code = "NS_REPLACEMENT_COUNT_INVALID";
        detail = "expected one replacement delivery, observed ${
          builtins.toString (manifest.replacement.count or 0)
        }";
      }
    else if
      boundaryContract == null
      || (manifest.replacement.boundary or null) != boundaryContract.boundary
      || (manifest.replacement.contract or null) != boundaryContract.contract
    then
      mkRejected {
        inherit traceId;
        code = "NS_REPLACEMENT_BOUNDARY_INVALID";
        detail = "replacement must satisfy the input contract of ${toString firstActiveRepository}";
      }
    else if invalidModes != [ ] || missingNormalRepositories != [ ] then
      mkRejected {
        inherit traceId;
        code = "NS_DOWNSTREAM_STAGE_BYPASSED";
        detail = "normally executed suffix is incomplete: ${builtins.toJSON missingNormalRepositories}";
      }
    else if
      !(manifest.realizationCompleted or false) || !(manifest.schemaValidationCompleted or false)
    then
      mkRejected {
        inherit traceId;
        code = "NS_REALIZATION_GATE_MISSING";
        detail = "realization and schema validation must complete before renderer invocation";
      }
    else
      mkAccepted traceId;

  evidenceIdentityNames = [
    "acknowledgementChainIdentity"
    "bindingIdentity"
    "bundleIdentity"
    "contextIdentity"
    "rendererIdentity"
    "replacementIdentity"
    "rootLockIdentity"
    "traceIdentity"
  ];

  validateEvidenceManifest =
    manifest:
    let
      traceId = manifest.traceId or "<missing-trace>";
      skippedRepositories = manifest.skippedRepositories or [ ];
      passedRepositories = manifest.passedRepositories or [ ];
      normallyExecutedRepositories = manifest.normallyExecutedRepositories or [ ];
      skippedClaimedPass = builtins.filter (
        repository: builtins.elem repository passedRepositories
      ) skippedRepositories;
      scopeOverrun = builtins.filter (
        repository: !(builtins.elem repository normallyExecutedRepositories)
      ) passedRepositories;
      missingIdentities = builtins.filter (
        name:
        !(builtins.hasAttr name (manifest.identities or { }))
        || manifest.identities.${name} == null
        || manifest.identities.${name} == ""
      ) evidenceIdentityNames;
      runtimeIdentityNames = [
        "activeArtifactIdentity"
        "bootId"
        "host"
        "observationIdentity"
      ];
      missingRuntimeIdentities = builtins.filter (
        name:
        !(builtins.hasAttr name (manifest.runtimeContext or { }))
        || manifest.runtimeContext.${name} == null
        || manifest.runtimeContext.${name} == ""
      ) runtimeIdentityNames;
      persistedEvidence = manifest.persistedEvidence or [ ];
      exposedPublicAddresses = builtins.filter (
        item: (item.classification or null) == "public-address" && !(item.redacted or false)
      ) persistedEvidence;
      exposedProtectedValues = builtins.filter (
        item: (item.classification or null) == "protected" && !(item.redacted or false)
      ) persistedEvidence;
    in
    if skippedClaimedPass != [ ] then
      mkRejected {
        inherit traceId;
        code = "NS_SKIPPED_STAGE_CLAIMED_PASS";
        detail = "skipped repository ${builtins.head skippedClaimedPass} was claimed passed";
      }
    else if
      (manifest.sourceKind or "controlled-flow") == "direct-entry"
      && (manifest.claimedLayer or "construction") != "construction"
    then
      mkRejected {
        inherit traceId;
        code = "NS_DIRECT_ENTRY_PROMOTED";
        detail = "direct-entry evidence cannot be promoted beyond construction";
      }
    else if missingIdentities != [ ] then
      mkRejected {
        inherit traceId;
        code = "NS_EVIDENCE_IDENTITY_MISSING";
        detail = "missing evidence identity ${builtins.head missingIdentities}";
      }
    else if scopeOverrun != [ ] then
      mkRejected {
        inherit traceId;
        code = "NS_EVIDENCE_SCOPE_OVERRUN";
        detail = "repository ${builtins.head scopeOverrun} was not normally executed";
      }
    else if (manifest.evidencePhase or "construction") == "live" && missingRuntimeIdentities != [ ] then
      mkRejected {
        inherit traceId;
        code = "NS_RUNTIME_CONTEXT_UNPROVEN";
        detail = "missing live runtime identity ${builtins.head missingRuntimeIdentities}";
      }
    else if !(manifest.selectedEntrypoint.canonical or false) then
      mkRejected {
        inherit traceId;
        code = "NS_SUPERSEDED_ENTRYPOINT_SELECTED";
        detail = "selected entrypoint is not the canonical trace-derived entrypoint";
      }
    else if exposedPublicAddresses != [ ] then
      mkRejected {
        inherit traceId;
        code = "NS_PUBLIC_ADDRESS_EXPOSED";
        detail = "public address at ${
          (builtins.head exposedPublicAddresses).path or "<unknown>"
        } was not redacted";
      }
    else if exposedProtectedValues != [ ] then
      mkRejected {
        inherit traceId;
        code = "NS_PROTECTED_VALUE_EXPOSED";
        detail = "protected value was not redacted";
      }
    else
      mkAccepted traceId;

  scenarioManifestFor = traceId: definition: observedTargetNames: {
    inherit traceId observedTargetNames;
    kind = "replacement-cpm-artifact";
    inherit replacementContract;
    declaredFirstActiveBoundary = firstActiveBoundary;
    sourceArtifactIdentity = builtins.hashString "sha256" (toString definition.sourceArtifact);
    rendererTarget = definition.target;
    sourceRendererTarget = definition.target;
    sourceTraceId = traceId;
    inherit (definition) deploymentHost expectedTargetNames;
    sourceDeploymentHost = definition.deploymentHost;
    maxRuntimeTargets = builtins.length definition.expectedTargetNames;
    realizationCompleted = true;
    schemaValidationCompleted = true;
    evidencePhase = "construction";
    evidenceIdentities = { };
  };

  collectNamedAttributeSets =
    attributeName: value:
    if builtins.isAttrs value then
      (
        if builtins.hasAttr attributeName value && builtins.isAttrs value.${attributeName} then
          [ value.${attributeName} ]
        else
          [ ]
      )
      ++ builtins.concatLists (
        map (name: collectNamedAttributeSets attributeName value.${name}) (builtins.attrNames value)
      )
    else if builtins.isList value then
      builtins.concatLists (map (collectNamedAttributeSets attributeName) value)
    else
      [ ];

  uniqueNames =
    names:
    builtins.attrNames (
      builtins.listToAttrs (
        map (name: {
          inherit name;
          value = true;
        }) names
      )
    );

  targetNamesFor =
    target: controlPlaneModel:
    let
      attributeName =
        if target == "access-endpoint-nixos" then "endpointAssignment" else "runtimeTargets";
    in
    uniqueNames (
      builtins.concatLists (
        map builtins.attrNames (collectNamedAttributeSets attributeName controlPlaneModel)
      )
    );

  makePlatformBinding =
    {
      traceId,
      target,
      bundle,
      definition ? {
        deploymentHost = "construction";
        expectedTargetNames = [ ];
        interfaceBindings = { };
        secretBindings = { };
      },
    }:
    let
      candidate = {
        kind = schema.schema.platformBinding.kind;
        schemaRevision = schema.schema.platformBinding.revision;
        bundleIdentity = bundle.bundleIdentity;
        inherit target;
        requestScope = bundle.requestScope;
        categories = {
          interfaceIdentity = definition.interfaceBindings;
          deployment = {
            host = definition.deploymentHost;
            targetNames = definition.expectedTargetNames;
          };
          secretDelivery = definition.secretBindings;
          lifecycle = {
            evidenceContext = "construction";
            activation = "cold-stage-required-for-live-evidence";
          };
          backend = {
            selectedRenderer = target;
            operation = "canonical.validateInput";
          };
        };
        provenance = {
          producer = "network-labs";
          producerRevision = networkLabsRevision;
          sourceIdentity = traceId;
        };
      };
      identified = candidate // {
        bindingIdentity = schema.computeBindingIdentity candidate;
      };
    in
    identified
    // {
      validation = schema.validatePlatformBinding identified;
    };

  makeAcknowledgement =
    {
      traceId,
      replacementIdentity,
      replacementDigest,
    }:
    stage:
    let
      api = stage.api;
      acknowledgement = api.acknowledge {
        inherit
          traceId
          replacementIdentity
          replacementDigest
          ;
        declaredRepository = api.repository;
        lockedRepositoryRevision = stage.flake.rev;
        declaredStageIndex = api.stageIndex;
        declaredNormalInputContract = api.normalInputContract;
        inherit replacementContract;
        expectedReplacementContract = replacementContract;
        declaredFirstActiveBoundary = firstActiveBoundary;
        expectedFirstActiveBoundary = firstActiveBoundary;
        reason = skipReason;
        declaredPreviousStage = api.previousStage;
        declaredNextStage = api.nextStage;
      };
    in
    builtins.deepSeq acknowledgement acknowledgement;

  makeScenario =
    traceId: definition:
    let
      sourceArtifact = import definition.sourceArtifact;
      sourceValidation = validateSourceArtifact traceId sourceArtifact;
      _sourceArtifact =
        if sourceValidation.accepted then true else throw sourceValidation.diagnostic.message;
      controlPlaneModel = sourceArtifact.control_plane_model;
      observedTargetNames = targetNamesFor definition.target controlPlaneModel;
      scenarioManifest = scenarioManifestFor traceId definition observedTargetNames;
      manifestValidation = validateScenarioManifest scenarioManifest;
      _manifest =
        if manifestValidation.accepted then true else throw manifestValidation.diagnostic.message;
      replacementDigest = sourceArtifact.artifactDigest;
      replacement = sourceArtifact;
      acknowledgements = map (makeAcknowledgement {
        inherit
          traceId
          replacementDigest
          ;
        replacementIdentity = replacement.artifactIdentity;
      }) stageDefinitions;
      bundle = realization.realize {
        input = replacement;
        requestScope = {
          kind = "complete-artifact";
          identity = traceId;
        };
        inherit rootLockIdentity;
        producerRevision = inputs.network-realization-model.rev;
      };
      platformBinding = makePlatformBinding {
        inherit traceId bundle definition;
        target = definition.target;
      };
      renderer = rendererDefinitions.${definition.target};
      rendererResult = renderer.validate {
        inherit bundle platformBinding;
      };
      releasedRendererResult = builtins.deepSeq rendererResult {
        repository = renderer.repository;
        target = definition.target;
        mode = "normal";
        operation = "canonical.validateInput";
        bundleIdentity = rendererResult.bundleIdentity;
        bindingIdentity = rendererResult.bindingIdentity;
        requestScope = rendererResult.requestScope;
      };
    in
    builtins.deepSeq [ _sourceArtifact _manifest ] {
      inherit scenarioManifest;
      manifest = {
        inherit
          traceId
          replacementContract
          rootLockIdentity
          ;
        declaredReplacementBoundary = firstActiveBoundary;
        replacementArtifactIdentity = replacement.artifactIdentity;
        inherit replacementDigest;
        specificationReason = skipReason;
        selectedRenderer = renderer.repository;
        requestedEvidenceContext = "SMT construction";
        expectedResult = "canonical renderer input accepted";
        owningLayerForInvalidInput = "first active semantic or renderer boundary";
        skippedRepositories = map (stage: stage.api.repository) stageDefinitions;
        completeDownstreamPath = [
          "network-realization-model"
          "network-realization-schema"
          renderer.repository
          "SMT construction evidence"
        ];
      };
      controlFlow = {
        skippedAcknowledgements = acknowledgements;
        activeStages = [
          {
            repository = "network-realization-model";
            revision = inputs.network-realization-model.rev;
            mode = "normal";
          }
          {
            repository = "network-realization-schema";
            revision = inputs.network-realization-schema.rev;
            mode = "validation";
          }
          {
            repository = renderer.repository;
            mode = "normal";
          }
        ];
      };
      artifactFlow = {
        injection = {
          boundary = firstActiveBoundary;
          artifactIdentity = replacement.artifactIdentity;
          digest = replacementDigest;
        };
        realization = {
          bundleIdentity = bundle.bundleIdentity;
          producer = bundle.provenance.producer;
          validationIdentity = bundle.validation.validationIdentity;
        };
        schemaValidation = bundle.validation;
        platformBinding = {
          bindingIdentity = platformBinding.bindingIdentity;
          bundleIdentity = platformBinding.bundleIdentity;
          categoryNames = platformBinding.validation.categoryNames;
          validation = platformBinding.validation;
        };
        renderer = releasedRendererResult;
      };
      evidence = {
        status = "construction-ok";
        normallyExecuted = [
          "network-realization-model"
          "network-realization-schema"
          renderer.repository
        ];
        notCovered = map (stage: stage.api.repository) stageDefinitions;
        inherit (definition) expectedRuntimeTargets;
        inherit observedTargetNames;
      };
    };

  negativeBase =
    scenarioManifestFor "FS-166-HDS-010-SDS-010-SMS-901"
      (scenarioDefinitions."FS-166-HDS-010-SDS-010-SMS-901")
      [ "poc-router" ];

  mkNegativeCase =
    {
      injection,
      manifest,
      expectedDiagnostic,
      expectedRelatedDiagnostics ? [ ],
    }:
    let
      result = validateScenarioManifest manifest;
      recovery = validateScenarioManifest negativeBase;
    in
    {
      inherit
        expectedDiagnostic
        expectedRelatedDiagnostics
        injection
        recovery
        result
        ;
      expectedExit = 2;
    };

  scenarioNegativeCases = {
    NS-MINI-N1 = mkNegativeCase {
      injection = "remove maxRuntimeTargets";
      manifest = builtins.removeAttrs negativeBase [ "maxRuntimeTargets" ];
      expectedDiagnostic = "NS_MINI_MANIFEST_INCOMPLETE";
    };
    NS-MINI-N2 = mkNegativeCase {
      injection = "pair the NixOS replacement with the CLAB renderer target";
      manifest = negativeBase // {
        sourceRendererTarget = "clab";
      };
      expectedDiagnostic = "NS_MINI_SOURCE_TARGET_MISMATCH";
    };
    NS-MINI-N3 = mkNegativeCase {
      injection = "send replacement CPM directly to the renderer";
      manifest = negativeBase // {
        declaredFirstActiveBoundary = "network-renderer-nixos";
      };
      expectedDiagnostic = "NS_REPLACEMENT_BOUNDARY_INVALID";
      expectedRelatedDiagnostics = [ "NS_REALIZATION_GATE_MISSING" ];
    };
    NS-MINI-N4 = mkNegativeCase {
      injection = "add an undeclared runtime target";
      manifest = negativeBase // {
        observedTargetNames = [
          "poc-router"
          "rogue-target"
        ];
      };
      expectedDiagnostic = "NS_RUNTIME_SCOPE_MISMATCH";
    };
    NS-MINI-N5 = mkNegativeCase {
      injection = "remove boot identity from live evidence";
      manifest = negativeBase // {
        evidencePhase = "live";
        evidenceIdentities = {
          bindingIdentity = "binding";
          bundleIdentity = "bundle";
          rendererIdentity = "renderer";
          rootLockIdentity = "lock";
          sourceIdentity = "source";
        };
      };
      expectedDiagnostic = "NS_EVIDENCE_IDENTITY_MISSING";
    };
    NS-MINI-N6 =
      let
        traceId = "FS-166-HDS-010-SDS-010-SMS-901";
      in
      {
        injection = "supply a raw CPM attrset without the replacement artifact envelope";
        expectedDiagnostic = "NS_REPLACEMENT_ARTIFACT_INVALID";
        expectedRelatedDiagnostics = [ ];
        expectedExit = 2;
        result = validateSourceArtifact traceId {
          control_plane_model.meta.traceId = traceId;
        };
        recovery = validateSourceArtifact traceId (import scenarioDefinitions.${traceId}.sourceArtifact);
      };
  };

  flowTraceId = "FS-166-HDS-010-SDS-010-SMS-020";
  flowBase = {
    traceId = flowTraceId;
    selectedRenderer = "network-renderer-nixos";
    lockClosure = orderedFlowRepositories;
    stages = [
      {
        repository = "network-compiler";
        mode = "skip";
      }
      {
        repository = "network-forwarding-model";
        mode = "skip";
      }
      {
        repository = "network-control-plane-model";
        mode = "skip";
      }
      {
        repository = "network-realization-model";
        mode = "normal";
      }
      {
        repository = "network-realization-schema";
        mode = "normal";
      }
      {
        repository = "network-renderer-nixos";
        mode = "normal";
      }
    ];
    skipAcknowledgements = [
      "network-compiler"
      "network-forwarding-model"
      "network-control-plane-model"
    ];
    replacement = {
      boundary = "network-realization-model";
      contract = replacementContract;
      count = 1;
    };
    executedNormalStages = [
      "network-realization-model"
      "network-realization-schema"
      "network-renderer-nixos"
    ];
    directEntryUncontrolled = false;
    realizationCompleted = true;
    schemaValidationCompleted = true;
  };

  flowBoundaryCases = {
    compiler-input = flowBase // {
      stages = map (stage: stage // { mode = "normal"; }) flowBase.stages;
      skipAcknowledgements = [ ];
      replacement = {
        boundary = "network-compiler";
        contract = "network-intent-inventory/v1";
        count = 1;
      };
      executedNormalStages = orderedFlowRepositories;
    };
    nfm-input = flowBase // {
      stages = [
        {
          repository = "network-compiler";
          mode = "skip";
        }
      ]
      ++ map (stage: stage // { mode = "normal"; }) (builtins.tail flowBase.stages);
      skipAcknowledgements = [ "network-compiler" ];
      replacement = {
        boundary = "network-forwarding-model";
        contract = "network-forwarding-input/v1";
        count = 1;
      };
      executedNormalStages = builtins.tail orderedFlowRepositories;
    };
    cpm-input = flowBase // {
      stages = [
        {
          repository = "network-compiler";
          mode = "skip";
        }
        {
          repository = "network-forwarding-model";
          mode = "skip";
        }
      ]
      ++ map (stage: stage // { mode = "normal"; }) (builtins.tail (builtins.tail flowBase.stages));
      skipAcknowledgements = [
        "network-compiler"
        "network-forwarding-model"
      ];
      replacement = {
        boundary = "network-control-plane-model";
        contract = "network-control-plane-input/v1";
        count = 1;
      };
      executedNormalStages = builtins.tail (builtins.tail orderedFlowRepositories);
    };
    realization-input = flowBase;
  };

  mkFlowNegativeCase =
    {
      injection,
      manifest,
      expectedDiagnostic,
    }:
    {
      inherit injection expectedDiagnostic;
      expectedExit = 2;
      result = validateFlowManifest manifest;
      recovery = validateFlowManifest flowBase;
    };

  flowNegativeCases = {
    NS-FLOW-N1 = mkFlowNegativeCase {
      injection = "remove network-realization-schema from the root lock closure";
      manifest = flowBase // {
        lockClosure = builtins.filter (
          repository: repository != "network-realization-schema"
        ) flowBase.lockClosure;
      };
      expectedDiagnostic = "NS_LOCK_CLOSURE_INCOMPLETE";
    };
    NS-FLOW-N2 = mkFlowNegativeCase {
      injection = "execute NFM normally and then mark CPM skipped";
      manifest = flowBase // {
        stages = map (
          stage:
          if stage.repository == "network-forwarding-model" then stage // { mode = "normal"; } else stage
        ) flowBase.stages;
        skipAcknowledgements = [
          "network-compiler"
          "network-control-plane-model"
        ];
      };
      expectedDiagnostic = "NS_SKIP_PREFIX_NONCONTIGUOUS";
    };
    NS-FLOW-N3 = mkFlowNegativeCase {
      injection = "omit the NFM controlled-skip acknowledgement";
      manifest = flowBase // {
        skipAcknowledgements = [
          "network-compiler"
          "network-control-plane-model"
        ];
      };
      expectedDiagnostic = "NS_ACK_CHAIN_INVALID";
    };
    NS-FLOW-N4 = mkFlowNegativeCase {
      injection = "deliver CPM output to CPM after a compiler-only skip";
      manifest = flowBoundaryCases.nfm-input // {
        replacement = {
          boundary = "network-control-plane-model";
          contract = replacementContract;
          count = 1;
        };
      };
      expectedDiagnostic = "NS_REPLACEMENT_BOUNDARY_INVALID";
    };
    NS-FLOW-N5 = mkFlowNegativeCase {
      injection = "deliver the replacement artifact twice";
      manifest = flowBase // {
        replacement = flowBase.replacement // {
          count = 2;
        };
      };
      expectedDiagnostic = "NS_REPLACEMENT_COUNT_INVALID";
    };
    NS-FLOW-N6 = mkFlowNegativeCase {
      injection = "omit CPM from the normally executed suffix";
      manifest = flowBoundaryCases.cpm-input // {
        executedNormalStages = builtins.filter (
          repository: repository != "network-control-plane-model"
        ) flowBoundaryCases.cpm-input.executedNormalStages;
      };
      expectedDiagnostic = "NS_DOWNSTREAM_STAGE_BYPASSED";
    };
    NS-FLOW-N7 = mkFlowNegativeCase {
      injection = "send replacement CPM output to the renderer without realization";
      manifest = flowBase // {
        realizationCompleted = false;
      };
      expectedDiagnostic = "NS_REALIZATION_GATE_MISSING";
    };
    NS-FLOW-N8 = mkFlowNegativeCase {
      injection = "label a direct renderer fixture invocation as controlled flow";
      manifest = flowBase // {
        directEntryUncontrolled = true;
      };
      expectedDiagnostic = "NS_DIRECT_ENTRY_UNCONTROLLED";
    };
  };

  evidenceTraceId = "FS-166-HDS-010-SDS-010-SMS-030";
  evidenceBase = {
    traceId = evidenceTraceId;
    sourceKind = "controlled-flow";
    claimedLayer = "construction";
    evidencePhase = "construction";
    skippedRepositories = [
      "network-compiler"
      "network-forwarding-model"
      "network-control-plane-model"
    ];
    normallyExecutedRepositories = [
      "network-realization-model"
      "network-realization-schema"
      "network-renderer-nixos"
    ];
    passedRepositories = [
      "network-realization-model"
      "network-realization-schema"
      "network-renderer-nixos"
    ];
    identities = {
      acknowledgementChainIdentity = "acknowledgement-chain";
      bindingIdentity = "platform-binding";
      bundleIdentity = "canonical-bundle";
      contextIdentity = "SMT-construction";
      rendererIdentity = "network-renderer-nixos";
      replacementIdentity = "replacement-artifact";
      rootLockIdentity = "root-lock";
      traceIdentity = evidenceTraceId;
    };
    runtimeContext = { };
    selectedEntrypoint = {
      canonical = true;
      path = "tests/${evidenceTraceId}.sh";
    };
    persistedEvidence = [
      {
        path = "source.identity";
        classification = "opaque-reference";
        redacted = false;
      }
    ];
  };

  mkEvidenceNegativeCase =
    {
      injection,
      manifest,
      expectedDiagnostic,
    }:
    {
      inherit injection expectedDiagnostic;
      expectedExit = 2;
      result = validateEvidenceManifest manifest;
      recovery = validateEvidenceManifest evidenceBase;
    };

  evidenceNegativeCases = {
    NS-EVID-N1 = mkEvidenceNegativeCase {
      injection = "mark skipped CPM as passed";
      manifest = evidenceBase // {
        passedRepositories = evidenceBase.passedRepositories ++ [ "network-control-plane-model" ];
      };
      expectedDiagnostic = "NS_SKIPPED_STAGE_CLAIMED_PASS";
    };
    NS-EVID-N2 = mkEvidenceNegativeCase {
      injection = "promote a direct renderer construction fixture to SIT";
      manifest = evidenceBase // {
        sourceKind = "direct-entry";
        claimedLayer = "SIT";
      };
      expectedDiagnostic = "NS_DIRECT_ENTRY_PROMOTED";
    };
    NS-EVID-N3 = mkEvidenceNegativeCase {
      injection = "remove the canonical bundle identity";
      manifest = evidenceBase // {
        identities = builtins.removeAttrs evidenceBase.identities [ "bundleIdentity" ];
      };
      expectedDiagnostic = "NS_EVIDENCE_IDENTITY_MISSING";
    };
    NS-EVID-N4 = mkEvidenceNegativeCase {
      injection = "claim compiler pass while artifact flow starts at NFM";
      manifest = evidenceBase // {
        skippedRepositories = [ ];
        passedRepositories = evidenceBase.passedRepositories ++ [ "network-compiler" ];
      };
      expectedDiagnostic = "NS_EVIDENCE_SCOPE_OVERRUN";
    };
    NS-EVID-N5 = mkEvidenceNegativeCase {
      injection = "claim live NixOS evidence without boot and active artifact identities";
      manifest = evidenceBase // {
        evidencePhase = "live";
        runtimeContext = {
          host = "s-router-nixos";
          observationIdentity = "observation";
        };
      };
      expectedDiagnostic = "NS_RUNTIME_CONTEXT_UNPROVEN";
    };
    NS-EVID-N6 = mkEvidenceNegativeCase {
      injection = "select a superseded direct-entry runner";
      manifest = evidenceBase // {
        selectedEntrypoint = {
          canonical = false;
          path = "tests/legacy-direct-cpm-renderer.sh";
        };
      };
      expectedDiagnostic = "NS_SUPERSEDED_ENTRYPOINT_SELECTED";
    };
    NS-EVID-N7 = mkEvidenceNegativeCase {
      injection = "persist an unredacted public address";
      manifest = evidenceBase // {
        persistedEvidence = [
          {
            path = "runtime.publicEndpoint";
            classification = "public-address";
            redacted = false;
          }
        ];
      };
      expectedDiagnostic = "NS_PUBLIC_ADDRESS_EXPOSED";
    };
    NS-EVID-N8 = mkEvidenceNegativeCase {
      injection = "persist an unredacted protected identity";
      manifest = evidenceBase // {
        persistedEvidence = [
          {
            path = "reservation.identity";
            classification = "protected";
            redacted = false;
          }
        ];
      };
      expectedDiagnostic = "NS_PROTECTED_VALUE_EXPOSED";
    };
  };

  rendererBoundaryTraceId = "FS-982-HDS-010-SDS-010-SMS-110";

  validateRendererBoundary =
    manifest:
    let
      traceId = manifest.traceId or "<missing-trace>";
      bindings = manifest.platformBindingBundles or [ ];
      binding = if bindings == [ ] then null else builtins.head bindings;
      expectedEntrypoint = "tests/${traceId}.sh";
    in
    if (manifest.inputKind or null) != "network-realization-bundle" then
      mkRejected {
        inherit traceId;
        code = "RV_RAW_CPM_INPUT";
        detail = "positive renderer input is not a validated canonical bundle";
      }
    else if
      (manifest.replacement.count or 0) != 1
      || (manifest.replacement.boundary or null) != (manifest.declaredFirstActiveBoundary or null)
    then
      mkRejected {
        inherit traceId;
        code = "RV_REPLACEMENT_BOUNDARY_INVALID";
        detail = "replacement must be delivered exactly once at the declared first active boundary";
      }
    else if
      !(manifest.realizationCompleted or false) || !(manifest.schemaValidationCompleted or false)
    then
      mkRejected {
        inherit traceId;
        code = "RV_REALIZATION_GATE_MISSING";
        detail = "realization and canonical schema validation must precede rendering";
      }
    else if
      builtins.length bindings > 1
      || (binding != null && (!(binding.validated or false) || (binding.semanticAuthority or false)))
    then
      mkRejected {
        inherit traceId;
        code = "RV_PLATFORM_BINDING_INVALID";
        detail = "platform mechanics must form zero or one validated non-semantic bundle";
      }
    else if manifest.peerRendererConsumed or false then
      mkRejected {
        inherit traceId;
        code = "RV_PEER_RENDERER_CONSUMED";
        detail = "peer renderer output cannot supply renderer input values";
      }
    else if !(manifest.provenanceComplete or false) then
      mkRejected {
        inherit traceId;
        code = "RV_CANONICAL_PROVENANCE_MISSING";
        detail = "every emitted field and assertion requires exact provenance";
      }
    else if
      (manifest.entrypoint.path or null) != expectedEntrypoint
      || !(manifest.entrypoint.canonical or false)
      || (manifest.entrypoint.rendererLocalWrapper or false)
    then
      mkRejected {
        inherit traceId;
        code = "RV_TRACE_ENTRYPOINT_INVALID";
        detail = "entrypoint must resolve to ${expectedEntrypoint} without a renderer-local wrapper";
      }
    else if (manifest.assertionCount or 0) < 1 then
      mkRejected {
        inherit traceId;
        code = "RV_ASSERTION_SET_EMPTY";
        detail = "the selected test has no behavioral assertion";
      }
    else
      mkAccepted traceId;

  rendererBoundaryBase = {
    traceId = rendererBoundaryTraceId;
    inputKind = "network-realization-bundle";
    declaredFirstActiveBoundary = "network-realization-model";
    replacement = {
      count = 1;
      boundary = "network-realization-model";
    };
    realizationCompleted = true;
    schemaValidationCompleted = true;
    platformBindingBundles = [
      {
        validated = true;
        semanticAuthority = false;
        identity = "normalized-platform-binding-bundle";
      }
    ];
    peerRendererConsumed = false;
    provenanceComplete = true;
    entrypoint = {
      canonical = true;
      path = "tests/${rendererBoundaryTraceId}.sh";
      rendererLocalWrapper = false;
    };
    assertionCount = 1;
  };

  mkRendererBoundaryNegativeCase =
    {
      injection,
      manifest,
      expectedDiagnostic,
    }:
    {
      inherit injection expectedDiagnostic;
      expectedExit = 2;
      result = validateRendererBoundary manifest;
      recovery = validateRendererBoundary rendererBoundaryBase;
    };

  rendererBoundaryNegativeCases = {
    RV-N1 = mkRendererBoundaryNegativeCase {
      injection = "supply raw CPM as positive renderer input";
      manifest = rendererBoundaryBase // {
        inputKind = "network-control-plane-artifact";
      };
      expectedDiagnostic = "RV_RAW_CPM_INPUT";
    };
    RV-N2 = mkRendererBoundaryNegativeCase {
      injection = "skip compiler but deliver replacement at CPM instead of NFM";
      manifest = rendererBoundaryBase // {
        declaredFirstActiveBoundary = "network-forwarding-model";
        replacement.boundary = "network-control-plane-model";
      };
      expectedDiagnostic = "RV_REPLACEMENT_BOUNDARY_INVALID";
    };
    RV-N3 = mkRendererBoundaryNegativeCase {
      injection = "pass replacement CPM directly to renderer";
      manifest = rendererBoundaryBase // {
        realizationCompleted = false;
        schemaValidationCompleted = false;
      };
      expectedDiagnostic = "RV_REALIZATION_GATE_MISSING";
    };
    RV-N4 = mkRendererBoundaryNegativeCase {
      injection = "supply independent interface and secret sidecars";
      manifest = rendererBoundaryBase // {
        platformBindingBundles = rendererBoundaryBase.platformBindingBundles ++ [
          {
            validated = true;
            semanticAuthority = false;
            identity = "second-sidecar";
          }
        ];
      };
      expectedDiagnostic = "RV_PLATFORM_BINDING_INVALID";
    };
    RV-N5 = mkRendererBoundaryNegativeCase {
      injection = "supply a missing field from a peer renderer";
      manifest = rendererBoundaryBase // {
        peerRendererConsumed = true;
      };
      expectedDiagnostic = "RV_PEER_RENDERER_CONSUMED";
    };
    RV-N6 = mkRendererBoundaryNegativeCase {
      injection = "delete provenance for one emitted field";
      manifest = rendererBoundaryBase // {
        provenanceComplete = false;
      };
      expectedDiagnostic = "RV_CANONICAL_PROVENANCE_MISSING";
    };
    RV-N7 = mkRendererBoundaryNegativeCase {
      injection = "select a descriptive renderer-local legacy wrapper";
      manifest = rendererBoundaryBase // {
        entrypoint = {
          canonical = false;
          path = "tests/${rendererBoundaryTraceId}-legacy.sh";
          rendererLocalWrapper = true;
        };
      };
      expectedDiagnostic = "RV_TRACE_ENTRYPOINT_INVALID";
    };
    RV-N8 = mkRendererBoundaryNegativeCase {
      injection = "replace the selected case with a presence-only script";
      manifest = rendererBoundaryBase // {
        assertionCount = 0;
      };
      expectedDiagnostic = "RV_ASSERTION_SET_EMPTY";
    };
  };

  seededNegativeCases =
    scenarioNegativeCases
    // flowNegativeCases
    // evidenceNegativeCases
    // rendererBoundaryNegativeCases;

  fs230TraceId = "FS-230-HDS-010-SDS-010-SMS-040";
  fs230Cpm = inputs.network-control-plane-model.libBySystem.${system}.compileAndBuildFromPaths {
    inputPath = ../GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/intent.nix;
    inventoryPath = ../GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-openconfig.nix;
  };
  fs230ControlPlaneModel = fs230Cpm.control_plane_model;
  fs230Replacement = {
    kind = "network-control-plane-artifact";
    artifactIdentity = builtins.hashString "sha256" (builtins.toJSON fs230ControlPlaneModel);
    control_plane_model = fs230ControlPlaneModel;
  };
  fs230Bundle = realization.realize {
    input = fs230Replacement;
    requestScope = {
      kind = "complete-artifact";
      identity = "FS-162-HDS-010-SDS-040-SMS-010";
    };
    inherit rootLockIdentity;
    producerRevision = inputs.network-realization-model.rev;
  };
  fs230Bindings = builtins.listToAttrs (
    map
      (target: {
        name = target;
        value = makePlatformBinding {
          traceId = "FS-162-HDS-010-SDS-040-SMS-010";
          inherit target;
          bundle = fs230Bundle;
        };
      })
      [
        "nixos"
        "clab"
        "openconfig"
      ]
  );
  fs230NixosInput = rendererDefinitions.nixos.validate {
    bundle = fs230Bundle;
    platformBinding = fs230Bindings.nixos;
  };
  fs230ClabInput = rendererDefinitions.clab.validate {
    bundle = fs230Bundle;
    platformBinding = fs230Bindings.clab;
  };
  fs230PeerComparison = builtins.deepSeq [ fs230NixosInput fs230ClabInput ] {
    traceId = "FS-162-HDS-010-SDS-040-SMS-010";
    sourceTraceId = fs230TraceId;
    bundle = fs230Bundle;
    bindings = fs230Bindings;
    bundleIdentity = fs230Bundle.bundleIdentity;
    compilerRevision = inputs.network-compiler.rev;
    cpmRevision = inputs.network-control-plane-model.rev;
    inherit networkLabsRevision;
    peerInputs = {
      nixos = fs230NixosInput.bundleIdentity;
      clab = fs230ClabInput.bundleIdentity;
      openconfig = fs230Bundle.bundleIdentity;
    };
    expectedPosture = {
      addressFamily = "ipv6";
      protocol = "udp";
      port = 4242;
      translationMode = "none";
      sourcePreservation = "preserve-source";
      returnBehavior = "stateful-return";
      inheritedPublicEgress = false;
    };
    openConfigModelComplete = false;
  };

  rendererBoundaryTargets = builtins.attrNames rendererDefinitions;
  rendererBoundaryBindings = builtins.listToAttrs (
    map (target: {
      name = target;
      value = makePlatformBinding {
        traceId = rendererBoundaryTraceId;
        inherit target;
        bundle = fs230Bundle;
      };
    }) rendererBoundaryTargets
  );
  rendererBoundaryInputs = builtins.mapAttrs (
    target: renderer:
    renderer.validate {
      bundle = fs230Bundle;
      platformBinding = rendererBoundaryBindings.${target};
    }
  ) rendererDefinitions;
  rendererBoundaryConformance = builtins.deepSeq (builtins.attrValues rendererBoundaryInputs) {
    traceId = rendererBoundaryTraceId;
    bundleIdentity = fs230Bundle.bundleIdentity;
    targets = rendererBoundaryTargets;
    inputBundleIdentities = builtins.mapAttrs (_: input: input.bundleIdentity) rendererBoundaryInputs;
    bindingIdentities = builtins.mapAttrs (
      _: binding: binding.bindingIdentity
    ) rendererBoundaryBindings;
    validation = validateRendererBoundary rendererBoundaryBase;
  };
in
{
  inherit
    evidenceNegativeCases
    flowBoundaryCases
    flowNegativeCases
    fs230PeerComparison
    rendererBoundaryConformance
    rendererBoundaryNegativeCases
    scenarioDefinitions
    seededNegativeCases
    validateEvidenceManifest
    validateFlowManifest
    validateRendererBoundary
    validateSourceArtifact
    validateScenarioManifest
    ;
  scenarios = builtins.mapAttrs makeScenario scenarioDefinitions;
}
