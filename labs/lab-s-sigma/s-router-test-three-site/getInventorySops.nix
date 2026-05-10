{
  runtimeFacts = {
    publicEndpoint = {
      ipv4Secret = "hetzner-public-ipv4";
      ipv6Secret = "hetzner-public-ipv6";
      lighthouseIpv4Secret = "hetzner-lighthouse-public-ipv4";
      nebulaCoreIpv4Secret = "hetzner-public-ipv4";
      macSecret = "hetzner-primary-interface-mac";
    };

    delegatedPrefixes = {
      branchHostile = "access-node-ipv6-prefix-espbranch-clab-b-router-access-hostile";
      hetzClient = "access-node-ipv6-prefix-esp0xdeadbeef-hetz-c-router-access-client";
    };

    overlayClients = {
      hetznerLighthouse = {
        addr4Secret = "nebula-hetzner-lighthouse-ipv4";
        addr6Secret = "nebula-hetzner-lighthouse-ipv6";
      };
    };

    prefixPostfixes = {
      hetzClientPublic = "hetz-client-public-prefix-postfix";
    };

    resolverForwarders = {
      publicDnsForwarders = [ "1.1.1.1" "9.9.9.9" "2606:4700:4700::1111" "2620:fe::fe" ];
    };
  };
}
