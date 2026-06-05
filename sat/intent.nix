# SAT-SRC-INTENT-001: URS-190 / URS-190-FS-010. This is the controlled
# s-router SAT intent source. Examples under network-labs/examples are
# lower-layer fixtures only and are not SAT source evidence by themselves.
{
  esp = {
    # SAT-SRC-INTENT-NIXOS-SITE: s-router SAT behavior source for the NixOS
    # site; intent owns behavior and inventory owns realization.
    nixos = {
      # SAT-SRC-PROFILE-MANIFEST-NIXOS: FS-650..FS-690 source/profile
      # manifest evidence. This is source data only; inventory and renderers
      # still own concrete host, interface, VLAN, secret, and runtime facts.
      profileManifest = {
        sourceClass = "intent-profile-manifest";
        profileIdentity = {
          profileId = "esp.nixos";
          deploymentType = "residential-home-server";
          sitePurpose = "default segmented NixOS home/server site";
          inferredFromRealization = false;
        };
        surfaces = {
          provider = [ "isp-a" "isp-b" ];
          management = {
            scope = "mgmt";
            source = "tenant-access-policy";
          };
          overlayOrInterSite = [ "east-west" ];
          publicIngressCapability = {
            enabled = true;
            services = [ "nixos-hostile-4444" "dmz-nebula" ];
          };
          realizationFieldsExcluded = [ "host" "interface" "vlan" "secret" "runtimeBinding" ];
        };
        scopeManifest = {
          tenants = [ "mgmt" "admin" "client" "dmz" "streaming" "hostile" ];
          services = [ "site-dns-mgmt" "dmz-nebula" "nixos-hostile-4444" "cast-control" "cast-discovery" ];
          accessSpaces = [ "mgmt" "admin" "client" "dmz" "streaming" "hostile" ];
          explicitOmissions = [ ];
          renames = [ ];
          mergedBaselineScopes = [ ];
        };
        internetProviderProfile = {
          defaultInternetMode = "dual-uplink-private-egress";
          providers = [ "isp-a" "isp-b" ];
          roleColocation = [ ];
        };
        accessSpaces = {
          mgmt = {
            attachment = { method = "tenant-access"; sourceNode = "nixos-router-access-mgmt"; };
            clientIdentityRules = [ "managed-infrastructure-client" ];
            addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.20.10.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:beef:10::/64"; };
            resolverAdvertisement = "router-self";
            localServiceDiscovery = "disabled";
            clientIsolation = "management-only";
            onboarding = "controlled-admin";
            revocation = "remove-managed-client";
          };
          admin = {
            attachment = { method = "tenant-access"; sourceNode = "nixos-router-access-admin"; };
            clientIdentityRules = [ "admin-client" ];
            addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.20.15.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:beef:15::/64"; };
            resolverAdvertisement = "router-self";
            localServiceDiscovery = "disabled";
            clientIsolation = "deny-production-to-management-except-admin-policy";
            onboarding = "controlled-admin";
            revocation = "remove-admin-client";
          };
          client = {
            attachment = { method = "tenant-access"; sourceNode = "nixos-router-access-client"; };
            clientIdentityRules = [ "normal-user-client" ];
            addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.20.20.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:beef:20::/64"; };
            resolverAdvertisement = "router-self";
            localServiceDiscovery = "cast-requester";
            clientIsolation = "no-management-lateral";
            onboarding = "normal-client";
            revocation = "remove-client";
          };
          dmz = {
            attachment = { method = "tenant-access"; sourceNode = "nixos-router-access-dmz"; };
            clientIdentityRules = [ "service-host" ];
            addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.20.30.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:beef:30::/64"; };
            resolverAdvertisement = "router-self";
            localServiceDiscovery = "disabled";
            clientIsolation = "public-service-only";
            onboarding = "controlled-service";
            revocation = "remove-service-host";
          };
          streaming = {
            attachment = { method = "tenant-access"; sourceNode = "nixos-router-access-streaming"; };
            clientIdentityRules = [ "media-device" ];
            addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.20.50.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:beef:50::/64"; };
            resolverAdvertisement = "router-self";
            localServiceDiscovery = "cast-responder";
            clientIsolation = "no-reverse-client-initiation";
            onboarding = "controlled-device";
            revocation = "remove-media-device";
          };
          hostile = {
            attachment = { method = "tenant-access"; sourceNode = "nixos-router-access-hostile"; };
            clientIdentityRules = [ "hostile-test-client" ];
            addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.20.70.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:beef:70::/64"; };
            resolverAdvertisement = "router-self";
            localServiceDiscovery = "disabled";
            clientIsolation = "deny-local-production-and-uplink";
            onboarding = "test-client";
            revocation = "remove-test-client";
          };
        };
        tenantAccessMatrix = [
          { scope = "mgmt"; purpose = "infrastructure-management"; clientClasses = [ "managed-infrastructure-client" ]; internetMode = "resolver-mediated"; resolver = "site-dns-mgmt"; discoveryExports = [ ]; allowedServices = [ "site-dns-mgmt" ]; deniedLateralPaths = [ "production-to-mgmt" ]; managementExcluded = false; negativeProbes = [ "production-to-mgmt" ]; operatorName = "Management"; }
          { scope = "admin"; purpose = "administrative-client"; clientClasses = [ "admin-client" ]; internetMode = "dual-uplink"; resolver = "site-dns-mgmt"; discoveryExports = [ ]; allowedServices = [ "site-dns-mgmt" ]; deniedLateralPaths = [ ]; managementExcluded = false; negativeProbes = [ "direct-public-dns" ]; operatorName = "Admin"; }
          { scope = "client"; purpose = "normal-client"; clientClasses = [ "user-client" ]; internetMode = "dual-uplink"; resolver = "site-dns-mgmt"; discoveryExports = [ "cast-discovery" ]; allowedServices = [ "site-dns-mgmt" "cast-discovery" "cast-control" ]; deniedLateralPaths = [ "client-to-mgmt" ]; managementExcluded = true; negativeProbes = [ "client-to-mgmt" "direct-public-dns" ]; operatorName = "Client"; }
          { scope = "dmz"; purpose = "public-service"; clientClasses = [ "service-host" ]; internetMode = "dual-uplink"; resolver = "site-dns-mgmt"; discoveryExports = [ ]; allowedServices = [ "site-dns-mgmt" "dmz-nebula" ]; deniedLateralPaths = [ "dmz-to-mgmt" ]; managementExcluded = true; negativeProbes = [ "dmz-to-mgmt" "direct-public-dns" ]; operatorName = "DMZ"; }
          { scope = "streaming"; purpose = "media-device"; clientClasses = [ "media-device" ]; internetMode = "dual-uplink"; resolver = "site-dns-mgmt"; discoveryExports = [ "cast-discovery" ]; allowedServices = [ "site-dns-mgmt" "cast-discovery" "cast-control" ]; deniedLateralPaths = [ "streaming-to-client" "streaming-to-mgmt" ]; managementExcluded = true; negativeProbes = [ "streaming-to-client" "streaming-to-mgmt" "direct-public-dns" ]; operatorName = "Streaming"; }
          { scope = "hostile"; purpose = "hostile-overlay-egress-test"; clientClasses = [ "hostile-test-client" ]; internetMode = "east-west-only"; resolver = "none-local"; discoveryExports = [ ]; allowedServices = [ "nixos-hostile-4444" ]; deniedLateralPaths = [ "hostile-to-local-tenants" "hostile-to-local-uplinks" ]; managementExcluded = true; negativeProbes = [ "hostile-to-local-tenants" "hostile-to-local-uplinks" ]; operatorName = "Hostile"; }
        ];
        sharedServiceMatrix = [
          { requesterScopes = [ "admin" "client" "streaming" "dmz" ]; responderScope = "mgmt"; serviceClass = "dns"; service = "site-dns-mgmt"; discovery = { protocol = "none"; direction = "not-discovered"; }; payload = { protocol = "dns"; ports = [ 53 ]; direction = "requester-to-responder"; returnBehavior = "stateful-return"; }; exposure = "site-local"; authenticationBoundary = "resolver-policy"; cloudDependency = "none"; deniedByDesign = [ "direct-public-dns" ]; managementBoundary = "not-management-authority"; }
          { requesterScopes = [ "client" ]; responderScope = "streaming"; serviceClass = "media-receiver"; service = "cast-discovery"; discovery = { protocol = "mdns-ssdp"; direction = "client-to-streaming"; }; payload = { protocol = "udp"; ports = [ 5353 1900 ]; direction = "requester-to-responder"; returnBehavior = "discovery-response-only"; }; exposure = "site-local"; authenticationBoundary = "device-pairing"; cloudDependency = "none"; deniedByDesign = [ "streaming-reverse-initiation" ]; managementBoundary = "no-administration"; }
          { requesterScopes = [ "client" ]; responderScope = "streaming"; serviceClass = "media-control"; service = "cast-control"; discovery = { protocol = "none"; direction = "not-discovered"; }; payload = { protocol = "tcp"; ports = [ 8008 8009 ]; direction = "client-to-streaming"; returnBehavior = "stateful-return"; }; exposure = "site-local"; authenticationBoundary = "device-pairing"; cloudDependency = "none"; deniedByDesign = [ "streaming-reverse-initiation" ]; managementBoundary = "no-administration"; }
          { requesterScopes = [ "external-wan" ]; responderScope = "dmz"; serviceClass = "overlay-control"; service = "dmz-nebula"; discovery = { protocol = "none"; direction = "public-entry"; }; payload = { protocol = "nebula"; ports = [ 4242 ]; direction = "wan-to-dmz"; returnBehavior = "stateful-return"; }; exposure = "public-ingress"; authenticationBoundary = "overlay-keys"; cloudDependency = "none"; deniedByDesign = [ "payload-policy-bypass" ]; managementBoundary = "no-administration"; }
          { requesterScopes = [ "external-east-west" ]; responderScope = "hostile"; serviceClass = "public-test-entry"; service = "nixos-hostile-4444"; discovery = { protocol = "none"; direction = "public-entry"; }; payload = { protocol = "tcp-udp"; ports = [ 4444 ]; direction = "external-to-hostile"; returnBehavior = "stateful-return"; }; exposure = "public-ingress"; authenticationBoundary = "service-local"; cloudDependency = "none"; deniedByDesign = [ "hostile-to-local-tenants" ]; managementBoundary = "no-administration"; }
        ];
        operatorSupportViewSource = {
          modeledSources = [ "profileIdentity" "surfaces" "scopeManifest" "accessSpaces" "tenantAccessMatrix" "sharedServiceMatrix" "communicationContract" "ownership" "transport" ];
          inventorySources = [ "inventory.nix" ];
          runtimeSources = [ "runtime fact summaries only when supplied" ];
          fields = [ "sites" "scopes" "accessSpaces" "attachmentPoints" "localNames" "sharedServices" "internetPaths" "dnsPaths" "managementPaths" "publicIngressPaths" "deniedPaths" "troubleshootingChecks" ];
          createsAuthority = false;
        };
      };
      # SAT-SRC-INTENT-NIXOS-COMMS: SAT behavior coverage for DNS policy,
      # public exposure, internet policy, hostile overlay egress, and leak
      # prevention for esp.nixos.
      communicationContract = {
        interfaceTags = {
          external-east-west = "east-west";
          external-isp-a = "isp-a";
          external-isp-b = "isp-b";
          service-dmz-nebula = "dmz-nebula";
          service-nixos-hostile-4444 = "nixos-hostile-4444";
          service-site-dns-mgmt = "site-dns-mgmt";
          service-cast-control = "cast-control";
          service-cast-discovery = "cast-discovery";
          tenant-admin = "admin";
          tenant-client = "client";
          tenant-dmz = "dmz";
          tenant-hostile = "hostile";
          tenant-mgmt = "mgmt";
          tenant-streaming = "streaming";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            id = "allow-site-wan-icmp-anywhere";
            priority = 6;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-site-overlay-icmp-anywhere";
            priority = 7;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "admin" ];
            };
            id = "allow-admin-to-mgmt";
            priority = 10;
            to = {
              kind = "tenant-set";
              members = [ "mgmt" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [
                "client"
                "streaming"
                "dmz"
                "hostile"
              ];
            };
            id = "deny-production-to-mgmt";
            priority = 11;
            to = {
              kind = "tenant-set";
              members = [ "mgmt" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "streaming" ];
            };
            id = "deny-streaming-to-client";
            priority = 12;
            to = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "deny-hostile-to-local-tenants";
            priority = 13;
            to = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            id = "allow-tenants-to-site-dns";
            priority = 9;
            to = {
              kind = "service";
              name = "site-dns-mgmt";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "service";
              name = "site-dns-mgmt";
            };
            id = "allow-site-dns-service-to-uplinks";
            priority = 24;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            id = "deny-tenant-dns-to-uplinks";
            priority = 25;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "deny-hostile-to-local-uplinks";
            priority = 26;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-client-to-cast-discovery";
            priority = 30;
            to = {
              kind = "service";
              name = "cast-discovery";
            };
            trafficType = "cast-discovery";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-client-to-cast-control";
            priority = 31;
            to = {
              kind = "service";
              name = "cast-control";
            };
            trafficType = "cast-control";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "allow-hostile-egress-to-hetz-overlay";
            priority = 32;
            to = {
              kind = "external";
              name = "east-west";
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
              ];
            };
            id = "allow-user-tenants-to-uplinks";
            priority = 100;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-hetz-public-4444-to-nixos-hostile";
            priority = 121;
            to = {
              kind = "service";
              name = "nixos-hostile-4444";
            };
            trafficType = "tcp-udp-4444";
            publicIngressTupleAuthority = {
              sourceScope = "internet";
              publicSurface = "hetz-wan";
              targetService = "nixos-hostile-4444";
              targetEndpoint = "nixos-hostile01";
              targetPort = 4444;
              returnBehavior = "stateful-return";
              sourcePreservation = "provider-napt";
              translationMode = "provider-port-forward";
              hairpin = "not-modeled";
              asymmetricRouting = "not-allowed";
              tuples = [
                {
                  protocol = "tcp";
                  publicPort = 4444;
                }
                {
                  protocol = "udp";
                  publicPort = 4444;
                }
              ];
            };
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-east-west-to-site-dns";
            priority = 115;
            to = {
              kind = "service";
              name = "site-dns-mgmt";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            id = "allow-wan-to-dmz-nebula";
            priority = 120;
            to = {
              kind = "service";
              name = "dmz-nebula";
            };
            trafficType = "nebula";
            publicIngressTupleAuthority = {
              sourceScope = "internet";
              publicSurface = "wan";
              targetService = "dmz-nebula";
              targetEndpoint = "nebula01";
              targetPort = 4242;
              returnBehavior = "stateful-return";
              sourcePreservation = "preserve-source";
              translationMode = "none";
              hairpin = "not-modeled";
              asymmetricRouting = "not-allowed";
              tuples = [
                {
                  protocol = "udp";
                  publicPort = 4242;
                }
                {
                  protocol = "tcp";
                  publicPort = 4242;
                }
              ];
            };
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-nebula-underlay-to-uplinks";
            priority = 130;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "nebula";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-nebula-runtime-underlay-to-uplinks";
            priority = 131;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "nebula-runtime";
          }
        ];
        services = [
          {
            name = "site-dns-mgmt";
            providers = [ "site-dns-mgmt" ];
            trafficType = "dns";
          }
          {
            name = "dmz-nebula";
            providers = [ "nebula01" ];
            trafficType = "nebula";
          }
          {
            name = "nixos-hostile-4444";
            providers = [ "nixos-hostile01" ];
            trafficType = "tcp-udp-4444";
          }
          {
            name = "cast-control";
            providers = [ "streaming01" ];
            trafficType = "cast-control";
          }
          {
            name = "cast-discovery";
            providers = [ "streaming01" ];
            trafficType = "cast-discovery";
          }
        ];
        trafficTypes = [
          {
            match = [
              {
                family = "any";
                proto = "icmp";
              }
            ];
            name = "icmp";
          }
          {
            match = [
              {
                dports = [ 53 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 53 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "dns";
          }
          {
            match = [
              {
                dports = [ 4444 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4444 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "tcp-udp-4444";
          }
          {
            match = [
              {
                dports = [ 4242 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 4242 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "nebula";
          }
          {
            match = [
              {
                dports = [ 443 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "nebula-runtime";
          }
          {
            match = [
              {
                dports = [
                  8008
                  8009
                ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "cast-control";
          }
          {
            match = [
              {
                dports = [ 5353 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 1900 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "cast-discovery";
          }
        ];
      };
      # SAT-SRC-INTENT-NIXOS-OWNERSHIP: SAT behavior coverage for tenants,
      # services, endpoint ownership, routed prefixes, and client/public
      # address authority for esp.nixos.
      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "nebula01";
            tenant = "dmz";
          }
          {
            kind = "host";
            name = "nixos-hostile01";
            tenant = "hostile";
          }
          {
            kind = "host";
            name = "site-dns-mgmt";
            tenant = "mgmt";
          }
          {
            kind = "host";
            name = "streaming01";
            tenant = "streaming";
          }
        ];
        prefixes = [
          {
            ipv4 = "10.20.10.0/24";
            ipv6 = "fd42:dead:beef:10::/64";
            kind = "tenant";
            name = "mgmt";
          }
          {
            ipv4 = "10.20.15.0/24";
            ipv6 = "fd42:dead:beef:15::/64";
            kind = "tenant";
            name = "admin";
          }
          {
            ipv4 = "10.20.20.0/24";
            ipv6 = "fd42:dead:beef:20::/64";
            kind = "tenant";
            name = "client";
          }
          {
            ipv4 = "10.20.30.0/24";
            ipv6 = "fd42:dead:beef:30::/64";
            kind = "tenant";
            name = "dmz";
          }
          {
            ipv4 = "10.20.50.0/24";
            ipv6 = "fd42:dead:beef:50::/64";
            kind = "tenant";
            name = "streaming";
          }
          {
            ipv4 = "10.20.70.0/24";
            ipv6 = "fd42:dead:beef:70::/64";
            kind = "tenant";
            name = "hostile";
            routedPrefixes = [
              {
                allocation = "runtime";
                family = "ipv6";
                name = "nixos-hostile-public";
                prefixPostfix = "4444";
                delegatedPrefixLength = 64;
                perTenantPrefixLength = 64;
                slot = 0;
                sourceFile = "/run/secrets/access-node-ipv6-prefix-esp-nixos-router-access-hostile";
              }
            ];
          }
        ];
      };
      pools = {
        overlay = {
          ipv4 = {
            offsetStart = 10;
            perNodePrefixLength = 32;
            prefix = "100.96.10.0/24";
          };
          ipv6 = {
            offsetStart = 10;
            perNodePrefixLength = 128;
            prefix = "fd42:dead:beef:ee::/64";
          };
        };
        loopback = {
          ipv4 = "10.19.0.0/24";
          ipv6 = "fd42:dead:beef:1900::/118";
        };
        p2p = {
          ipv4 = "10.10.0.0/24";
          ipv6 = "fd42:dead:beef:1000::/118";
        };
      };
      topology = {
        links = [
          [
            "nixos-router-core-isp-a"
            "nixos-router-upstream"
          ]
          [
            "nixos-router-core-isp-b"
            "nixos-router-upstream"
          ]
          [
            "nixos-router-core-nebula"
            "nixos-router-upstream"
          ]
          [
            "nixos-router-upstream"
            "nixos-router-policy"
          ]
          [
            "nixos-router-policy"
            "nixos-router-downstream"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-admin"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-client"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-dmz"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-hostile"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-mgmt"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-streaming"
          ]
        ];
        nodes = {
          nixos-router-access-admin = {
            attachments = [
              {
                kind = "tenant";
                name = "admin";
              }
            ];
            role = "access";
          };
          nixos-router-access-client = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          nixos-router-access-dmz = {
            attachments = [
              {
                kind = "tenant";
                name = "dmz";
              }
            ];
            role = "access";
          };
          nixos-router-access-mgmt = {
            attachments = [
              {
                kind = "tenant";
                name = "mgmt";
              }
            ];
            role = "access";
          };
          nixos-router-access-hostile = {
            attachments = [
              {
                kind = "tenant";
                name = "hostile";
              }
            ];
            role = "access";
          };
          nixos-router-access-streaming = {
            attachments = [
              {
                kind = "tenant";
                name = "streaming";
              }
            ];
            role = "access";
          };
          nixos-router-core-isp-a = {
            role = "core";
            uplinks = {
              isp-a = {
                egress.ipv6.translation = {
                  mode = "nat66";
                  warning = "NAT66 is intentionally modeled only for explicit simulated or otherwise non-routed IPv6 uplinks; routed public-prefix tenants must stay routed, not masqueraded.";
                };
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          nixos-router-core-isp-b = {
            role = "core";
            uplinks = {
              isp-b = {
                egress.ipv6.translation = {
                  mode = "nat66";
                  warning = "NAT66 is intentionally modeled only for explicit simulated or otherwise non-routed IPv6 uplinks; routed public-prefix tenants must stay routed, not masqueraded.";
                };
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          nixos-router-core-nebula = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "core";
            uplinks = {
              east-west = {
                ipv4 = [
                  "10.50.10.0/24"
                  "10.50.15.0/24"
                  "10.50.20.0/24"
                  "10.50.30.0/24"
                  "10.50.50.0/24"
                  "10.70.10.0/24"
                  "10.90.10.0/24"
                  "0.0.0.0/0"
                ];
                ipv6 = [
                  "fd42:dead:feed:10::/64"
                  "fd42:dead:feed:15::/64"
                  "fd42:dead:feed:20::/64"
                  "fd42:dead:feed:30::/64"
                  "fd42:dead:feed:50::/64"
                  "fd42:dead:feed:70::/64"
                  "fd42:dead:cafe:10::/64"
                  "::/0"
                ];
              };
            };
          };
          nixos-router-downstream = {
            role = "downstream-selector";
          };
          nixos-router-policy = {
            role = "policy";
          };
          nixos-router-upstream = {
            role = "upstream-selector";
          };
        };
      };
      # SAT-SRC-INTENT-NIXOS-TRANSPORT: SAT behavior coverage for overlay
      # membership, underlay access selection, and modeled hostile path
      # traversal for esp.nixos.
      transport = {
        overlays = [
          {
            mustTraverse = [ "policy" ];
            name = "east-west";
            peerSites = [
              "esp.clab"
              "esp.hetz"
            ];
            terminateOn = "nixos-router-core-nebula";
            underlayAccess = {
              kind = "tenant";
              name = "client";
            };
            underlayTrafficTypes = [
              "nebula"
              "nebula-runtime"
            ];
          }
        ];
      };
    };
    # SAT-SRC-INTENT-HETZ-SITE: s-router SAT behavior source for the hosted
    # edge site; this site carries the provider/public-edge behavior.
    hetz = {
      # SAT-SRC-PROFILE-MANIFEST-HETZ: FS-650..FS-690 source/profile
      # manifest evidence for the hosted edge profile.
      profileManifest = {
        sourceClass = "intent-profile-manifest";
        profileIdentity = {
          profileId = "esp.hetz";
          deploymentType = "hosted-edge";
          sitePurpose = "hosted public edge, overlay lighthouse, and provider scenario site";
          inferredFromRealization = false;
        };
        surfaces = {
          provider = [ "wan" "wg-host128-egress" "wg-routed64" ];
          management = { scope = "dmz"; source = "controlled-hosted-edge-policy"; };
          overlayOrInterSite = [ "east-west" "wg-host128-egress" "wg-routed64" ];
          publicIngressCapability = {
            enabled = true;
            services = [ "nixos-hostile-4444" "clab-client-4445" "hetz-client-4446" "wireguard-host128" "wireguard-routed64" "dmz-nebula" ];
          };
          realizationFieldsExcluded = [ "host" "interface" "vlan" "secret" "runtimeBinding" ];
        };
        scopeManifest = {
          tenants = [ "dmz" "client" ];
          services = [ "hetz-dns-dmz" "dmz-nebula" "nixos-hostile-4444" "clab-client-4445" "hetz-client-4446" "wireguard-host128" "wireguard-routed64" "hostile-public-dns" ];
          accessSpaces = [ "dmz" "client" ];
          explicitOmissions = [ "mgmt" "admin" "streaming" "hostile" ];
          renames = [ ];
          mergedBaselineScopes = [ ];
        };
        internetProviderProfile = {
          defaultInternetMode = "hosted-wan-plus-provider-overlays";
          providers = [ "wan" "wg-host128-egress" "wg-routed64" ];
          roleColocation = [ { roles = [ "provider-edge" "public-ingress" ]; node = "hetz-router-core"; reason = "hosted edge profile"; } ];
        };
        accessSpaces = {
          dmz = {
            attachment = { method = "tenant-access"; sourceNode = "hetz-router-access-dmz"; };
            clientIdentityRules = [ "hosted-service" ];
            addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.90.10.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:cafe:10::/64"; };
            resolverAdvertisement = "hetz-dns-dmz";
            localServiceDiscovery = "disabled";
            clientIsolation = "public-edge-service-only";
            onboarding = "controlled-hosted-service";
            revocation = "remove-hosted-service";
          };
          client = {
            attachment = { method = "tenant-access"; sourceNode = "hetz-router-access-client"; };
            clientIdentityRules = [ "hosted-client" ];
            addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.90.20.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:cafe:20::/64"; };
            resolverAdvertisement = "hetz-dns-dmz";
            localServiceDiscovery = "disabled";
            clientIsolation = "public-ingress-target-only";
            onboarding = "controlled-hosted-client";
            revocation = "remove-hosted-client";
          };
        };
        tenantAccessMatrix = [
          { scope = "dmz"; purpose = "hosted-edge-services"; clientClasses = [ "hosted-service" ]; internetMode = "wan-and-east-west"; resolver = "hetz-dns-dmz"; discoveryExports = [ ]; allowedServices = [ "hetz-dns-dmz" "dmz-nebula" "wireguard-host128" "wireguard-routed64" ]; deniedLateralPaths = [ "dmz-to-management" ]; managementExcluded = true; negativeProbes = [ "direct-public-dns" "dmz-to-management" ]; operatorName = "Hetz DMZ"; }
          { scope = "client"; purpose = "hosted-client-public-target"; clientClasses = [ "hosted-client" ]; internetMode = "wan-and-provider-overlays"; resolver = "hetz-dns-dmz"; discoveryExports = [ ]; allowedServices = [ "hetz-dns-dmz" "hetz-client-4446" ]; deniedLateralPaths = [ "client-to-management" ]; managementExcluded = true; negativeProbes = [ "direct-public-dns" "client-to-management" ]; operatorName = "Hetz Client"; }
        ];
        sharedServiceMatrix = [
          { requesterScopes = [ "client" ]; responderScope = "dmz"; serviceClass = "dns"; service = "hetz-dns-dmz"; discovery = { protocol = "none"; direction = "not-discovered"; }; payload = { protocol = "dns"; ports = [ 53 ]; direction = "requester-to-responder"; returnBehavior = "stateful-return"; }; exposure = "site-local"; authenticationBoundary = "resolver-policy"; cloudDependency = "none"; deniedByDesign = [ "direct-public-dns" ]; managementBoundary = "not-management-authority"; }
          { requesterScopes = [ "external-wan" "external-east-west" ]; responderScope = "dmz"; serviceClass = "overlay-control"; service = "dmz-nebula"; discovery = { protocol = "none"; direction = "public-entry"; }; payload = { protocol = "nebula"; ports = [ 4242 ]; direction = "external-to-dmz"; returnBehavior = "stateful-return"; }; exposure = "public-ingress"; authenticationBoundary = "overlay-keys"; cloudDependency = "none"; deniedByDesign = [ "payload-policy-bypass" ]; managementBoundary = "no-administration"; }
          { requesterScopes = [ "external-wan" ]; responderScope = "client"; serviceClass = "public-test-entry"; service = "hetz-client-4446"; discovery = { protocol = "none"; direction = "public-entry"; }; payload = { protocol = "tcp-udp"; ports = [ 4446 ]; direction = "external-to-client"; returnBehavior = "stateful-return"; }; exposure = "public-ingress"; authenticationBoundary = "service-local"; cloudDependency = "none"; deniedByDesign = [ "client-management-access" ]; managementBoundary = "no-administration"; }
          { requesterScopes = [ "external-wan" ]; responderScope = "client"; serviceClass = "wireguard-provider"; service = "wireguard-host128"; discovery = { protocol = "none"; direction = "provider-entry"; }; payload = { protocol = "udp"; ports = [ 51820 ]; direction = "wan-to-provider"; returnBehavior = "stateful-return"; }; exposure = "provider-control"; authenticationBoundary = "wireguard-keys"; cloudDependency = "none"; deniedByDesign = [ "downstream-gua-export" ]; managementBoundary = "no-administration"; }
          { requesterScopes = [ "external-wan" ]; responderScope = "client"; serviceClass = "wireguard-provider"; service = "wireguard-routed64"; discovery = { protocol = "none"; direction = "provider-entry"; }; payload = { protocol = "udp"; ports = [ 51821 ]; direction = "wan-to-provider"; returnBehavior = "stateful-return"; }; exposure = "provider-control"; authenticationBoundary = "wireguard-keys"; cloudDependency = "none"; deniedByDesign = [ "nat66-for-routed-gua" ]; managementBoundary = "no-administration"; }
        ];
        operatorSupportViewSource = {
          modeledSources = [ "profileIdentity" "surfaces" "scopeManifest" "accessSpaces" "tenantAccessMatrix" "sharedServiceMatrix" "communicationContract" "ownership" "transport" ];
          inventorySources = [ "inventory.nix" ];
          runtimeSources = [ "runtime fact summaries only when supplied" ];
          fields = [ "sites" "scopes" "accessSpaces" "attachmentPoints" "localNames" "sharedServices" "internetPaths" "dnsPaths" "managementPaths" "publicIngressPaths" "deniedPaths" "troubleshootingChecks" ];
          createsAuthority = false;
        };
      };
      # SAT-SRC-INTENT-HETZ-COMMS: SAT behavior coverage for hosted DNS,
      # public ingress, east-west return paths, internet policy, and leak
      # prevention for esp.hetz.
      communicationContract = {
        interfaceTags = {
          external-east-west = "east-west";
          external-wan = "wan";
          external-wireguard-128-egress = "wg-host128-egress";
          external-wireguard-64-routed = "wg-routed64";
          service-clab-client-4445 = "clab-client-4445";
          service-dmz-nebula = "dmz-nebula";
          service-hetz-dns-dmz = "hetz-dns-dmz";
          service-hetz-client-4446 = "hetz-client-4446";
          service-nixos-hostile-4444 = "nixos-hostile-4444";
          service-wireguard-host128 = "wireguard-host128";
          service-wireguard-routed64 = "wireguard-routed64";
          tenant-client = "client";
          tenant-dmz = "dmz";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-hetz-wan-icmp-anywhere";
            priority = 6;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-hetz-overlay-icmp-anywhere";
            priority = 7;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-hetz-client-to-dmz-dns";
            priority = 20;
            to = {
              kind = "service";
              name = "hetz-dns-dmz";
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "deny-hetz-client-dns-to-wan";
            priority = 25;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-hetz-client-to-wan";
            priority = 100;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-wan-to-wireguard-host128";
            priority = 104;
            to = {
              kind = "service";
              name = "wireguard-host128";
            };
            trafficType = "wireguard-host128";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-wan-to-wireguard-routed64";
            priority = 105;
            to = {
              kind = "service";
              name = "wireguard-routed64";
            };
            trafficType = "wireguard-routed64";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "wg-host128-egress";
            };
            id = "allow-wireguard-host128-provider-control-to-wan";
            priority = 106;
            to = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            trafficType = "wireguard-host128";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "wg-host128-egress";
            };
            id = "allow-wireguard-host128-provider-egress-to-wan";
            priority = 107;
            to = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "wg-routed64";
            };
            id = "allow-wireguard-routed64-public-ingress-to-hetz-client";
            priority = 108;
            to = {
              kind = "service";
              name = "hetz-client-4446";
            };
            trafficType = "tcp-udp-4446";
          }
          {
            action = "allow";
            from = {
              kind = "service";
              name = "hetz-dns-dmz";
            };
            id = "allow-hetz-dns-service-to-east-west";
            priority = 109;
            to = {
              kind = "external";
              name = "east-west";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "service";
              name = "hetz-dns-dmz";
            };
            id = "allow-hetz-dns-service-to-wan";
            priority = 110;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-hostile-overlay-egress-to-wan";
            priority = 120;
            to = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-wan-to-dmz-nebula";
            priority = 125;
            to = {
              kind = "service";
              name = "dmz-nebula";
            };
            trafficType = "nebula";
            publicIngressTupleAuthority = {
              sourceScope = "internet";
              publicSurface = "hetz-wan";
              targetService = "dmz-nebula";
              targetEndpoint = "hetz-router-lighthouse";
              targetPort = 4242;
              returnBehavior = "stateful-return";
              sourcePreservation = "preserve-source";
              translationMode = "none";
              hairpin = "not-modeled";
              asymmetricRouting = "not-allowed";
              tuples = [
                {
                  protocol = "udp";
                  publicPort = 4242;
                }
                {
                  protocol = "tcp";
                  publicPort = 4242;
                }
              ];
            };
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-east-west-underlay-to-dmz-nebula";
            priority = 126;
            to = {
              kind = "service";
              name = "dmz-nebula";
            };
            trafficType = "nebula";
            publicIngressTupleAuthority = {
              sourceScope = "internet";
              publicSurface = "hetz-wan";
              targetService = "dmz-nebula";
              targetEndpoint = "hetz-router-lighthouse";
              targetPort = 4242;
              returnBehavior = "stateful-return";
              sourcePreservation = "preserve-source";
              translationMode = "none";
              hairpin = "not-modeled";
              asymmetricRouting = "not-allowed";
              tuples = [
                {
                  protocol = "udp";
                  publicPort = 4242;
                }
                {
                  protocol = "tcp";
                  publicPort = 4242;
                }
              ];
            };
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-wan-to-nixos-hostile-4444";
            priority = 130;
            to = {
              kind = "service";
              name = "nixos-hostile-4444";
            };
            trafficType = "tcp-udp-4444";
            publicIngressTupleAuthority = {
              sourceScope = "internet";
              publicSurface = "hetz-wan";
              targetService = "nixos-hostile-4444";
              targetEndpoint = "nixos-hostile01";
              targetPort = 4444;
              returnBehavior = "stateful-return";
              sourcePreservation = "provider-napt";
              translationMode = "provider-port-forward";
              hairpin = "not-modeled";
              asymmetricRouting = "not-allowed";
              tuples = [
                {
                  protocol = "tcp";
                  publicPort = 4444;
                }
                {
                  protocol = "udp";
                  publicPort = 4444;
                }
              ];
            };
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-wan-to-clab-client-4445";
            priority = 131;
            to = {
              kind = "service";
              name = "clab-client-4445";
            };
            trafficType = "tcp-udp-4445";
            publicIngressTupleAuthority = {
              sourceScope = "internet";
              publicSurface = "hetz-wan";
              targetService = "clab-client-4445";
              targetEndpoint = "clab-client01";
              targetPort = 4445;
              returnBehavior = "stateful-return";
              sourcePreservation = "provider-napt";
              translationMode = "provider-port-forward";
              hairpin = "not-modeled";
              asymmetricRouting = "not-allowed";
              tuples = [
                {
                  protocol = "tcp";
                  publicPort = 4445;
                }
                {
                  protocol = "udp";
                  publicPort = 4445;
                }
              ];
            };
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-wan-to-hetz-client-4446";
            priority = 132;
            to = {
              kind = "service";
              name = "hetz-client-4446";
            };
            trafficType = "tcp-udp-4446";
            publicIngressTupleAuthority = {
              sourceScope = "internet";
              publicSurface = "hetz-wan";
              targetService = "hetz-client-4446";
              targetEndpoint = "hetz-client01";
              targetPort = 4446;
              returnBehavior = "stateful-return";
              sourcePreservation = "provider-napt";
              translationMode = "provider-port-forward";
              hairpin = "not-modeled";
              asymmetricRouting = "not-allowed";
              tuples = [
                {
                  protocol = "tcp";
                  publicPort = 4446;
                }
                {
                  protocol = "udp";
                  publicPort = 4446;
                }
              ];
            };
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-overlay-to-hostile-public-dns";
            priority = 133;
            to = {
              kind = "service";
              name = "hostile-public-dns";
            };
            trafficType = "dns";
          }
        ];
        services = [
          {
            name = "hetz-dns-dmz";
            providers = [ "hetz-dns-dmz" ];
            trafficType = "dns";
          }
          {
            name = "dmz-nebula";
            providers = [ "hetz-router-lighthouse" ];
            trafficType = "nebula";
          }
          {
            name = "nixos-hostile-4444";
            providers = [ "nixos-hostile01" ];
            trafficType = "tcp-udp-4444";
          }
          {
            name = "clab-client-4445";
            providers = [ "clab-client01" ];
            trafficType = "tcp-udp-4445";
          }
          {
            name = "hetz-client-4446";
            providers = [ "hetz-client01" ];
            trafficType = "tcp-udp-4446";
          }
          {
            name = "wireguard-host128";
            providers = [ "hetz-router-core" ];
            trafficType = "wireguard-host128";
          }
          {
            name = "wireguard-routed64";
            providers = [ "hetz-router-core" ];
            trafficType = "wireguard-routed64";
          }
          {
            name = "hostile-public-dns";
            providers = [ "hetz-dns-dmz" ];
            trafficType = "dns";
          }
        ];
        trafficTypes = [
          {
            match = [
              {
                family = "any";
                proto = "icmp";
              }
            ];
            name = "icmp";
          }
          {
            match = [
              {
                dports = [ 53 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 53 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "dns";
          }
          {
            match = [
              {
                dports = [ 4242 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 4242 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "nebula";
          }
          {
            match = [
              {
                dports = [ 51820 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "wireguard-host128";
          }
          {
            match = [
              {
                dports = [ 51821 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "wireguard-routed64";
          }
          {
            match = [
              {
                dports = [ 4444 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4444 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "tcp-udp-4444";
          }
          {
            match = [
              {
                dports = [ 4445 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4445 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "tcp-udp-4445";
          }
          {
            match = [
              {
                dports = [ 4446 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4446 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "tcp-udp-4446";
          }
        ];
      };
      # SAT-SRC-INTENT-HETZ-OWNERSHIP: SAT behavior coverage for hosted edge
      # tenants, services, public-entry targets, routed prefixes, and provider
      # edge address authority for esp.hetz.
      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "hetz-dns-dmz";
            tenant = "dmz";
          }
          {
            kind = "host";
            name = "hetz-router-lighthouse";
            tenant = "dmz";
          }
          {
            kind = "host";
            name = "hetz-client01";
            tenant = "client";
          }
        ];
        prefixes = [
          {
            ipv4 = "10.90.10.0/24";
            ipv6 = "fd42:dead:cafe:10::/64";
            kind = "tenant";
            name = "dmz";
          }
          {
            ipv4 = "10.90.20.0/24";
            ipv6 = "fd42:dead:cafe:20::/64";
            kind = "tenant";
            name = "client";
            routedPrefixes = [
              {
                allocation = "runtime";
                family = "ipv6";
                name = "hetz-client-public";
                prefixPostfix = "4446";
                delegatedPrefixLength = 64;
                perTenantPrefixLength = 64;
                slot = 0;
                sourceFile = "/run/secrets/access-node-ipv6-prefix-esp-hetz-router-access-client";
              }
            ];
          }
        ];
      };
      pools = {
        overlay = {
          ipv4 = {
            offsetStart = 10;
            perNodePrefixLength = 32;
            prefix = "100.96.10.0/24";
          };
          ipv6 = {
            offsetStart = 10;
            perNodePrefixLength = 128;
            prefix = "fd42:dead:beef:ee::/64";
          };
        };
        loopback = {
          ipv4 = "10.89.0.0/24";
          ipv6 = "fd42:dead:cafe:1900::/118";
        };
        p2p = {
          ipv4 = "10.80.0.0/24";
          ipv6 = "fd42:dead:cafe:1000::/118";
        };
      };
      overlayAddressPools = {
        east-west = {
          ipv4 = {
            offsetStart = 10;
            perNodePrefixLength = 32;
            prefix = "100.96.10.0/24";
          };
          ipv6 = {
            offsetStart = 10;
            perNodePrefixLength = 128;
            prefix = "fd42:dead:beef:ee::/64";
          };
        };
        wg-host128-egress = {
          ipv4 = {
            offsetStart = 2;
            perNodePrefixLength = 32;
            prefix = "10.66.128.0/24";
          };
          ipv6 = {
            offsetStart = 2;
            perNodePrefixLength = 128;
            prefix = "2001:db8:128::/64";
          };
        };
        wg-routed64 = {
          ipv4 = {
            offsetStart = 2;
            perNodePrefixLength = 32;
            prefix = "10.66.64.0/24";
          };
          ipv6 = {
            offsetStart = 2;
            perNodePrefixLength = 128;
            prefix = "2001:db8:64::/64";
          };
        };
      };
      topology = {
        hostNatIngress = {
          enabled = true;
          targetNode = "hetz-router-core";
          uplink = "wan";
          hostReservedPorts = [
            {
              dports = [ 22 ];
              name = "ssh";
              proto = "tcp";
            }
          ];
        };
        links = [
          [
            "hetz-router-core"
            "hetz-router-upstream"
          ]
          [
            "hetz-router-nebula-core"
            "hetz-router-upstream"
          ]
          [
            "hetz-router-upstream"
            "hetz-router-policy"
          ]
          [
            "hetz-router-policy"
            "hetz-router-downstream"
          ]
          [
            "hetz-router-downstream"
            "hetz-router-access-dmz"
          ]
          [
            "hetz-router-downstream"
            "hetz-router-access-client"
          ]
        ];
        nodes = {
          hetz-router-access-client = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          hetz-router-access-dmz = {
            attachments = [
              {
                kind = "tenant";
                name = "dmz";
              }
            ];
            role = "access";
          };
          hetz-router-core = {
            role = "core";
            uplinks = {
              wan = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          hetz-router-downstream = {
            role = "downstream-selector";
          };
          hetz-router-nebula-core = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "core";
            uplinks = {
              east-west = {
                ipv4 = [
                  "10.20.70.0/24"
                  "10.50.20.0/24"
                  "10.50.70.0/24"
                  "10.70.10.0/24"
                ];
                ipv6 = [
                  "fd42:dead:beef:70::/64"
                  "fd42:dead:feed:20::/64"
                  "fd42:dead:feed:70::/64"
                  "fd42:dead:feed:7000::/56"
                ];
              };
              wg-host128-egress = {
                ipv4 = [ "10.66.128.2/32" ];
                ipv6 = [ "2001:db8:128::2/128" ];
              };
              wg-routed64 = {
                ipv4 = [ "10.66.64.2/32" ];
                ipv6 = [ "2001:db8:64::2/128" ];
              };
            };
          };
          hetz-router-policy = {
            role = "policy";
          };
          hetz-router-upstream = {
            role = "upstream-selector";
          };
        };
      };
      # SAT-SRC-INTENT-HETZ-TRANSPORT: SAT behavior coverage for hosted edge
      # overlay membership, lighthouse placement, and east-west transport for
      # esp.hetz.
      transport = {
        overlays = [
          {
            mustTraverse = [ "policy" ];
            name = "east-west";
            peerSites = [
              "esp.nixos"
              "esp.clab"
            ];
            terminateOn = "hetz-router-nebula-core";
            underlayAccess = {
              kind = "tenant";
              name = "client";
            };
            underlayTrafficTypes = [ "nebula" ];
          }
          # SAT-SRC-INTENT-WIREGUARD-PROVIDER-SCENARIOS: Hetz carries the
          # controlled WireGuard provider SAT behavior surfaces. Inventory
          # realizes the profile files, interface names, NAT, prefix authority,
          # public ingress, and route-return facts for each scenario. The /128
          # and /64 providers are separate daemon surfaces.
          {
            mustTraverse = [ "policy" ];
            name = "wg-host128-egress";
            peerSites = [ ];
            terminateOn = "hetz-router-nebula-core";
            underlayAccess = {
              kind = "tenant";
              name = "client";
            };
            underlayTrafficTypes = [ "wireguard-host128" ];
          }
          {
            mustTraverse = [ "policy" ];
            name = "wg-routed64";
            peerSites = [ ];
            terminateOn = "hetz-router-nebula-core";
            underlayAccess = {
              kind = "tenant";
              name = "client";
            };
            underlayTrafficTypes = [ "wireguard-routed64" ];
          }
        ];
      };
    };
    # SAT-SRC-INTENT-CLAB-SITE: s-router SAT behavior source for the
    # Containerlab mirror site and hostile client egress validation tenant.
    clab = {
      # SAT-SRC-PROFILE-MANIFEST-CLAB: FS-650..FS-690 source/profile
      # manifest evidence for the Containerlab mirror profile.
      profileManifest = {
        sourceClass = "intent-profile-manifest";
        profileIdentity = {
          profileId = "esp.clab";
          deploymentType = "containerlab-mirror";
          sitePurpose = "CLAB mirror for segmentation, hostile egress, and client public-service checks";
          inferredFromRealization = false;
        };
        surfaces = {
          provider = [ "wan" ];
          management = { scope = "mgmt"; source = "tenant-access-policy"; };
          overlayOrInterSite = [ "east-west" ];
          publicIngressCapability = {
            enabled = true;
            services = [ "clab-client-4445" ];
          };
          realizationFieldsExcluded = [ "host" "interface" "vlan" "secret" "runtimeBinding" ];
        };
        scopeManifest = {
          tenants = [ "mgmt" "admin" "client" "dmz" "streaming" "hostile" ];
          services = [ "clab-site-dns" "clab-client-4445" "cast-control" "cast-discovery" ];
          accessSpaces = [ "mgmt" "admin" "client" "dmz" "streaming" "hostile" ];
          explicitOmissions = [ ];
          renames = [ ];
          mergedBaselineScopes = [ ];
        };
        internetProviderProfile = {
          defaultInternetMode = "simulated-wan-plus-east-west-hostile-egress";
          providers = [ "wan" "east-west" ];
          roleColocation = [ ];
        };
        accessSpaces = {
          mgmt = { attachment = { method = "tenant-access"; sourceNode = "clab-router-access-mgmt"; }; clientIdentityRules = [ "managed-infrastructure-client" ]; addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.50.10.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:feed:10::/64"; }; resolverAdvertisement = "router-self"; localServiceDiscovery = "disabled"; clientIsolation = "management-only"; onboarding = "controlled-admin"; revocation = "remove-managed-client"; };
          admin = { attachment = { method = "tenant-access"; sourceNode = "clab-router-access-admin"; }; clientIdentityRules = [ "admin-client" ]; addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.50.15.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:feed:15::/64"; }; resolverAdvertisement = "router-self"; localServiceDiscovery = "disabled"; clientIsolation = "deny-production-to-management-except-admin-policy"; onboarding = "controlled-admin"; revocation = "remove-admin-client"; };
          client = { attachment = { method = "tenant-access"; sourceNode = "clab-router-access-client"; }; clientIdentityRules = [ "normal-user-client" ]; addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.50.20.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:feed:20::/64"; }; resolverAdvertisement = "router-self"; localServiceDiscovery = "cast-requester"; clientIsolation = "no-management-lateral"; onboarding = "normal-client"; revocation = "remove-client"; };
          dmz = { attachment = { method = "tenant-access"; sourceNode = "clab-router-access-dmz"; }; clientIdentityRules = [ "service-host" ]; addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.50.30.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:feed:30::/64"; }; resolverAdvertisement = "router-self"; localServiceDiscovery = "disabled"; clientIsolation = "public-service-only"; onboarding = "controlled-service"; revocation = "remove-service-host"; };
          streaming = { attachment = { method = "tenant-access"; sourceNode = "clab-router-access-streaming"; }; clientIdentityRules = [ "media-device" ]; addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.50.50.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:feed:50::/64"; }; resolverAdvertisement = "router-self"; localServiceDiscovery = "cast-responder"; clientIsolation = "no-reverse-client-initiation"; onboarding = "controlled-device"; revocation = "remove-media-device"; };
          hostile = { attachment = { method = "tenant-access"; sourceNode = "clab-router-access-hostile"; }; clientIdentityRules = [ "hostile-test-client" ]; addressAssignment = { ipv4.mode = "dhcp"; ipv4.servedPrefix = "10.70.10.0/24"; ipv6.mode = "dhcpv6-or-ra"; ipv6.servedPrefix = "fd42:dead:feed:70::/64"; }; resolverAdvertisement = "router-self"; localServiceDiscovery = "disabled"; clientIsolation = "deny-local-production-and-uplink"; onboarding = "test-client"; revocation = "remove-test-client"; };
        };
        tenantAccessMatrix = [
          { scope = "mgmt"; purpose = "infrastructure-management"; clientClasses = [ "managed-infrastructure-client" ]; internetMode = "resolver-mediated"; resolver = "clab-site-dns"; discoveryExports = [ ]; allowedServices = [ "clab-site-dns" ]; deniedLateralPaths = [ "production-to-mgmt" ]; managementExcluded = false; negativeProbes = [ "production-to-mgmt" ]; operatorName = "CLAB Management"; }
          { scope = "admin"; purpose = "administrative-client"; clientClasses = [ "admin-client" ]; internetMode = "wan"; resolver = "clab-site-dns"; discoveryExports = [ ]; allowedServices = [ "clab-site-dns" ]; deniedLateralPaths = [ ]; managementExcluded = false; negativeProbes = [ "direct-public-dns" ]; operatorName = "CLAB Admin"; }
          { scope = "client"; purpose = "normal-client-public-target"; clientClasses = [ "user-client" ]; internetMode = "wan"; resolver = "clab-site-dns"; discoveryExports = [ "cast-discovery" ]; allowedServices = [ "clab-site-dns" "cast-discovery" "cast-control" "clab-client-4445" ]; deniedLateralPaths = [ "client-to-mgmt" ]; managementExcluded = true; negativeProbes = [ "client-to-mgmt" "direct-public-dns" ]; operatorName = "CLAB Client"; }
          { scope = "dmz"; purpose = "service-zone"; clientClasses = [ "service-host" ]; internetMode = "wan"; resolver = "clab-site-dns"; discoveryExports = [ ]; allowedServices = [ "clab-site-dns" ]; deniedLateralPaths = [ "dmz-to-mgmt" ]; managementExcluded = true; negativeProbes = [ "dmz-to-mgmt" "direct-public-dns" ]; operatorName = "CLAB DMZ"; }
          { scope = "streaming"; purpose = "media-device"; clientClasses = [ "media-device" ]; internetMode = "wan"; resolver = "clab-site-dns"; discoveryExports = [ "cast-discovery" ]; allowedServices = [ "clab-site-dns" "cast-discovery" "cast-control" ]; deniedLateralPaths = [ "streaming-to-client" "streaming-to-mgmt" ]; managementExcluded = true; negativeProbes = [ "streaming-to-client" "streaming-to-mgmt" "direct-public-dns" ]; operatorName = "CLAB Streaming"; }
          { scope = "hostile"; purpose = "hostile-overlay-egress-test"; clientClasses = [ "hostile-test-client" ]; internetMode = "east-west-only"; resolver = "hostile-public-dns"; discoveryExports = [ ]; allowedServices = [ ]; deniedLateralPaths = [ "hostile-to-local-tenants" "hostile-to-local-wan" ]; managementExcluded = true; negativeProbes = [ "hostile-to-local-tenants" "hostile-to-local-wan" ]; operatorName = "CLAB Hostile"; }
        ];
        sharedServiceMatrix = [
          { requesterScopes = [ "admin" "client" "streaming" "dmz" ]; responderScope = "mgmt"; serviceClass = "dns"; service = "clab-site-dns"; discovery = { protocol = "none"; direction = "not-discovered"; }; payload = { protocol = "dns"; ports = [ 53 ]; direction = "requester-to-responder"; returnBehavior = "stateful-return"; }; exposure = "site-local"; authenticationBoundary = "resolver-policy"; cloudDependency = "none"; deniedByDesign = [ "direct-public-dns" ]; managementBoundary = "not-management-authority"; }
          { requesterScopes = [ "client" ]; responderScope = "streaming"; serviceClass = "media-receiver"; service = "cast-discovery"; discovery = { protocol = "mdns-ssdp"; direction = "client-to-streaming"; }; payload = { protocol = "udp"; ports = [ 5353 1900 ]; direction = "requester-to-responder"; returnBehavior = "discovery-response-only"; }; exposure = "site-local"; authenticationBoundary = "device-pairing"; cloudDependency = "none"; deniedByDesign = [ "streaming-reverse-initiation" ]; managementBoundary = "no-administration"; }
          { requesterScopes = [ "client" ]; responderScope = "streaming"; serviceClass = "media-control"; service = "cast-control"; discovery = { protocol = "none"; direction = "not-discovered"; }; payload = { protocol = "tcp"; ports = [ 8008 8009 ]; direction = "client-to-streaming"; returnBehavior = "stateful-return"; }; exposure = "site-local"; authenticationBoundary = "device-pairing"; cloudDependency = "none"; deniedByDesign = [ "streaming-reverse-initiation" ]; managementBoundary = "no-administration"; }
          { requesterScopes = [ "external-east-west" ]; responderScope = "client"; serviceClass = "public-test-entry"; service = "clab-client-4445"; discovery = { protocol = "none"; direction = "public-entry"; }; payload = { protocol = "tcp-udp"; ports = [ 4445 ]; direction = "external-to-client"; returnBehavior = "stateful-return"; }; exposure = "public-ingress"; authenticationBoundary = "service-local"; cloudDependency = "none"; deniedByDesign = [ "client-management-access" ]; managementBoundary = "no-administration"; }
        ];
        operatorSupportViewSource = {
          modeledSources = [ "profileIdentity" "surfaces" "scopeManifest" "accessSpaces" "tenantAccessMatrix" "sharedServiceMatrix" "communicationContract" "ownership" "transport" ];
          inventorySources = [ "inventory.nix" ];
          runtimeSources = [ "runtime fact summaries only when supplied" ];
          fields = [ "sites" "scopes" "accessSpaces" "attachmentPoints" "localNames" "sharedServices" "internetPaths" "dnsPaths" "managementPaths" "publicIngressPaths" "deniedPaths" "troubleshootingChecks" ];
          createsAuthority = false;
        };
      };
      # SAT-SRC-INTENT-CLAB-COMMS: SAT behavior coverage for CLAB DNS,
      # hostile overlay egress, normal client public service exposure, internet
      # policy, and leak prevention for esp.clab.
      communicationContract = {
        interfaceTags = {
          external-east-west = "east-west";
          external-wan = "wan";
          service-clab-site-dns = "clab-site-dns";
          service-clab-client-4445 = "clab-client-4445";
          service-cast-control = "cast-control";
          service-cast-discovery = "cast-discovery";
          tenant-admin = "admin";
          tenant-client = "client";
          tenant-dmz = "dmz";
          tenant-hostile = "hostile";
          tenant-mgmt = "mgmt";
          tenant-streaming = "streaming";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "external";
              name = "wan";
            };
            id = "allow-clab-wan-icmp-anywhere";
            priority = 6;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-clab-overlay-icmp-anywhere";
            priority = 7;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "admin" ];
            };
            id = "allow-admin-to-mgmt";
            priority = 10;
            to = {
              kind = "tenant-set";
              members = [ "mgmt" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [
                "client"
                "streaming"
                "dmz"
                "hostile"
              ];
            };
            id = "deny-production-to-mgmt";
            priority = 11;
            to = {
              kind = "tenant-set";
              members = [ "mgmt" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "streaming" ];
            };
            id = "deny-streaming-to-client";
            priority = 12;
            to = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "deny-hostile-to-local-tenants";
            priority = 13;
            to = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            id = "allow-normal-tenants-to-clab-dns";
            priority = 9;
            to = {
              kind = "service";
              name = "clab-site-dns";
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            id = "deny-normal-tenant-dns-to-wan";
            priority = 25;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "service";
              name = "clab-site-dns";
            };
            id = "allow-clab-site-dns-service-to-wan";
            priority = 24;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-client-to-cast-discovery";
            priority = 30;
            to = {
              kind = "service";
              name = "cast-discovery";
            };
            trafficType = "cast-discovery";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-client-to-cast-control";
            priority = 31;
            to = {
              kind = "service";
              name = "cast-control";
            };
            trafficType = "cast-control";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
              ];
            };
            id = "allow-normal-tenants-to-wan";
            priority = 100;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "deny-hostile-to-local-wan";
            priority = 101;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "allow-hostile-dns-to-hetz-public-dns";
            priority = 110;
            to = {
              kind = "external";
              name = "east-west";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "allow-hostile-egress-to-hetz-overlay";
            priority = 111;
            to = {
              kind = "external";
              name = "east-west";
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-hetz-public-4445-to-clab-client";
            priority = 120;
            to = {
              kind = "service";
              name = "clab-client-4445";
            };
            trafficType = "tcp-udp-4445";
            publicIngressTupleAuthority = {
              sourceScope = "internet";
              publicSurface = "hetz-wan";
              targetService = "clab-client-4445";
              targetEndpoint = "clab-client01";
              targetPort = 4445;
              returnBehavior = "stateful-return";
              sourcePreservation = "provider-napt";
              translationMode = "provider-port-forward";
              hairpin = "not-modeled";
              asymmetricRouting = "not-allowed";
              tuples = [
                {
                  protocol = "tcp";
                  publicPort = 4445;
                }
                {
                  protocol = "udp";
                  publicPort = 4445;
                }
              ];
            };
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-nebula-underlay-to-wan";
            priority = 130;
            to = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            trafficType = "nebula";
          }
        ];
        services = [
          {
            name = "clab-site-dns";
            providers = [ "clab-site-dns" ];
            trafficType = "dns";
          }
          {
            name = "clab-client-4445";
            providers = [ "clab-client01" ];
            trafficType = "tcp-udp-4445";
          }
          {
            name = "cast-control";
            providers = [ "clab-streaming01" ];
            trafficType = "cast-control";
          }
          {
            name = "cast-discovery";
            providers = [ "clab-streaming01" ];
            trafficType = "cast-discovery";
          }
        ];
        trafficTypes = [
          {
            match = [
              {
                family = "any";
                proto = "icmp";
              }
            ];
            name = "icmp";
          }
          {
            match = [
              {
                dports = [ 53 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 53 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "dns";
          }
          {
            match = [
              {
                dports = [ 4242 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4242 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "nebula";
          }
          {
            match = [
              {
                dports = [ 4445 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4445 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "tcp-udp-4445";
          }
          {
            match = [
              {
                dports = [
                  8008
                  8009
                ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "cast-control";
          }
          {
            match = [
              {
                dports = [ 5353 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 1900 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "cast-discovery";
          }
        ];
      };
      # SAT-SRC-INTENT-CLAB-OWNERSHIP: SAT behavior coverage for CLAB tenants,
      # services, endpoint ownership, routed prefixes, and hostile/client
      # address authority for esp.clab.
      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "clab-site-dns";
            tenant = "mgmt";
          }
          {
            kind = "host";
            name = "clab-client01";
            tenant = "client";
          }
          {
            kind = "host";
            name = "clab-client02";
            tenant = "client";
          }
          {
            kind = "host";
            name = "clab-streaming01";
            tenant = "streaming";
          }
          {
            kind = "host";
            name = "hostile-node01";
            tenant = "hostile";
          }
        ];
        prefixes = [
          {
            ipv4 = "10.50.10.0/24";
            ipv6 = "fd42:dead:feed:10::/64";
            kind = "tenant";
            name = "mgmt";
          }
          {
            ipv4 = "10.50.15.0/24";
            ipv6 = "fd42:dead:feed:15::/64";
            kind = "tenant";
            name = "admin";
          }
          {
            ipv4 = "10.50.20.0/24";
            ipv6 = "fd42:dead:feed:20::/64";
            kind = "tenant";
            name = "client";
            routedPrefixes = [
              {
                allocation = "runtime";
                family = "ipv6";
                name = "clab-client-public";
                prefixPostfix = "4445";
                delegatedPrefixLength = 64;
                perTenantPrefixLength = 64;
                slot = 0;
                sourceFile = "/run/secrets/access-node-ipv6-prefix-esp-clab-router-access-client";
              }
            ];
          }
          {
            ipv4 = "10.50.30.0/24";
            ipv6 = "fd42:dead:feed:30::/64";
            kind = "tenant";
            name = "dmz";
          }
          {
            ipv4 = "10.50.50.0/24";
            ipv6 = "fd42:dead:feed:50::/64";
            kind = "tenant";
            name = "streaming";
          }
          {
            ipv4 = "10.70.10.0/24";
            ipv6 = "fd42:dead:feed:70::/64";
            kind = "tenant";
            name = "hostile";
            routedPrefixes = [
              {
                allocation = "runtime";
                family = "ipv6";
                name = "hostile-public";
                delegatedPrefixLength = 64;
                perTenantPrefixLength = 64;
                slot = 0;
                sourceFile = "/run/secrets/access-node-ipv6-prefix-esp-clab-router-access-hostile";
              }
            ];
          }
        ];
      };
      pools = {
        overlay = {
          ipv4 = {
            offsetStart = 10;
            perNodePrefixLength = 32;
            prefix = "100.96.10.0/24";
          };
          ipv6 = {
            offsetStart = 10;
            perNodePrefixLength = 128;
            prefix = "fd42:dead:beef:ee::/64";
          };
        };
        loopback = {
          ipv4 = "10.59.0.0/24";
          ipv6 = "fd42:dead:feed:1900::/118";
        };
        p2p = {
          ipv4 = "10.50.0.0/24";
          ipv6 = "fd42:dead:feed:1000::/118";
        };
      };
      topology = {
        links = [
          [
            "clab-router-core-simulated-isp"
            "clab-router-upstream"
          ]
          [
            "clab-router-core-nebula"
            "clab-router-upstream"
          ]
          [
            "clab-router-upstream"
            "clab-router-policy"
          ]
          [
            "clab-router-policy"
            "clab-router-downstream"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-admin"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-client"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-dmz"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-hostile"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-mgmt"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-streaming"
          ]
        ];
        nodes = {
          clab-router-access-admin = {
            attachments = [
              {
                kind = "tenant";
                name = "admin";
              }
            ];
            role = "access";
          };
          clab-router-access-client = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          clab-router-access-dmz = {
            attachments = [
              {
                kind = "tenant";
                name = "dmz";
              }
            ];
            role = "access";
          };
          clab-router-access-hostile = {
            attachments = [
              {
                kind = "tenant";
                name = "hostile";
              }
            ];
            role = "access";
          };
          clab-router-access-mgmt = {
            attachments = [
              {
                kind = "tenant";
                name = "mgmt";
              }
            ];
            role = "access";
          };
          clab-router-access-streaming = {
            attachments = [
              {
                kind = "tenant";
                name = "streaming";
              }
            ];
            role = "access";
          };
          clab-router-core-nebula = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "core";
            uplinks = {
              east-west = {
                ipv4 = [
                  "10.20.10.0/24"
                  "10.20.15.0/24"
                  "10.20.20.0/24"
                  "10.20.30.0/24"
                  "10.20.50.0/24"
                  "10.90.10.0/24"
                  "0.0.0.0/0"
                ];
                ipv6 = [
                  "fd42:dead:beef:10::/64"
                  "fd42:dead:beef:15::/64"
                  "fd42:dead:beef:20::/64"
                  "fd42:dead:beef:30::/64"
                  "fd42:dead:beef:50::/64"
                  "fd42:dead:cafe:10::/64"
                  "::/0"
                ];
              };
            };
          };
          clab-router-core-simulated-isp = {
            role = "core";
            uplinks = {
              wan = {
                egress.ipv6.translation = {
                  mode = "nat66";
                  warning = "NAT66 is intentionally modeled only for explicit simulated or otherwise non-routed IPv6 uplinks; routed public-prefix tenants must stay routed, not masqueraded.";
                };
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          clab-router-downstream = {
            role = "downstream-selector";
          };
          clab-router-policy = {
            role = "policy";
          };
          clab-router-upstream = {
            role = "upstream-selector";
          };
        };
      };
      # SAT-SRC-INTENT-CLAB-TRANSPORT: SAT behavior coverage for CLAB overlay
      # membership, underlay access selection, and modeled hostile path
      # traversal for esp.clab.
      transport = {
        overlays = [
          {
            mustTraverse = [ "policy" ];
            name = "east-west";
            peerSites = [
              "esp.nixos"
              "esp.hetz"
            ];
            terminateOn = "clab-router-core-nebula";
            underlayAccess = {
              kind = "tenant";
              name = "client";
            };
            underlayTrafficTypes = [ "nebula" ];
          }
        ];
      };
    };
  };
}
