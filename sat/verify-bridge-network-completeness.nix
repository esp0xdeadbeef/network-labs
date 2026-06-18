# Verification module: FS-710-HDS-010-SDS-010-SMS-010
# Site Role to Inventory Bridge Network Mapping
#
# Cross-references the FS-710 site role map's declared tenant/access spaces
# per modeled site against the inventory's per-host bridgeNetworks.
# Emits diagnostics for any declared space missing from the host's bridgeNetworks.

let
  # Map site-name (from site-role-map) to inventory host name.
  siteToHost = {
    site-nixos = "s-router-nixos";
    site-hetz = "s-router-hetz";
    site-clab = "s-router-clab";
  };

  # Check a single site's bridge network completeness.
  checkSite = roleMap: inventory: siteName:
    let
      record = roleMap.${siteName} or null;
      declaredSpaces = if record != null then record.tenantOrAccessSpaces or [ ] else null;
      hostName = siteToHost.${siteName} or null;
      host = if hostName != null then inventory.deployment.hosts.${hostName} or null else null;
      hostBridges = if host != null then builtins.attrNames (host.bridgeNetworks or { }) else null;
    in
      if record == null then
        { site = siteName; status = "site-not-in-role-map"; }
      else if hostName == null then
        { site = siteName; status = "no-host-mapping"; declaredSpaces = declaredSpaces; }
      else if host == null then
        { site = siteName; status = "host-not-in-inventory"; hostName = hostName; declaredSpaces = declaredSpaces; }
      else if declaredSpaces == [ ] then
        { site = siteName; status = "thin-host-valid"; hostName = hostName; note = "zero declared tenant/access spaces — empty bridgeNetworks is valid per URS L97 and FS-982"; }
      else if hostBridges == [ ] then
        { site = siteName; status = "incomplete"; hostName = hostName; declaredSpaces = declaredSpaces; missingSpaces = declaredSpaces; diagnostic = "all declared spaces missing — bridgeNetworks is empty"; }
      else
        let
          missing = builtins.filter (s: !(builtins.elem s hostBridges)) declaredSpaces;
        in
          if missing == [ ] then
            { site = siteName; status = "complete"; hostName = hostName; declaredSpaces = declaredSpaces; presentSpaces = declaredSpaces; }
          else
            { site = siteName; status = "incomplete"; hostName = hostName; declaredSpaces = declaredSpaces; missingSpaces = missing; presentSpaces = builtins.filter (s: builtins.elem s hostBridges) declaredSpaces; diagnostic = "missing bridge network(s) for declared tenant/access spaces"; };

  # Evaluate only sites present in the role map.
  checkAll = roleMap: inventory:
    let
      roleMapSites = builtins.attrNames roleMap;
      # Only check sites that exist in both roleMap and siteToHost.
      sites = builtins.filter (s: builtins.hasAttr s siteToHost) roleMapSites;
      results = builtins.map (checkSite roleMap inventory) sites;
      # Also flag roleMap sites that have no host mapping.
      unmappedSites = builtins.filter (s: !(builtins.hasAttr s siteToHost)) roleMapSites;
      unmappedResults = builtins.map (s: { site = s; status = "no-host-mapping"; }) unmappedSites;
      allResults = results ++ unmappedResults;
      failures = builtins.filter (r: r.status == "incomplete" || r.status == "host-not-in-inventory" || r.status == "no-host-mapping" || r.status == "site-not-in-role-map") allResults;
    in
      {
        results = allResults;
        allComplete = failures == [ ];
        inherit failures;
      };
in
  checkAll
