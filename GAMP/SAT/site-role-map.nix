let
  intent = import ./intent.nix;
  fixtureTable = import ./public-ingress-fixture-table.nix;

  tenantSpacesFor = site:
    builtins.map
      (name: builtins.substring 7 ((builtins.stringLength name) - 7) name)
      (builtins.filter
        (name: builtins.match "tenant-.*" name != null)
        (builtins.attrNames site.communicationContract.interfaceTags));

  overlayRelationshipsFor = site:
    builtins.map
      (overlay: {
        name = overlay.name;
        peerSites = builtins.map
          (peer:
            let matched = builtins.match "esp\\.(.*)" peer;
            in "site-" + builtins.head matched)
          (overlay.peerSites or [ ]);
        terminateOn = overlay.terminateOn;
        underlayAccess = overlay.underlayAccess or null;
      })
      (site.transport.overlays or [ ]);
in
{
  site-nixos = {
    sourceSite = "esp.nixos";
    acceptanceRole = "home-server-network";
    supportedLabProfile = "nixos";
    upstreamOrProviderRoles = [ "isp-a" "isp-b" "east-west" ];
    publicIngressRole = {
      mode = "remote-public-target";
      ingressSite = "site-hetz";
      fixtureRefs = [
        "site-nixos-tcp-4444"
        "site-nixos-udp-4444"
      ];
    };
    interSiteRelationships = [ "site-clab" "site-hetz" ];
    overlayRelationships = overlayRelationshipsFor intent.esp.nixos;
    managementBoundary = {
      kind = "tenant";
      tenant = "mgmt";
      adminAllowRelation = "allow-admin-to-mgmt";
      deniedRelations = [ "deny-production-to-mgmt" ];
    };
    tenantOrAccessSpaces = tenantSpacesFor intent.esp.nixos;
  };

  site-hetz = {
    sourceSite = "esp.hetz";
    acceptanceRole = "hosted-edge-public-entry";
    supportedLabProfile = "hetzner";
    upstreamOrProviderRoles = [ "wan" "wg-host128-egress" "wg-routed64" "east-west" ];
    publicIngressRole = {
      mode = "public-entry-provider-edge";
      ingressSite = "site-hetz";
      fixtureRefs = [
        "site-nixos-tcp-4444"
        "site-nixos-udp-4444"
        "site-clab-tcp-4445"
        "site-clab-udp-4445"
        "site-hetz-tcp-4446"
        "site-hetz-udp-4446"
      ];
    };
    interSiteRelationships = [ "site-clab" "site-nixos" ];
    overlayRelationships = overlayRelationshipsFor intent.esp.hetz;
    managementBoundary = {
      kind = "external-harness";
      note = "No local mgmt tenant is modeled in esp.hetz; management remains outside the hosted edge tenant set.";
    };
    tenantOrAccessSpaces = tenantSpacesFor intent.esp.hetz;
  };

  site-clab = {
    sourceSite = "esp.clab";
    acceptanceRole = "containerlab-mirror";
    supportedLabProfile = "containerlab";
    upstreamOrProviderRoles = [ "wan" "east-west" ];
    publicIngressRole = {
      mode = "remote-public-target";
      ingressSite = "site-hetz";
      fixtureRefs = [
        "site-clab-tcp-4445"
        "site-clab-udp-4445"
      ];
    };
    interSiteRelationships = [ "site-hetz" "site-nixos" ];
    overlayRelationships = overlayRelationshipsFor intent.esp.clab;
    managementBoundary = {
      kind = "tenant";
      tenant = "mgmt";
      adminAllowRelation = "allow-admin-to-mgmt";
      deniedRelations = [ "deny-production-to-mgmt" ];
    };
    tenantOrAccessSpaces = tenantSpacesFor intent.esp.clab;
  };
}
