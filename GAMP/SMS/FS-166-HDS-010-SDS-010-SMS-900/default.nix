let
  platformBindingCategories = [
    "interfaceIdentity"
    "deployment"
    "secretDelivery"
    "lifecycle"
    "backend"
  ];

  mkSource =
    {
      traceId,
      rendererTarget,
      sourceReference,
      expectedTargetNames,
    }:
    {
      inherit
        traceId
        rendererTarget
        sourceReference
        expectedTargetNames
        ;
      kind = "replacement-cpm-artifact";
      replacementContract = "network-control-plane-artifact/v1";
      declaredFirstActiveBoundary = "network-realization-model";
      maxRuntimeTargets = builtins.length expectedTargetNames;
      platformBindingBundle = {
        normalized = true;
        categoryNames = platformBindingCategories;
      };
    };
in
{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-900";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Controlled replacement-CPM construction scenarios for canonical renderer input.";
  sourceInputs = {
    "FS-166-HDS-010-SDS-010-SMS-901" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-901";
      rendererTarget = "nixos";
      sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-901.sourceArtifact";
      expectedTargetNames = [ "poc-router" ];
    };

    "FS-166-HDS-010-SDS-010-SMS-902" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-902";
      rendererTarget = "nixos";
      sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-902.sourceArtifact";
      expectedTargetNames = [
        "edge-a"
        "edge-b"
      ];
    };

    "FS-166-HDS-010-SDS-010-SMS-903" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-903";
      rendererTarget = "access-endpoint-nixos";
      sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-903.sourceArtifact";
      expectedTargetNames = [ "poc-client" ];
    };

    "FS-166-HDS-010-SDS-010-SMS-904" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-904";
      rendererTarget = "clab";
      sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-904.sourceArtifact";
      expectedTargetNames = [
        "edge-a"
        "edge-b"
      ];
    };

    "FS-166-HDS-010-SDS-010-SMS-905" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-905";
      rendererTarget = "wireguard";
      sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-905.sourceArtifact";
      expectedTargetNames = [ "wireguard-egress" ];
    };

    "FS-166-HDS-010-SDS-010-SMS-906" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-906";
      rendererTarget = "nebula";
      sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-906.sourceArtifact";
      expectedTargetNames = [
        "lab-client-nebula"
        "lab-lighthouse"
      ];
    };
  };
}
