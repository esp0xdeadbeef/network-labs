{
  traceId = "FS-230-HDS-010-SDS-010-SMS-040";

  providerSurface = {
    name = "lab-wan";
    runtimeInterface = "wan0";
    sourceClass = "site-realization";
  };

  services = [
    {
      name = "nebula-lab";
      providerTenants = [ "lab-dmz" ];
      providerEndpoints = [
        {
          name = "nebula-lab-endpoint";
          # The endpoint address is inventory-owned. Its stable low 64 bits are
          # the IID combined with the protected runtime prefix by the renderer.
          ipv6 = [ "fd00:230::4242" ];
        }
      ];
    }
  ];

  routedPrefixesByTenant.lab-dmz = [
    {
      allocation = "runtime";
      family = "ipv6";
      name = "lab-dmz-public";
      source = "intent-routed-prefix";
      sourceClass = "protected";
      sourceFile = "/run/secrets/fs230-lab-dmz-ipv6-prefix";
      delegatedPrefixLength = 48;
      perTenantPrefixLength = 64;
      slot = 35;
    }
  ];
}
