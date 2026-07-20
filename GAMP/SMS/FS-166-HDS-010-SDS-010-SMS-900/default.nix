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
      sourcePath,
      expectedTargetNames,
    }:
    {
      inherit
        traceId
        rendererTarget
        sourcePath
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
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/nixos-single.nix";
      expectedTargetNames = [ "poc-router" ];
    };

    "FS-166-HDS-010-SDS-010-SMS-902" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-902";
      rendererTarget = "nixos";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/nixos-p2p.nix";
      expectedTargetNames = [
        "edge-a"
        "edge-b"
      ];
    };

    "FS-166-HDS-010-SDS-010-SMS-903" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-903";
      rendererTarget = "access-endpoint-nixos";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/access-endpoint.nix";
      expectedTargetNames = [ "poc-client" ];
    };

    "FS-166-HDS-010-SDS-010-SMS-904" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-904";
      rendererTarget = "clab";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/clab-p2p.nix";
      expectedTargetNames = [
        "edge-a"
        "edge-b"
      ];
    };

    "FS-166-HDS-010-SDS-010-SMS-905" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-905";
      rendererTarget = "wireguard";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/wireguard.nix";
      expectedTargetNames = [ "wireguard-egress" ];
    };

    "FS-166-HDS-010-SDS-010-SMS-906" = mkSource {
      traceId = "FS-166-HDS-010-SDS-010-SMS-906";
      rendererTarget = "nebula";
      sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/nebula.nix";
      expectedTargetNames = [
        "lab-client-nebula"
        "lab-lighthouse"
      ];
    };
  };
}
