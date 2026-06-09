     1|# Standalone HAT inventory with explicit realization data.
     2|let
     3|  protectedPppoeCredentialBindings = import ./protected-pppoe-credential-bindings.nix {
     4|    consumerNode = "esp0xdeadbeef-site-a-nixos-core-testnet-host-isp";
     5|    harness = "s-router-nixos";
     6|    site = "nixos";
     7|  };
     8|  overlayVpnRuntimeAdapters = import ./overlay-vpn-runtime-adapters.nix;
     9|  selectorFabricLinkRealization = import ./selector-fabric-link-realization.nix;
    10|in
    11|selectorFabricLinkRealization {
    12|  inherit (protectedPppoeCredentialBindings) secretDeclarations secretSources sourceBindings;
    13|
    14|  controlPlane = {
    15|    sites.esp0xdeadbeef = {
    16|      site-a.overlays = overlayVpnRuntimeAdapters.site-a;
    17|      site-b.overlays = overlayVpnRuntimeAdapters.site-b;
    18|    };
    19|  };
    20|
    21|  deployment = {
    22|    hosts = {
    23|      s-router-clab = {
    24|        bridgeNetworks = {
    25|          stub-clab-br-site-b-p2p-clab-access-client-clab-downstream-selector = { };
    26|          stub-clab-br-site-b-p2p-clab-access-dmz-clab-downstream-selector = { };
    27|          stub-clab-br-site-b-p2p-clab-access-guest-clab-downstream-selector = { };
    28|          stub-clab-br-site-b-p2p-clab-access-iot-clab-core-nebula = { };
    29|          stub-clab-br-site-b-p2p-clab-access-iot-clab-core-wireguard-host128 = { };
    30|          stub-clab-br-site-b-p2p-clab-access-iot-clab-core-wireguard-remote-egress = { };
    31|          stub-clab-br-site-b-p2p-clab-access-iot-clab-downstream-selector = { };
    32|          stub-clab-br-site-b-p2p-clab-access-management-clab-downstream-selector = { };
    33|          stub-clab-br-site-b-p2p-clab-access-trusted-clab-downstream-selector = { };
    34|          stub-clab-br-site-b-p2p-clab-access-work-clab-downstream-selector = { };
    35|          stub-clab-br-site-b-p2p-clab-core-commercial-vpn-clab-upstream-selector = { };
    36|          stub-clab-br-site-b-p2p-clab-core-nebula-clab-upstream-selector = { };
    37|          stub-clab-br-site-b-p2p-clab-core-route-import-clab-upstream-selector = { };
    38|          stub-clab-br-site-b-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a = { };
    39|          stub-clab-br-site-b-p2p-clab-core-testnet-host-isp-clab-upstream-selector = { };
    40|          stub-clab-br-site-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b = { };
    41|          stub-clab-br-site-b-p2p-clab-core-testnet-routed-isp-clab-upstream-selector = { };
    42|          stub-clab-br-site-b-p2p-clab-core-upstream-vlan4-clab-upstream-selector = { };
    43|          stub-clab-br-site-b-p2p-clab-core-wireguard-host128-clab-upstream-selector = { };
    44|          stub-clab-br-site-b-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector = { };
    45|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-client = { };
    46|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz = { };
    47|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest = { };
    48|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot = { };
    49|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-management = { };
    50|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted = { };
    51|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-work = { };
    52|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a =
    53|            { };
    54|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b =
    55|            { };
    56|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-a = { };
    57|          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b = { };
    58|          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp =
    59|            { };
    60|          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp =
    61|            { };
    62|          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a =
    63|            { };
    64|          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress =
    65|            { };
    66|          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress =
    67|            { };
    68|          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a =
    69|            { };
    70|          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a =
    71|            { };
    72|          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a =
    73|            { };
    74|          stub-clab-client = { };
    75|          stub-clab-dmz = { };
    76|          stub-clab-guest = { };
    77|          stub-clab-iot = { };
    78|          stub-clab-mgmt = { };
    79|          stub-clab-trusted = { };
    80|          stub-clab-work = { };
    81|        };
    82|        uplinks = {
    83|          commercial-vpn = {
    84|            bridge = "stub-clab-br-nixos-uplink-commercial-vpn";
    85|            ipv4 = {
    86|              method = "none";
    87|            };
    88|            ipv6 = {
    89|              method = "none";
    90|            };
    91|            parent = "hat-commercial-vpn";
    92|            upstream = "commercial-vpn";
    93|          };
    94|          management = {
    95|            bridge = "stub-clab-vlan2";
    96|            ipv4 = {
    97|              dhcp = true;
    98|              enable = true;
    99|              method = "dhcp";
   100|            };
   101|            ipv6 = {
   102|              acceptRA = false;
   103|              dhcp = false;
   104|              dhcpv6PD = false;
   105|              enable = false;
   106|              method = "none";
   107|            };
   108|            mode = "vlan";
   109|            parent = "eth0";
   110|            vlan = 2;
   111|          };
   112|          nebula-egress = {
   113|            bridge = "stub-clab-br-nixos-uplink-nebula-egress";
   114|            ipv4 = {
   115|              method = "none";
   116|            };
   117|            ipv6 = {
   118|              method = "none";
   119|            };
   120|            parent = "hat-nebula-egress";
   121|            upstream = "nebula-egress";
   122|          };
   123|          route-import = {
   124|            bridge = "stub-clab-br-nixos-uplink-route-import";
   125|            ipv4 = {
   126|              method = "none";
   127|            };
   128|            ipv6 = {
   129|              method = "none";
   130|            };
   131|            parent = "hat-route-import";
   132|            upstream = "route-import";
   133|          };
   134|          uplink-isp-a = {
   135|            bridge = "stub-clab-br-uplink0";
   136|            ipv4 = {
   137|              dhcp = true;
   138|              enable = true;
   139|              method = "dhcp";
   140|            };
   141|            ipv6 = {
   142|              acceptRA = true;
   143|              dhcp = false;
   144|              dhcpv6PD = false;
   145|              enable = true;
   146|              method = "slaac";
   147|            };
   148|            mode = "vlan";
   149|            parent = "eth0";
   150|            upstream = "isp-a";
   151|            vlan = 4;
   152|          };
   153|          uplink-testnet-host-isp = {
   154|            bridge = "stub-clab-br-t-host";
   155|            ipv4 = {
   156|              address = "203.0.113.5/32";
   157|              method = "static";
   158|            };
   159|            ipv6 = {
   160|              address = "2001:db8:113:64::1/64";
   161|              method = "static";
   162|            };
   163|            parent = "hat-host-isp";
   164|            upstream = "testnet-host-isp";
   165|          };
   166|          uplink-testnet-routed-isp = {
   167|            bridge = "stub-clab-br-t-routed";
   168|            ipv4 = {
   169|              address = "203.0.113.1/30";
   170|              method = "static";
   171|            };
   172|            ipv6 = {
   173|              address = "2001:db8:113::1/64";
   174|              method = "static";
   175|            };
   176|            parent = "hat-routed-isp";
   177|            upstream = "testnet-routed-isp";
   178|          };
   179|          wireguard-egress = {
   180|            bridge = "stub-clab-br-nixos-uplink-wireguard-egress";
   181|            ipv4 = {
   182|              method = "none";
   183|            };
   184|            ipv6 = {
   185|              method = "none";
   186|            };
   187|            parent = "hat-wireguard-egress";
   188|            upstream = "wireguard-egress";
   189|          };
   190|          wireguard-host128 = {
   191|            bridge = "stub-clab-br-nixos-uplink-wireguard-host128";
   192|            ipv4 = {
   193|              method = "none";
   194|            };
   195|            ipv6 = {
   196|              address = "2001:db8:128::1/128";
   197|              method = "static";
   198|            };
   199|            parent = "hat-wireguard-host128";
   200|            upstream = "wireguard-host128";
   201|          };
   202|        };
   203|        wanGroupToUplink = {
   204|          "esp0xdeadbeef::site-b::clab-core-commercial-vpn" = "commercial-vpn";
   205|          "esp0xdeadbeef::site-b::clab-core-nebula" = "nebula-egress";
   206|          "esp0xdeadbeef::site-b::clab-core-route-import" = "route-import";
   207|          "esp0xdeadbeef::site-b::clab-core-testnet-host-isp" = "uplink-testnet-host-isp";
   208|          "esp0xdeadbeef::site-b::clab-core-testnet-routed-isp" = "uplink-testnet-routed-isp";
   209|          "esp0xdeadbeef::site-b::clab-core-upstream-vlan4" = "uplink-isp-a";
   210|          "esp0xdeadbeef::site-b::clab-core-wireguard-host128" = "wireguard-host128";
   211|          "esp0xdeadbeef::site-b::clab-core-wireguard-remote-egress" = "wireguard-egress";
   212|        };
   213|      };
   214|      s-router-nixos = {
   215|        bridgeNetworks = {
   216|          br-n-pppoe = {
   217|            hatPurpose = "residential-pppoe-handoff";
   218|            isolated = true;
   219|          };
   220|          br-site-a-p2p-nixos-access-client-nixos-downstream-selector = { };
   221|          br-site-a-p2p-nixos-access-dmz-nixos-downstream-selector = { };
   222|          br-site-a-p2p-nixos-access-guest-nixos-downstream-selector = { };
   223|          br-site-a-p2p-nixos-access-iot-nixos-core-nebula = { };
   224|          br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-host128 = { };
   225|          br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress = { };
   226|          br-site-a-p2p-nixos-access-iot-nixos-downstream-selector = { };
   227|          br-site-a-p2p-nixos-access-management-nixos-downstream-selector = { };
   228|          br-site-a-p2p-nixos-access-trusted-nixos-downstream-selector = { };
   229|          br-site-a-p2p-nixos-access-work-nixos-downstream-selector = { };
   230|          br-site-a-p2p-nixos-core-commercial-vpn-nixos-upstream-selector = { };
   231|          br-site-a-p2p-nixos-core-nebula-nixos-upstream-selector = { };
   232|          br-site-a-p2p-nixos-core-route-import-nixos-upstream-selector = { };
   233|          br-site-a-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a = { };
   234|          br-site-a-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector = { };
   235|          br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b = { };
   236|          br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector = { };
   237|          br-site-a-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector = { };
   238|          br-site-a-p2p-nixos-core-wireguard-host128-nixos-upstream-selector = { };
   239|          br-site-a-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector = { };
   240|          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client = { };
   241|          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz = { };
   242|          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest = { };
   243|          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot = { };
   244|          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management = { };
   245|          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted = { };
   246|          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work = { };
   247|          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a = { };
   248|          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b = { };
   249|          br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a = { };
   250|          br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b = { };
   251|          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp =
   252|            { };
   253|          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp =
   254|            { };
   255|          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a = { };
   256|          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress =
   257|            { };
   258|          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress =
   259|            { };
   260|          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a = { };
   261|          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a =
   262|            { };
   263|          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a =
   264|            { };
   265|          client = {
   266|            mode = "vlan";
   267|            parent = "eth0";
   268|            vlan = 302;
   269|          };
   270|          dmz = {
   271|            mode = "vlan";
   272|            parent = "eth0";
   273|            vlan = 304;
   274|          };
   275|          guest = {
   276|            mode = "vlan";
   277|            parent = "eth0";
   278|            vlan = 306;
   279|          };
   280|          iot = { };
   281|          mgmt = {
   282|            mode = "vlan";
   283|            parent = "eth0";
   284|            vlan = 300;
   285|          };
   286|          trusted = {
   287|            mode = "vlan";
   288|            parent = "eth0";
   289|            vlan = 301;
   290|          };
   291|          work = { };
   292|        };
   293|        hat = {
   294|          providerAccess = {
   295|            residentialDhcpRoutedTestnet = {
   296|              advertisedIpv4 = {
   297|                customerAddress = "203.0.113.2";
   298|                prefix = "203.0.113.0/30";
   299|                probeAddress = "203.0.113.1";
   300|                providerAddress = "203.0.113.1";
   301|              };
   302|              delegatedIpv6 = {
   303|                kind = "delegated-prefix";
   304|                prefix = "2001:db8:113::/48";
   305|              };
   306|              distribution = {
   307|                mode = "network-wide";
   308|                technology = "dhcp";
   309|              };
   310|              gampId = "FS-800-HDS-010-SDS-010-SMS-010";
   311|              handoff = "dhcp";
   312|              harness = "s-router-nixos";
   313|              l2Surface = {
   314|                kind = "isolated-bridge";
   315|                name = "br-t-routed";
   316|                physical = false;
   317|              };
   318|              nat44 = false;
   319|              nat64 = {
   320|                enabled = true;
   321|                ipv4Egress = "testnet-routed-isp";
   322|                prefix = "64:ff9b::/96";
   323|                probeAddress6 = "64:ff9b::cb00:7101";
   324|                probeTarget4 = "203.0.113.1";
   325|              };
   326|              nat66 = false;
   327|              probeIntent = [
   328|                "customer-wan-dhcpv4"
   329|                "testnet-routed-ipv4-/30"
   330|                "testnet-ipv6-/48"
   331|                "nat64-ipv6-to-ipv4-testnet"
   332|                "no-provider-name-nat"
   333|                "no-nat66"
   334|              ];
   335|            };
   336|            residentialPppoeHostTestnet = {
   337|              advertisedIpv4 = {
   338|                customerAddress = "203.0.113.4";
   339|                prefix = "203.0.113.4/32";
   340|                probeAddress = "203.0.113.4";
   341|                providerPeerAddress = "203.0.113.5";
   342|              };
   343|              delegatedIpv6 = {
   344|                kind = "constrained-prefix";
   345|                prefix = "2001:db8:113:64::/64";
   346|              };
   347|              distribution = {
   348|                endpoint = "nixos-core-testnet-host-isp";
   349|                mode = "endpoint-specific";
   350|                technology = "pppoe";
   351|              };
   352|              credentials = {
   353|                labOnly = true;
   354|                passwordFile = "/run/secrets/hat-pppoe-password";
   355|                usernameFile = "/run/secrets/hat-pppoe-username";
   356|              };
   357|              gampId = "FS-800-HDS-010-SDS-010-SMS-010";
   358|              handoff = "pppoe";
   359|              harness = "s-router-nixos";
   360|              l2Surface = {
   361|                kind = "isolated-bridge";
   362|                name = "br-n-pppoe";
   363|                physical = false;
   364|              };
   365|              nat44 = false;
   366|              nat64 = {
   367|                enabled = true;
   368|                ipv4Egress = "testnet-host-isp";
   369|                prefix = "64:ff9b::/96";
   370|                probeAddress6 = "64:ff9b::cb00:7104";
   371|                probeTarget4 = "203.0.113.4";
   372|              };
   373|              nat66 = false;
   374|              probeIntent = [
   375|                "pppoe-session-up"
   376|                "testnet-host-ipv4-/32"
   377|                "testnet-ipv6-/64"
   378|                "nat64-ipv6-to-ipv4-testnet"
   379|                "no-provider-name-nat"
   380|                "no-nat66"
   381|              ];
   382|            };
   383|          };
   384|        };
   385|        uplinks = {
   386|          commercial-vpn = {
   387|            bridge = "br-nixos-uplink-commercial-vpn";
   388|            ipv4 = {
   389|              method = "none";
   390|            };
   391|            ipv6 = {
   392|              method = "none";
   393|            };
   394|            parent = "hat-commercial-vpn";
   395|            upstream = "commercial-vpn";
   396|          };
   397|          management = {
   398|            bridge = "vlan2";
   399|            ipv4 = {
   400|              dhcp = true;
   401|              enable = true;
   402|              method = "dhcp";
   403|            };
   404|            ipv6 = {
   405|              acceptRA = false;
   406|              dhcp = false;
   407|              dhcpv6PD = false;
   408|              enable = false;
   409|              method = "none";
   410|            };
   411|            mode = "vlan";
   412|            parent = "eth0";
   413|            vlan = 2;
   414|          };
   415|          nebula-egress = {
   416|            bridge = "br-nixos-uplink-nebula-egress";
   417|            ipv4 = {
   418|              method = "none";
   419|            };
   420|            ipv6 = {
   421|              method = "none";
   422|            };
   423|            parent = "hat-nebula-egress";
   424|            upstream = "nebula-egress";
   425|          };
   426|          route-import = {
   427|            bridge = "br-nixos-uplink-route-import";
   428|            ipv4 = {
   429|              method = "none";
   430|            };
   431|            ipv6 = {
   432|              method = "none";
   433|            };
   434|            parent = "hat-route-import";
   435|            upstream = "route-import";
   436|          };
   437|          uplink-isp-a = {
   438|            bridge = "br-uplink0";
   439|            ipv4 = {
   440|              dhcp = true;
   441|              enable = true;
   442|              method = "dhcp";
   443|            };
   444|            ipv6 = {
   445|              acceptRA = true;
   446|              dhcp = false;
   447|              dhcpv6PD = false;
   448|              enable = true;
   449|              method = "slaac";
   450|            };
   451|            mode = "vlan";
   452|            parent = "eth0";
   453|            upstream = "isp-a";
   454|            vlan = 4;
   455|          };
   456|          uplink-testnet-host-isp = {
   457|            bridge = "br-t-host";
   458|            ipv4 = {
   459|              address = "203.0.113.5/32";
   460|              method = "static";
   461|            };
   462|            ipv6 = {
   463|              address = "2001:db8:113:64::1/64";
   464|              method = "static";
   465|            };
   466|            parent = "hat-host-isp";
   467|            upstream = "testnet-host-isp";
   468|          };
   469|          uplink-testnet-routed-isp = {
   470|            bridge = "br-t-routed";
   471|            ipv4 = {
   472|              address = "203.0.113.1/30";
   473|              method = "static";
   474|            };
   475|            ipv6 = {
   476|              address = "2001:db8:113::1/64";
   477|              method = "static";
   478|            };
   479|            parent = "hat-routed-isp";
   480|            upstream = "testnet-routed-isp";
   481|          };
   482|          wireguard-egress = {
   483|            bridge = "br-nixos-uplink-wireguard-egress";
   484|            ipv4 = {
   485|              method = "none";
   486|            };
   487|            ipv6 = {
   488|              method = "none";
   489|            };
   490|            parent = "hat-wireguard-egress";
   491|            upstream = "wireguard-egress";
   492|          };
   493|          wireguard-host128 = {
   494|            bridge = "br-nixos-uplink-wireguard-host128";
   495|            ipv4 = {
   496|              method = "none";
   497|            };
   498|            ipv6 = {
   499|              address = "2001:db8:128::1/128";
   500|              method = "static";
   501|