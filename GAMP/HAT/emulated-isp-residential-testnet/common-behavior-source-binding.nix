{ inventoryPath, profile }:

let
  traceId = "FS-770-HDS-010-SDS-020-SMS-010";
  behaviorSourcePath = "GAMP/HAT/emulated-isp-residential-testnet/intent.nix";
in
{
  inherit traceId;
  kind = "common-behavior-source-binding";
  commonBehaviorSource = {
    kind = "gamp-controlled-intent-source";
    profile = "emulated-isp-residential-testnet";
    path = behaviorSourcePath;
  };
  profileBinding = {
    inherit inventoryPath profile;
    behaviorSourcePath = behaviorSourcePath;
    bindingKind = "profile-inventory-to-common-behavior-source";
  };
  diagnostics = {
    splitBehaviorSource = "diagnostic.splitBehaviorSource";
    missingCommonSourceBinding = "diagnostic.missingCommonSourceBinding";
  };
  policyAuthority = {
    createsRouteAuthority = false;
    createsFirewallPolicy = false;
    createsDnsPolicy = false;
    createsPublicIngress = false;
    createsTenantReachability = false;
    createsTrustBoundary = false;
    createsNetworkBehavior = false;
  };
}
