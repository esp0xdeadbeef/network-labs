{
  site-nixos-tcp-4444 = {
    site = "site-nixos";
    publicSurface = "hetz-wan";
    sourceScope = "internet";
    protocol = "tcp";
    publicPort = 4444;
    targetService = "nixos-hostile-4444";
    targetEndpoint = "nixos-hostile01";
    targetPort = 4444;
    translationBehavior = "provider-port-forward";
    translationMode = "napt";
    sourcePreservation = "rewritten";
    asymmetricRouting = false;
    returnPath = "hetz-east-west";
    deniedVariants = [
      "wrong-source-scope"
      "wrong-protocol"
      "wrong-port"
      "wrong-target"
      "missing-return-path"
    ];
    externalProviderRequired = true;
    localEmulationAllowed = false;
    policyRefs = [
      "allow-wan-to-nixos-hostile-4444"
      "allow-hetz-public-4444-to-nixos-hostile"
    ];
  };

  site-nixos-udp-4444 = {
    site = "site-nixos";
    publicSurface = "hetz-wan";
    sourceScope = "internet";
    protocol = "udp";
    publicPort = 4444;
    targetService = "nixos-hostile-4444";
    targetEndpoint = "nixos-hostile01";
    targetPort = 4444;
    translationBehavior = "provider-port-forward";
    translationMode = "napt";
    sourcePreservation = "rewritten";
    asymmetricRouting = false;
    returnPath = "hetz-east-west";
    deniedVariants = [
      "wrong-source-scope"
      "wrong-protocol"
      "wrong-port"
      "wrong-target"
      "missing-return-path"
    ];
    externalProviderRequired = true;
    localEmulationAllowed = false;
    policyRefs = [
      "allow-wan-to-nixos-hostile-4444"
      "allow-hetz-public-4444-to-nixos-hostile"
    ];
  };

  site-clab-tcp-4445 = {
    site = "site-clab";
    publicSurface = "hetz-wan";
    sourceScope = "internet";
    protocol = "tcp";
    publicPort = 4445;
    targetService = "clab-client-4445";
    targetEndpoint = "clab-client01";
    targetPort = 4445;
    translationBehavior = "provider-port-forward";
    translationMode = "napt";
    sourcePreservation = "rewritten";
    asymmetricRouting = false;
    returnPath = "hetz-east-west";
    deniedVariants = [
      "wrong-source-scope"
      "wrong-protocol"
      "wrong-port"
      "wrong-target"
      "missing-return-path"
    ];
    externalProviderRequired = true;
    localEmulationAllowed = false;
    policyRefs = [
      "allow-wan-to-clab-client-4445"
      "allow-hetz-public-4445-to-clab-client"
    ];
  };

  site-clab-udp-4445 = {
    site = "site-clab";
    publicSurface = "hetz-wan";
    sourceScope = "internet";
    protocol = "udp";
    publicPort = 4445;
    targetService = "clab-client-4445";
    targetEndpoint = "clab-client01";
    targetPort = 4445;
    translationBehavior = "provider-port-forward";
    translationMode = "napt";
    sourcePreservation = "rewritten";
    asymmetricRouting = false;
    returnPath = "hetz-east-west";
    deniedVariants = [
      "wrong-source-scope"
      "wrong-protocol"
      "wrong-port"
      "wrong-target"
      "missing-return-path"
    ];
    externalProviderRequired = true;
    localEmulationAllowed = false;
    policyRefs = [
      "allow-wan-to-clab-client-4445"
      "allow-hetz-public-4445-to-clab-client"
    ];
  };

  site-hetz-tcp-4446 = {
    site = "site-hetz";
    publicSurface = "hetz-wan";
    sourceScope = "internet";
    protocol = "tcp";
    publicPort = 4446;
    targetService = "hetz-client-4446";
    targetEndpoint = "hetz-client01";
    targetPort = 4446;
    translationBehavior = "provider-port-forward";
    translationMode = "napt";
    sourcePreservation = "rewritten";
    asymmetricRouting = false;
    returnPath = "hetz-local";
    deniedVariants = [
      "wrong-source-scope"
      "wrong-protocol"
      "wrong-port"
      "wrong-target"
      "missing-return-path"
    ];
    externalProviderRequired = true;
    localEmulationAllowed = false;
    policyRefs = [ "allow-wan-to-hetz-client-4446" ];
  };

  site-hetz-udp-4446 = {
    site = "site-hetz";
    publicSurface = "hetz-wan";
    sourceScope = "internet";
    protocol = "udp";
    publicPort = 4446;
    targetService = "hetz-client-4446";
    targetEndpoint = "hetz-client01";
    targetPort = 4446;
    translationBehavior = "provider-port-forward";
    translationMode = "napt";
    sourcePreservation = "rewritten";
    asymmetricRouting = false;
    returnPath = "hetz-local";
    deniedVariants = [
      "wrong-source-scope"
      "wrong-protocol"
      "wrong-port"
      "wrong-target"
      "missing-return-path"
    ];
    externalProviderRequired = true;
    localEmulationAllowed = false;
    policyRefs = [ "allow-wan-to-hetz-client-4446" ];
  };
}
