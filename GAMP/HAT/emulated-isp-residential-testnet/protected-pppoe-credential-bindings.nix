{
  consumerNode,
  harness,
  site,
}:
let
  secretPolicyNeutral = {
    createsRouteAuthority = false;
    createsFirewallPolicy = false;
    createsDnsPolicy = false;
    createsPublicIngress = false;
    createsTenantReachability = false;
    createsTrustBoundary = false;
    createsNetworkBehavior = false;
  };

  gampIds = [
    "FS-800-HDS-020-SDS-020"
    "FS-800-HDS-010-SDS-030-SMS-020"
  ];

  sourceFieldBase = "deployment.hosts.${harness}.hat.providerAccess.residentialPppoeHostTestnet.credentials";

  specs = [
    {
      id = "hat-secret-pppoe-${site}-username";
      credentialClass = "provider-credential";
      tenant = null;
      consumer = {
        kind = "service";
        node = consumerNode;
        name = "pppoe.client";
      };
      purpose = "pppoe-username";
      sourceName = "hat-pppoe-username";
      runtimePath = "hat-pppoe-username";
      sourceFieldPath = "${sourceFieldBase}.usernameFile";
    }
    {
      id = "hat-secret-pppoe-${site}-password";
      credentialClass = "provider-credential";
      tenant = null;
      consumer = {
        kind = "service";
        node = consumerNode;
        name = "pppoe.client";
      };
      purpose = "pppoe-password";
      sourceName = "hat-pppoe-password";
      runtimePath = "hat-pppoe-password";
      sourceFieldPath = "${sourceFieldBase}.passwordFile";
    }
  ];

  specsWithCommonFields = map (spec: spec // {
    inherit site;
    host = harness;
    lifecycle = "hat-runtime";
    required = true;
    sourceClass = "deployment-platform-secret-reference";
  }) specs;
in
{
  secretDeclarations = map (spec: {
    inherit (spec) id credentialClass site tenant host consumer purpose lifecycle;
    required = spec.required;
    requiredness = "mandatory";
    material = "reference-only";
    plaintextMaterial = false;
    sourceSelected = false;
    policyAuthority = secretPolicyNeutral;
    inherit gampIds;
  }) specsWithCommonFields;

  secretSources = map (spec: {
    id = "${spec.id}-source";
    declarationId = spec.id;
    sourceClass = spec.sourceClass;
    reference = {
      name = spec.sourceName;
      runtimePath = spec.runtimePath;
      sourceFieldPath = spec.sourceFieldPath;
    };
    lifecycle = spec.lifecycle;
    materialAccess = "not-supplied-by-source-record";
    plaintextMaterial = false;
    providerNeutral = true;
    fixedSecretManagerRequired = false;
    inherit gampIds;
  }) specsWithCommonFields;

  sourceBindings = map (spec: {
    id = "${spec.id}-binding";
    declarationId = spec.id;
    sourceId = "${spec.id}-source";
    sourceClass = spec.sourceClass;
    bindingKind = "declaration-source";
    sourceFieldPath = spec.sourceFieldPath;
    policyAuthority = secretPolicyNeutral;
    inherit gampIds;
  }) specsWithCommonFields;
}
