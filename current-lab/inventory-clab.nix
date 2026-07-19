let
  source = import ../GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-clab.nix;
  rowIntent = import ../GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/intent.nix;
  forwardingEnterprise = builtins.fromJSON ''
{"mini-smt":{"site":{"FS-230-HDS-010-SDS-010-SMS-040":{"accessSpaceDiscovery":{"confined":[],"exported":[],"sharedServicePolicyAtoms":[]},"addressPools":{"local":{"ipv4":"10.23.0.0/24","ipv6":"fd42:0230:ff::/118"},"p2p":{"ipv4":"10.23.255.0/24","ipv6":"fd42:0230:fe::/118"}},"attachments":[{"kind":"tenant","name":"lab-dmz","unit":"access-dmz"}],"communicationContract":{"allowedRelations":[{"action":"allow","from":{"kind":"external","uplinks":["lab-wan"]},"id":"FS-230-HDS-010-SDS-010-SMS-040__lab-wan-to-nebula-ipv6","match":[{"dports":[4242],"family":"ipv6","proto":"udp"}],"priority":100,"publicIngressTupleAuthority":{"family":"ipv6","returnBehavior":"stateful-return","sourcePreservation":"preserve-source","targetPort":4242,"targetService":"nebula-lab","translationMode":"none","tuples":[{"protocol":"udp","publicPort":4242}]},"returnBehavior":"stateful-return","source":{"id":"FS-230-HDS-010-SDS-010-SMS-040__lab-wan-to-nebula-ipv6","kind":"relation","priority":100,"sourceAudit":{"authority":"network-compiler","outputPath":["relations",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",0]}},"to":{"kind":"service","name":"nebula-lab"},"trafficType":"nebula-ipv6"}],"services":[{"name":"nebula-lab","providers":["nebula-lab-endpoint"],"trafficType":"nebula-ipv6"}],"trafficTypes":[{"match":[{"dports":[4242],"family":"ipv6","proto":"udp"}],"name":"nebula-ipv6"}]},"consumedInterfaces":{"access":[{"access":"access-dmz","tenant":"lab-dmz"}],"clients":[{"access":["access-dmz"],"client":"nebula-lab-endpoint","tenant":"lab-dmz"}],"sharedServices":[],"tenants":[{"ipv4":"10.2.30.0/24","ipv6":"fd42:0230:40::/64","name":"lab-dmz","routedPrefixes":[{"allocation":"runtime","delegatedPrefixLength":48,"family":"ipv6","name":"lab-dmz-public","perTenantPrefixLength":64,"slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix"}]}]},"coreNodeNames":["core-lab-wan"],"dns":{"communicationContract":{"relations":[],"services":[]},"localSharing":null,"recursive":{"bindings":[],"relations":[],"services":[]},"schemaVersion":1,"warnings":[]},"domains":{"externals":[],"tenants":[{"ipv4":"10.2.30.0/24","ipv6":"fd42:0230:40::/64","name":"lab-dmz","routedPrefixes":[{"allocation":"runtime","delegatedPrefixLength":48,"family":"ipv6","name":"lab-dmz-public","perTenantPrefixLength":64,"slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix"}]}]},"egressIntent":{"authorityRelationIds":[],"eligibleNodeNames":[],"enabled":false,"exitNodeNames":[],"explicit":true,"externalDomains":[],"uplinkCoreNodeNames":[],"uplinkNames":[],"upstreamSelectorNodeName":null},"enterprise":"mini-smt","forwardingSemantics":{"coreNodeNames":["core-lab-wan"],"dns":{"accessNodeNames":["access-dmz"],"explicit":true,"nonWanCoreNodeNames":[],"resolverPreferenceNodeNames":["access-dmz","core-lab-wan"],"serviceNodeNames":["access-dmz","core-lab-wan"],"wanFallbackNodeNames":["core-lab-wan"]},"explicit":true,"nodes":{"access-dmz":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","access-gateway","connected-prefix-origin","tenant-edge","traversal-entry"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":true},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":true,"participates":true,"transit":true,"upstreamSelection":false}},"core-lab-wan":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","uplink-anchor"],"forwardingResponsibility":{"anchorsExternalUplinks":true,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"downstream-selector":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","downstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"policy":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","policy-enforcer"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":true,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":true,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"upstream-selector":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}}},"policyNodeName":"policy","traversalParticipantNodeNames":["access-dmz","core-lab-wan","downstream-selector","policy","upstream-selector"],"upstreamSelectorNodeName":"upstream-selector"},"hostNatIngress":{},"ipv6":{},"isolationDecisions":[],"links":{"p2p-access-dmz-downstream-selector":{"endpoints":{"access-dmz":{"addr4":"10.23.255.0/31","addr6":"fd42:230:fe:0:0:0:0:0/127","interface":"p2p-access-dmz-downstream-selector","node":"access-dmz"},"downstream-selector":{"addr4":"10.23.255.1/31","addr6":"fd42:230:fe:0:0:0:0:1/127","interface":"p2p-access-dmz-downstream-selector","node":"downstream-selector"}},"id":"link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-access-dmz-downstream-selector","kind":"p2p","lane":"default","laneMeta":{"access":"access-dmz","kind":"access-edge","uplink":null,"uplinks":[]},"members":["access-dmz","downstream-selector"],"type":"p2p"},"p2p-core-lab-wan-upstream-selector":{"endpoints":{"core-lab-wan":{"addr4":"10.23.255.2/31","addr6":"fd42:230:fe:0:0:0:0:2/127","interface":"p2p-core-lab-wan-upstream-selector","node":"core-lab-wan"},"upstream-selector":{"addr4":"10.23.255.3/31","addr6":"fd42:230:fe:0:0:0:0:3/127","interface":"p2p-core-lab-wan-upstream-selector","node":"upstream-selector"}},"id":"link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-core-lab-wan-upstream-selector","kind":"p2p","lane":"uplink::lab-wan","laneMeta":{"access":null,"kind":"uplink","uplink":"lab-wan","uplinks":["lab-wan"]},"members":["core-lab-wan","upstream-selector"],"type":"p2p","uplinks":["lab-wan"]},"p2p-downstream-selector-policy--access-access-dmz":{"endpoints":{"downstream-selector":{"addr4":"10.23.255.4/31","addr6":"fd42:230:fe:0:0:0:0:4/127","interface":"p2p-downstream-selector-policy--access-access-dmz","node":"downstream-selector"},"policy":{"addr4":"10.23.255.5/31","addr6":"fd42:230:fe:0:0:0:0:5/127","interface":"p2p-downstream-selector-policy--access-access-dmz","node":"policy"}},"id":"link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-downstream-selector-policy--access-access-dmz","kind":"p2p","lane":"access::access-dmz","laneMeta":{"access":"access-dmz","kind":"access","uplink":null,"uplinks":[]},"members":["downstream-selector","policy"],"type":"p2p"},"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan":{"endpoints":{"policy":{"addr4":"10.23.255.6/31","addr6":"fd42:230:fe:0:0:0:0:6/127","interface":"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","node":"policy"},"upstream-selector":{"addr4":"10.23.255.7/31","addr6":"fd42:230:fe:0:0:0:0:7/127","interface":"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","node":"upstream-selector"}},"id":"link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","kind":"p2p","lane":"access::access-dmz::uplink::lab-wan","laneMeta":{"access":"access-dmz","kind":"access-uplink","uplink":"lab-wan","uplinks":["lab-wan"]},"members":["policy","upstream-selector"],"type":"p2p"}},"nodes":{"access-dmz":{"attachments":[{"kind":"tenant","name":"lab-dmz"}],"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","access-gateway","connected-prefix-origin","tenant-edge","traversal-entry"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":true},"interfaces":{"p2p-access-dmz-downstream-selector":{"acceptRA":false,"addr4":"10.23.255.0/31","addr6":"fd42:230:fe:0:0:0:0:0/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-access-dmz-downstream-selector","kind":"p2p","link":"p2p-access-dmz-downstream-selector","ll6":null,"name":"p2p-access-dmz-downstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.23.255.1"},{"dst":"10.23.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.1"},{"dst":"10.23.0.2/31","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.1"},{"dst":"10.23.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.1"},{"dst":"10.23.255.0/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.23.255.2/31","intent":{"accessNode":"core-lab-wan","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.1"},{"dst":"10.23.255.4/30","intent":{"accessNode":"core-lab-wan","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.1"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:230:fe:0:0:0:0:1"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0000/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0002/127","intent":{"accessNode":"core-lab-wan","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:1"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0004/126","intent":{"accessNode":"core-lab-wan","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:1"},{"dst":"fd42:0230:00ff:0000:0000:0000:0000:0001/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:1"},{"dst":"fd42:0230:00ff:0000:0000:0000:0000:0002/127","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:1"},{"dst":"fd42:0230:00ff:0000:0000:0000:0000:0004/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:1"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"tenant-lab-dmz":{"acceptRA":false,"addr4":"10.2.30.1/24","addr6":"fd42:230:40:0:0:0:0:1/64","carrier":"logical","dhcp":false,"gateway":false,"interface":"tenant-lab-dmz","kind":"tenant","l2":false,"ll6":null,"logical":true,"name":"tenant-lab-dmz","network":{"ipv4":"10.2.30.0/24","ipv6":"fd42:0230:0040:0000:0000:0000:0000:0000/64","kind":"tenant","name":"lab-dmz"},"node":"access-dmz","overlay":null,"peerAddr4":null,"peerAddr6":null,"routedPrefixes":[{"allocation":"runtime","delegatedPrefixLength":48,"family":"ipv6","name":"lab-dmz-public","perTenantPrefixLength":64,"slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix"}],"routes":{"ipv4":[{"dst":"10.2.30.0/24","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0230:0040:0000:0000:0000:0000:0000/64","intent":{"kind":"connected-reachability"},"proto":"connected"}]},"subnet4":"10.2.30.0/24","subnet6":"fd42:0230:0040:0000:0000:0000:0000:0000/64","tenant":"lab-dmz","type":"logical","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null,"virtual":true}},"loopback":{"ipv4":"10.23.0.0/32","ipv6":"fd42:230:ff:0:0:0:0:0/128"},"networks":{"lab-dmz":{"ipv4":"10.2.30.0/24","ipv6":"fd42:0230:40::/64","kind":"tenant","name":"lab-dmz","publicIpv4":null,"ra6Prefixes":[],"routedPrefixes":[{"allocation":"runtime","delegatedPrefixLength":48,"family":"ipv6","name":"lab-dmz-public","perTenantPrefixLength":64,"slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix"}]}},"role":"access","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":true,"participates":true,"transit":true,"upstreamSelection":false}},"core-lab-wan":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"external":"lab-wan","forwardingFunctions":["router-identity","transit-forwarder","uplink-anchor"],"forwardingResponsibility":{"anchorsExternalUplinks":true,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-core-lab-wan-upstream-selector":{"acceptRA":false,"addr4":"10.23.255.2/31","addr6":"fd42:230:fe:0:0:0:0:2/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-core-lab-wan-upstream-selector","kind":"p2p","link":"p2p-core-lab-wan-upstream-selector","ll6":null,"name":"p2p-core-lab-wan-upstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.2.30.0/24","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.3"},{"dst":"10.23.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.3"},{"dst":"10.23.0.2/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.3"},{"dst":"10.23.0.3/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.3"},{"dst":"10.23.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.3"},{"dst":"10.23.255.0/31","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.3"},{"dst":"10.23.255.2/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.23.255.4/31","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.3"},{"dst":"10.23.255.6/31","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.3"}],"ipv6":[{"dst":"fd42:0230:0040:0000:0000:0000:0000:0000/64","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:3"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0000/127","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:3"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0002/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0004/127","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:3"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0006/127","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:3"},{"dst":"fd42:230:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:3"},{"dst":"fd42:230:ff:0:0:0:0:2/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:3"},{"dst":"fd42:230:ff:0:0:0:0:3/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:3"},{"dst":"fd42:230:ff:0:0:0:0:4/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:3"},{"delegatedPrefixLength":48,"family":6,"intent":{"accessNode":"access-dmz","authorityClass":"routed-client-prefix","downstreamExport":{"allowed":true,"reason":"authority-class-allows-downstream-export"},"kind":"runtime-routed-prefix-return","source":"intent-routed-prefix"},"perTenantPrefixLength":64,"prefixName":"lab-dmz-public","proto":"internal","slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix","tenant":"lab-dmz","via6":"fd42:230:fe:0:0:0:0:3"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.23.0.1/32","ipv6":"fd42:230:ff:0:0:0:0:1/128"},"role":"core","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false},"uplinks":{"lab-wan":{"ipv4":["0.0.0.0/0"],"ipv6":["::/0"]}}},"downstream-selector":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","downstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-access-dmz-downstream-selector":{"acceptRA":false,"addr4":"10.23.255.1/31","addr6":"fd42:230:fe:0:0:0:0:1/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-access-dmz-downstream-selector","kind":"p2p","link":"p2p-access-dmz-downstream-selector","ll6":null,"name":"p2p-access-dmz-downstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.2.30.0/24","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.0"},{"dst":"10.23.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.0"},{"dst":"10.23.255.0/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0230:0040:0000:0000:0000:0000:0000/64","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:0"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0000/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:230:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:0"},{"delegatedPrefixLength":48,"family":6,"intent":{"accessNode":"access-dmz","authorityClass":"routed-client-prefix","downstreamExport":{"allowed":true,"reason":"authority-class-allows-downstream-export"},"kind":"runtime-routed-prefix-return","source":"intent-routed-prefix"},"perTenantPrefixLength":64,"prefixName":"lab-dmz-public","proto":"internal","slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix","tenant":"lab-dmz","via6":"fd42:230:fe:0:0:0:0:0"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-downstream-selector-policy--access-access-dmz":{"acceptRA":false,"addr4":"10.23.255.4/31","addr6":"fd42:230:fe:0:0:0:0:4/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-downstream-selector-policy--access-access-dmz","kind":"p2p","link":"p2p-downstream-selector-policy--access-access-dmz","ll6":null,"name":"p2p-downstream-selector-policy--access-access-dmz","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.23.255.5"},{"direction":"outbound","dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"lane":{"access":"access-dmz","uplink":null},"policyOnly":true,"proto":"default","reason":"policy-derived-default","via4":"10.23.255.5"},{"dst":"10.23.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.5"},{"dst":"10.23.0.3/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.5"},{"dst":"10.23.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.5"},{"dst":"10.23.255.2/31","intent":{"accessNode":"core-lab-wan","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.5"},{"dst":"10.23.255.4/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.23.255.6/31","intent":{"accessNode":"core-lab-wan","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.5"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:230:fe:0:0:0:0:5"},{"direction":"outbound","dst":"::/0","intent":{"kind":"default-reachability"},"lane":{"access":"access-dmz","uplink":null},"policyOnly":true,"proto":"default","reason":"policy-derived-default","via6":"fd42:230:fe:0:0:0:0:5"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0002/127","intent":{"accessNode":"core-lab-wan","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:5"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0004/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0006/127","intent":{"accessNode":"core-lab-wan","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:5"},{"dst":"fd42:0230:00ff:0000:0000:0000:0000:0001/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:5"},{"dst":"fd42:0230:00ff:0000:0000:0000:0000:0003/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:5"},{"dst":"fd42:0230:00ff:0000:0000:0000:0000:0004/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:5"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.23.0.2/32","ipv6":"fd42:230:ff:0:0:0:0:2/128"},"role":"downstream-selector","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"policy":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","policy-enforcer"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":true,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-downstream-selector-policy--access-access-dmz":{"acceptRA":false,"addr4":"10.23.255.5/31","addr6":"fd42:230:fe:0:0:0:0:5/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-downstream-selector-policy--access-access-dmz","kind":"p2p","link":"p2p-downstream-selector-policy--access-access-dmz","ll6":null,"name":"p2p-downstream-selector-policy--access-access-dmz","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.2.30.0/24","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.4"},{"dst":"10.23.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.4"},{"dst":"10.23.0.2/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.4"},{"dst":"10.23.255.0/31","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.4"},{"dst":"10.23.255.4/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0230:0040:0000:0000:0000:0000:0000/64","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:4"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0000/127","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:4"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0004/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:230:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:4"},{"dst":"fd42:230:ff:0:0:0:0:2/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:4"},{"delegatedPrefixLength":48,"family":6,"intent":{"accessNode":"access-dmz","authorityClass":"routed-client-prefix","downstreamExport":{"allowed":true,"reason":"authority-class-allows-downstream-export"},"kind":"runtime-routed-prefix-return","source":"intent-routed-prefix"},"perTenantPrefixLength":64,"prefixName":"lab-dmz-public","proto":"internal","slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix","tenant":"lab-dmz","via6":"fd42:230:fe:0:0:0:0:4"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan":{"acceptRA":false,"addr4":"10.23.255.6/31","addr6":"fd42:230:fe:0:0:0:0:6/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","kind":"p2p","link":"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","ll6":null,"name":"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.23.255.7"},{"dst":"10.23.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.7"},{"dst":"10.23.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.7"},{"dst":"10.23.255.2/31","intent":{"accessNode":"core-lab-wan","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.7"},{"dst":"10.23.255.6/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:230:fe:0:0:0:0:7"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0002/127","intent":{"accessNode":"core-lab-wan","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:7"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0006/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0230:00ff:0000:0000:0000:0000:0001/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:7"},{"dst":"fd42:0230:00ff:0000:0000:0000:0000:0004/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:7"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.23.0.3/32","ipv6":"fd42:230:ff:0:0:0:0:3/128"},"role":"policy","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":true,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"upstream-selector":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-core-lab-wan-upstream-selector":{"acceptRA":false,"addr4":"10.23.255.3/31","addr6":"fd42:230:fe:0:0:0:0:3/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-core-lab-wan-upstream-selector","kind":"p2p","link":"p2p-core-lab-wan-upstream-selector","ll6":null,"name":"p2p-core-lab-wan-upstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.23.255.2"},{"dst":"10.23.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.2"},{"dst":"10.23.255.2/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:230:fe:0:0:0:0:2"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0002/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0230:00ff:0000:0000:0000:0000:0001/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:2"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan":{"acceptRA":false,"addr4":"10.23.255.7/31","addr6":"fd42:230:fe:0:0:0:0:7/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","kind":"p2p","link":"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","ll6":null,"name":"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.2.30.0/24","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.6"},{"dst":"10.23.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.6"},{"dst":"10.23.0.2/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.6"},{"dst":"10.23.0.3/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.6"},{"dst":"10.23.255.0/31","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.6"},{"dst":"10.23.255.4/31","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via4":"10.23.255.6"},{"dst":"10.23.255.6/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0230:0040:0000:0000:0000:0000:0000/64","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:6"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0000/127","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:6"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0004/127","intent":{"accessNode":"access-dmz","kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:6"},{"dst":"fd42:0230:00fe:0000:0000:0000:0000:0006/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:230:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:6"},{"dst":"fd42:230:ff:0:0:0:0:2/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:6"},{"dst":"fd42:230:ff:0:0:0:0:3/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:230:fe:0:0:0:0:6"},{"delegatedPrefixLength":48,"family":6,"intent":{"accessNode":"access-dmz","authorityClass":"routed-client-prefix","downstreamExport":{"allowed":true,"reason":"authority-class-allows-downstream-export"},"kind":"runtime-routed-prefix-return","source":"intent-routed-prefix"},"perTenantPrefixLength":64,"prefixName":"lab-dmz-public","proto":"internal","slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix","tenant":"lab-dmz","via6":"fd42:230:fe:0:0:0:0:6"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.23.0.4/32","ipv6":"fd42:230:ff:0:0:0:0:4/128"},"role":"upstream-selector","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}}},"overlayAddressPools":{},"overlayAttachments":{},"overlayReachability":{},"ownership":{"endpoints":[{"kind":"host","name":"nebula-lab-endpoint","tenant":"lab-dmz"}],"prefixes":[{"ipv4":"10.2.30.0/24","ipv6":"fd42:0230:40::/64","kind":"tenant","name":"lab-dmz","routedPrefixes":[{"allocation":"runtime","delegatedPrefixLength":48,"family":"ipv6","name":"lab-dmz-public","perTenantPrefixLength":64,"slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix"}]}]},"policy":{"interfaceTags":{"lab-dmz":{"attachments":[{"kind":"tenant","name":"lab-dmz","unit":"access-dmz"}],"domains":[{"ipv4":"10.2.30.0/24","ipv6":"fd42:0230:40::/64","kind":"tenant","name":"lab-dmz","routedPrefixes":[{"allocation":"runtime","delegatedPrefixLength":48,"family":"ipv6","name":"lab-dmz-public","perTenantPrefixLength":64,"slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix"}]}]}}},"policyNodeName":"policy","prefixAuthority":{"consumerEligibility":{},"deniedGuaPlacementPreconditions":{},"deniedRouteExportPreconditions":{},"deniedRouteImportConstraints":{},"deniedSpace":{},"guaPlacementPreconditions":{},"records":{"prefix-authority::access-dmz::4|10.2.30.0/24":{"authorityClass":"access-subnet-pool","childPurpose":"tenant-or-access-assignment","consumerEligibility":{"advertisement":false,"assignment":true,"exposure":false,"route":true,"translation":false},"family":4,"id":"prefix-authority::access-dmz::4|10.2.30.0/24","netName":"lab-dmz","owner":"access-dmz","prefix":"10.2.30.0/24","reservationState":"assigned","scopeKind":"node","scopeName":"access-dmz","sourceAuthority":{"kind":"modeled-prefix","owner":"access-dmz","prefix":"10.2.30.0/24","routeIdentity":"10.2.30.0/24"}},"prefix-authority::access-dmz::6|fd42:0230:0040:0000:0000:0000:0000:0000/64":{"authorityClass":"access-subnet-pool","childPurpose":"tenant-or-access-assignment","consumerEligibility":{"advertisement":false,"assignment":true,"exposure":false,"route":true,"translation":false},"family":6,"id":"prefix-authority::access-dmz::6|fd42:0230:0040:0000:0000:0000:0000:0000/64","netName":"lab-dmz","owner":"access-dmz","prefix":"fd42:0230:0040:0000:0000:0000:0000:0000/64","reservationState":"assigned","scopeKind":"node","scopeName":"access-dmz","sourceAuthority":{"kind":"modeled-prefix","owner":"access-dmz","prefix":"fd42:0230:0040:0000:0000:0000:0000:0000/64","routeIdentity":"fd42:0230:0040:0000:0000:0000:0000:0000/64"}},"prefix-authority::access-dmz::6|source:/run/secrets/fs230-lab-dmz-ipv6-prefix":{"authorityClass":"routed-client-prefix","childPurpose":"downstream-client-routing","consumerEligibility":{"advertisement":true,"assignment":true,"exposure":true,"route":true,"translation":false},"delegatedPrefixLength":48,"family":6,"id":"prefix-authority::access-dmz::6|source:/run/secrets/fs230-lab-dmz-ipv6-prefix","netName":"lab-dmz","owner":"access-dmz","perTenantPrefixLength":64,"prefixName":"lab-dmz-public","reservationState":"assigned","scopeKind":"node","scopeName":"access-dmz","slot":35,"sourceAuthority":{"delegatedPrefixLength":48,"kind":"modeled-runtime-routed-prefix","owner":"access-dmz","perTenantPrefixLength":64,"prefixName":"lab-dmz-public","routeIdentity":"source:/run/secrets/fs230-lab-dmz-ipv6-prefix","slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix"},"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix"}},"routeExportPreconditions":{},"routeImportConstraints":{}},"providerHandoffs":[],"publicIpv4DestinationPolicy":{"broadWanDenials":{},"destinationClasses":{},"diagnostics":{},"shortcutAuthorizations":{},"shortcutPolicyDenials":{}},"relations":[{"action":"allow","from":{"kind":"external","uplinks":["lab-wan"]},"match":[{"dports":[4242],"family":"ipv6","proto":"udp"}],"publicIngressTupleAuthority":{"family":"ipv6","returnBehavior":"stateful-return","sourcePreservation":"preserve-source","targetPort":4242,"targetService":"nebula-lab","translationMode":"none","tuples":[{"protocol":"udp","publicPort":4242}]},"returnBehavior":"stateful-return","source":{"id":"FS-230-HDS-010-SDS-010-SMS-040__lab-wan-to-nebula-ipv6","kind":"relation","priority":100,"sourceAudit":{"authority":"network-compiler","outputPath":["relations",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",0]}},"to":{"kind":"service","name":"nebula-lab"},"trafficType":"nebula-ipv6"}],"services":[{"name":"nebula-lab","providers":["nebula-lab-endpoint"],"trafficType":"nebula-ipv6"}],"siteId":"FS-230-HDS-010-SDS-010-SMS-040","siteName":"mini-smt.FS-230-HDS-010-SDS-010-SMS-040","sourceAudit":{"behavior":[{"authority":"network-compiler","outputPath":["tenants",0],"sourceClass":"user-intent","sourcePath":["segments","tenants","lab-dmz"]},{"authority":"network-compiler","outputPath":["services",0],"sourceClass":"user-intent","sourcePath":["communicationContract","services","nebula-lab"]},{"authority":"network-compiler","outputPath":["relations",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",0]},{"authority":"network-compiler","outputPath":["trafficPaths",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations","FS-230-HDS-010-SDS-010-SMS-040__lab-wan-to-nebula-ipv6"]},{"authority":"network-compiler","outputPath":["dns"],"sourceClass":"user-intent","sourcePath":["recursiveDnsIntent"]}]},"tenantPrefixOwners":{"4|10.2.30.0/24":{"dst":"10.2.30.0/24","family":4,"netName":"lab-dmz","owner":"access-dmz"},"6|fd42:0230:0040:0000:0000:0000:0000:0000/64":{"dst":"fd42:0230:0040:0000:0000:0000:0000:0000/64","family":6,"netName":"lab-dmz","owner":"access-dmz"},"6|source:/run/secrets/fs230-lab-dmz-ipv6-prefix":{"authorityClass":"routed-client-prefix","delegatedPrefixLength":48,"family":6,"kind":"runtime-routed-prefix","netName":"lab-dmz","owner":"access-dmz","perTenantPrefixLength":64,"prefixName":"lab-dmz-public","slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix"}},"tenants":[{"ipv4":"10.2.30.0/24","ipv6":"fd42:0230:40::/64","name":"lab-dmz","routedPrefixes":[{"allocation":"runtime","delegatedPrefixLength":48,"family":"ipv6","name":"lab-dmz-public","perTenantPrefixLength":64,"slot":35,"sourceFile":"/run/secrets/fs230-lab-dmz-ipv6-prefix"}]}],"topology":{"links":[["access-dmz","downstream-selector"],["downstream-selector","policy"],["policy","upstream-selector"],["upstream-selector","core-lab-wan"]]},"trafficPathValidation":{"diagnostics":{},"invalidPathCount":0,"invalidPaths":[],"validPathCount":1,"validPaths":[{"action":"allow","corePathNodes":["core-lab-wan"],"destination":{"kind":"service","name":"nebula-lab"},"forbidsCoreToCoreP2P":true,"nodePath":["core-lab-wan","upstream-selector","policy","downstream-selector","access-dmz"],"nodePathAlternatives":[["core-lab-wan","upstream-selector","policy","downstream-selector","access-dmz"]],"p2pIsolationKey":"FS-230-HDS-010-SDS-010-SMS-040__lab-wan-to-nebula-ipv6","relationId":"FS-230-HDS-010-SDS-010-SMS-040__lab-wan-to-nebula-ipv6","requiresPolicy":true,"source":{"kind":"external","uplinks":["lab-wan"]},"stagePath":["core","upstream-selector","policy","downstream-selector","access"],"trafficType":"nebula-ipv6"}]},"trafficPaths":[{"action":"allow","corePathNodes":["core-lab-wan"],"destination":{"kind":"service","name":"nebula-lab"},"forbidsCoreToCoreP2P":true,"nodePath":["core-lab-wan","upstream-selector","policy","downstream-selector","access-dmz"],"nodePathAlternatives":[["core-lab-wan","upstream-selector","policy","downstream-selector","access-dmz"]],"p2pIsolationKey":"FS-230-HDS-010-SDS-010-SMS-040__lab-wan-to-nebula-ipv6","relationId":"FS-230-HDS-010-SDS-010-SMS-040__lab-wan-to-nebula-ipv6","requiresPolicy":true,"source":{"kind":"external","uplinks":["lab-wan"]},"stagePath":["core","upstream-selector","policy","downstream-selector","access"],"trafficType":"nebula-ipv6"}],"transit":{"adjacencies":[{"endpoints":[{"local":{"ipv4":"10.23.255.0","ipv6":"fd42:230:fe:0:0:0:0:0"},"unit":"access-dmz"},{"local":{"ipv4":"10.23.255.1","ipv6":"fd42:230:fe:0:0:0:0:1"},"unit":"downstream-selector"}],"id":"link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-access-dmz-downstream-selector","kind":"p2p","lane":"default","laneMeta":{"access":"access-dmz","kind":"access-edge","uplink":null,"uplinks":[]},"link":"p2p-access-dmz-downstream-selector","members":["access-dmz","downstream-selector"],"name":"p2p-access-dmz-downstream-selector"},{"endpoints":[{"local":{"ipv4":"10.23.255.2","ipv6":"fd42:230:fe:0:0:0:0:2"},"unit":"core-lab-wan"},{"local":{"ipv4":"10.23.255.3","ipv6":"fd42:230:fe:0:0:0:0:3"},"unit":"upstream-selector"}],"id":"link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-core-lab-wan-upstream-selector","kind":"p2p","lane":"uplink::lab-wan","laneMeta":{"access":null,"kind":"uplink","uplink":"lab-wan","uplinks":["lab-wan"]},"link":"p2p-core-lab-wan-upstream-selector","members":["core-lab-wan","upstream-selector"],"name":"p2p-core-lab-wan-upstream-selector","uplinks":["lab-wan"]},{"endpoints":[{"local":{"ipv4":"10.23.255.4","ipv6":"fd42:230:fe:0:0:0:0:4"},"unit":"downstream-selector"},{"local":{"ipv4":"10.23.255.5","ipv6":"fd42:230:fe:0:0:0:0:5"},"unit":"policy"}],"id":"link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-downstream-selector-policy--access-access-dmz","kind":"p2p","lane":"access::access-dmz","laneMeta":{"access":"access-dmz","kind":"access","uplink":null,"uplinks":[]},"link":"p2p-downstream-selector-policy--access-access-dmz","members":["downstream-selector","policy"],"name":"p2p-downstream-selector-policy--access-access-dmz"},{"endpoints":[{"local":{"ipv4":"10.23.255.6","ipv6":"fd42:230:fe:0:0:0:0:6"},"unit":"policy"},{"local":{"ipv4":"10.23.255.7","ipv6":"fd42:230:fe:0:0:0:0:7"},"unit":"upstream-selector"}],"id":"link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","kind":"p2p","lane":"access::access-dmz::uplink::lab-wan","laneMeta":{"access":"access-dmz","kind":"access-uplink","uplink":"lab-wan","uplinks":["lab-wan"]},"link":"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","members":["policy","upstream-selector"],"name":"p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan"}],"dedicatedLanes":true,"links":[["access-dmz","downstream-selector"],["downstream-selector","policy"],["policy","upstream-selector"],["upstream-selector","core-lab-wan"]],"ordering":["link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-access-dmz-downstream-selector","link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-downstream-selector-policy--access-access-dmz","link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan","link::mini-smt.FS-230-HDS-010-SDS-010-SMS-040::p2p-core-lab-wan-upstream-selector"],"pool":{"ipv4":"10.23.255.0/24","ipv6":"fd42:0230:fe::/118"}},"uplinkCoreNames":["core-lab-wan"],"uplinkNames":["lab-wan"],"upstreamSelectorNodeName":"upstream-selector"}}}}
  '';
  managementVlan2 = {
    bridge = "vlan2";
    ipv4 = {
      dhcp = true;
      enable = true;
      method = "dhcp";
    };
    ipv6 = {
      acceptRA = false;
      dhcp = false;
      dhcpv6PD = false;
      enable = false;
      method = "none";
    };
    mode = "vlan";
    parent = "eth0";
    vlan = 2;
  };
  deployment = source.deployment or { };
  deploymentHosts = (deployment.hosts or { }) // (source.deploymentHosts or { });
  realization = source.realization or { };
  sanitize = value:
    let
      lower = builtins.replaceStrings
        [ "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" ]
        [ "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" ];
      cleaned = builtins.replaceStrings [ "." "_" ":" "/" " " ] [ "-" "-" "-" "-" "-" ] value;
    in
    lower cleaned;
  indexedMap = f: values:
    builtins.genList (index: f index (builtins.elemAt values index)) (builtins.length values);
  linksForSite = enterpriseName: siteName:
    (((forwardingEnterprise.${enterpriseName} or { }).site or { }).${siteName} or { }).links or { };
  nodeForSite = enterpriseName: siteName: nodeName:
    ((((forwardingEnterprise.${enterpriseName} or { }).site or { }).${siteName} or { }).nodes or { }).${nodeName} or { };
  bridgeForLink = linkName: "br-${linkName}";
  normalizeUplink = uplinkName: uplink:
    uplink // {
      bridge = uplink.bridge or uplinkName;
    };
  normalizeUplinks = uplinks:
    builtins.mapAttrs normalizeUplink uplinks;
  mergeFamily = generated: existing: familyName:
    let
      generatedFamily = generated.${familyName} or null;
      existingFamily = existing.${familyName} or null;
    in
    if builtins.isAttrs generatedFamily || builtins.isAttrs existingFamily then
      {
        ${familyName} =
          (if builtins.isAttrs generatedFamily then generatedFamily else { })
          // (if builtins.isAttrs existingFamily then existingFamily else { });
      }
    else
      { };
  mergeUplink = existingUplinks: uplinkName:
    let
      generated = generatedUplinks.${uplinkName} or { };
      existing = existingUplinks.${uplinkName} or { };
      generatedForMode =
        if (existing.mode or null) == "isolated" then
          builtins.removeAttrs generated [ "parent" "vlan" ]
        else
          generated;
    in
    generatedForMode
    // existing
    // mergeFamily generatedForMode existing "ipv4"
    // mergeFamily generatedForMode existing "ipv6";
  mergeUplinks = existingUplinks:
    let
      names = builtins.attrNames (generatedUplinks // existingUplinks // { management = managementVlan2; });
    in
    normalizeUplinks (
      builtins.listToAttrs (
        builtins.map
          (uplinkName: {
            name = uplinkName;
            value =
              if uplinkName == "management" then
                managementVlan2
              else
                mergeUplink existingUplinks uplinkName;
          })
          names
      )
    );
  uplinkNamesForNode = enterpriseName: siteName: nodeName:
    builtins.sort (left: right: left < right) (builtins.attrNames ((nodeForSite enterpriseName siteName nodeName).uplinks or { }));
  linkNamesForNode = enterpriseName: siteName: nodeName:
    let
      links = linksForSite enterpriseName siteName;
    in
    builtins.filter
      (linkName: builtins.hasAttr nodeName (links.${linkName}.endpoints or { }))
      (builtins.sort (left: right: left < right) (builtins.attrNames links));
  mergeRecursive = left: right:
    let
      commonNames =
        builtins.filter
          (name: builtins.hasAttr name right && builtins.isAttrs left.${name} && builtins.isAttrs right.${name})
          (builtins.attrNames left);
      nested =
        builtins.listToAttrs (
          builtins.map
            (name: {
              inherit name;
              value = mergeRecursive left.${name} right.${name};
            })
            commonNames
        );
    in
    left // right // nested;
  realizationNodeName = enterpriseName: siteName: nodeName:
    sanitize "${enterpriseName}-${siteName}-${nodeName}";
  legacyRealizationNodeName = enterpriseName: siteName: nodeName:
    "${enterpriseName}-${siteName}-${nodeName}";
  existingRealizationNodeFor = enterpriseName: siteName: nodeName:
    let
      nodes = realization.nodes or { };
      legacy = nodes.${legacyRealizationNodeName enterpriseName siteName nodeName} or { };
      canonical = nodes.${realizationNodeName enterpriseName siteName nodeName} or { };
    in
    mergeRecursive legacy canonical;
  existingPortsFor = enterpriseName: siteName: nodeName:
    (existingRealizationNodeFor enterpriseName siteName nodeName).ports or { };
  existingPortHasSelector = enterpriseName: siteName: nodeName: selectorName: selectorValue:
    let
      ports = existingPortsFor enterpriseName siteName nodeName;
    in
    builtins.any
      (portName: (ports.${portName}.${selectorName} or null) == selectorValue)
      (builtins.attrNames ports);
  portForLink = enterpriseName: siteName: nodeName: index: linkName:
    let
      endpoint = (linksForSite enterpriseName siteName).${linkName}.endpoints.${nodeName};
    in
    {
      name = linkName;
      value = {
        link = linkName;
        adapterName = sanitize "${linkName}-${nodeName}";
        attach = {
          kind = "bridge";
          bridge = bridgeForLink linkName;
        };
        interface = {
          name = "p${toString index}";
        }
        // (if endpoint ? addr4 then { addr4 = endpoint.addr4; } else { })
        // (if endpoint ? addr6 then { addr6 = endpoint.addr6; } else { });
      };
    };
  tenantBridgeFor = enterpriseName: siteName: tenantName:
    "br-${sanitize enterpriseName}-${sanitize siteName}-tenant-${sanitize tenantName}";
  portForTenantInterface = enterpriseName: siteName: nodeName: index: interfaceName:
    let
      iface = (nodeForSite enterpriseName siteName nodeName).interfaces.${interfaceName};
      tenantName = iface.tenant;
    in
    {
      name = interfaceName;
      value = {
        logicalInterface = interfaceName;
        attach = {
          kind = "bridge";
          bridge = tenantBridgeFor enterpriseName siteName tenantName;
        };
        interface = {
          name = "t${toString index}";
        };
      };
    };
  portsForNode = enterpriseName: siteName: nodeName:
    let
      existingPorts = existingPortsFor enterpriseName siteName nodeName;
      generatedLinkNames =
        builtins.filter
          (linkName: !(existingPortHasSelector enterpriseName siteName nodeName "link" linkName))
          (linkNamesForNode enterpriseName siteName nodeName);
      generatedTenantInterfaceNames =
        builtins.filter
          (interfaceName: !(existingPortHasSelector enterpriseName siteName nodeName "logicalInterface" interfaceName))
          (tenantInterfaceNamesForNode enterpriseName siteName nodeName);
      generatedUplinkNames =
        builtins.filter
          (uplinkName: !(existingPortHasSelector enterpriseName siteName nodeName "uplink" uplinkName))
          (uplinkNamesForNode enterpriseName siteName nodeName);
      linkPorts = builtins.listToAttrs (
        indexedMap
          (index: linkName: portForLink enterpriseName siteName nodeName index linkName)
          generatedLinkNames
      );
      tenantPorts = builtins.listToAttrs (
        indexedMap
          (index: interfaceName: portForTenantInterface enterpriseName siteName nodeName index interfaceName)
          generatedTenantInterfaceNames
      );
      uplinkPorts = builtins.listToAttrs (
        indexedMap
          (index: uplinkName: {
            name = "uplink-${uplinkName}";
            value = {
              uplink = uplinkName;
              interface = {
                name = "u${toString index}";
              };
            };
          })
          generatedUplinkNames
      );
    in
    mergeRecursive (linkPorts // tenantPorts // uplinkPorts) existingPorts;
  tenantInterfaceNamesForNode = enterpriseName: siteName: nodeName:
    let
      interfaces = (nodeForSite enterpriseName siteName nodeName).interfaces or { };
    in
    builtins.filter
      (interfaceName: (interfaces.${interfaceName}.kind or null) == "tenant")
      (builtins.sort (left: right: left < right) (builtins.attrNames interfaces));
  advertisementEntriesForNode = enterpriseName: siteName: nodeName:
    let
      tenantInterfaceNames = tenantInterfaceNamesForNode enterpriseName siteName nodeName;
    in
    mergeRecursive
      {
        dhcp4 = builtins.listToAttrs (
          builtins.map
            (interfaceName: {
              name = interfaceName;
              value = {
                dnsServers = [ "router-self" ];
                domain = "lan.";
              };
            })
            tenantInterfaceNames
        );
        ipv6Ra = builtins.listToAttrs (
          builtins.map
            (interfaceName: {
              name = interfaceName;
              value = {
                dnssl = [ "lan." ];
                rdnss = [ "router-self" ];
              };
            })
            tenantInterfaceNames
        );
      }
      ((existingRealizationNodeFor enterpriseName siteName nodeName).advertisements or { });
  servicesForNode = enterpriseName: siteName: nodeName:
    let
      generatedDns =
        if tenantInterfaceNamesForNode enterpriseName siteName nodeName == [ ] then
          { }
        else
          {
            dns = { };
          };
    in
    mergeRecursive generatedDns ((existingRealizationNodeFor enterpriseName siteName nodeName).services or { });
  bridgeEntriesForSite = enterpriseName: siteName:
    let
      linkBridgeEntries =
        builtins.map
          (linkName: {
            name = bridgeForLink linkName;
            value = { };
          })
          (builtins.attrNames (linksForSite enterpriseName siteName));
      tenantBridgeEntries =
        builtins.concatMap
          (nodeName:
            builtins.map
              (interfaceName:
                let
                  iface = (nodeForSite enterpriseName siteName nodeName).interfaces.${interfaceName};
                in
                {
                  name = tenantBridgeFor enterpriseName siteName iface.tenant;
                  value = { };
                })
              (tenantInterfaceNamesForNode enterpriseName siteName nodeName))
          (builtins.attrNames ((((forwardingEnterprise.${enterpriseName} or { }).site or { }).${siteName} or { }).nodes or { }));
    in
    linkBridgeEntries ++ tenantBridgeEntries;
  generatedBridgeNetworks =
    builtins.listToAttrs (
      builtins.concatMap
        (enterpriseName:
          builtins.concatMap
            (siteName: bridgeEntriesForSite enterpriseName siteName)
            (builtins.attrNames rowIntent.${enterpriseName}))
        (builtins.attrNames rowIntent)
    );
  uplinkEntriesForSite = enterpriseName: siteName:
    let
      nodes = (((forwardingEnterprise.${enterpriseName} or { }).site or { }).${siteName} or { }).nodes or { };
      names = builtins.concatMap
        (nodeName: uplinkNamesForNode enterpriseName siteName nodeName)
        (builtins.attrNames nodes);
      vlanForUplink = uplinkName:
        if uplinkName == "isp" || builtins.match ".*vlan4$" uplinkName != null then 4
        else if uplinkName == "pppoe-provider" || builtins.match ".*vlan5$" uplinkName != null then 5
        else null;
    in
    builtins.map
      (uplinkName:
        let
          vlan = vlanForUplink uplinkName;
        in
        {
          name = uplinkName;
          value = {
            bridge = uplinkName;
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = if vlan == null then "dhcp" else "vlan";
            parent = "eth0";
          } // (if vlan == null then { } else { inherit vlan; });
        })
      names;
  generatedUplinks =
    builtins.listToAttrs (
      builtins.concatMap
        (enterpriseName:
          builtins.concatMap
            (siteName: uplinkEntriesForSite enterpriseName siteName)
            (builtins.attrNames rowIntent.${enterpriseName}))
        (builtins.attrNames rowIntent)
    );
  mkRealizationNode = enterpriseName: siteName: nodeName: {
    name = sanitize "${enterpriseName}-${siteName}-${nodeName}";
    value = {
      host = "s-router-clab";
      logicalNode = {
        enterprise = enterpriseName;
        site = siteName;
        name = nodeName;
      };
      platform = "nixos-container";
      ports = portsForNode enterpriseName siteName nodeName;
      advertisements = advertisementEntriesForNode enterpriseName siteName nodeName;
      services = servicesForNode enterpriseName siteName nodeName;
    };
  };
  nodesForSite = enterpriseName: siteName:
    let
      site = rowIntent.${enterpriseName}.${siteName};
      nodes = (site.topology or { }).nodes or { };
    in
    builtins.map (nodeName: mkRealizationNode enterpriseName siteName nodeName) (builtins.attrNames nodes);
  generatedRealizationNodes =
    builtins.listToAttrs (
      builtins.concatMap
        (enterpriseName:
          builtins.concatMap
            (siteName: nodesForSite enterpriseName siteName)
            (builtins.attrNames rowIntent.${enterpriseName}))
        (builtins.attrNames rowIntent)
    );
  mergeHost = existing:
    existing // {
      uplinks = mergeUplinks (existing.uplinks or { });
      bridgeNetworks = (existing.bridgeNetworks or { }) // generatedBridgeNetworks;
    };
  managedDeploymentHosts = deploymentHosts // {
    "s-router-clab" = mergeHost (deploymentHosts."s-router-clab" or { });
  };
  managedDeployment = deployment // {
    hosts = (deployment.hosts or { }) // managedDeploymentHosts;
  };
in
source // {
  deploymentHosts = managedDeploymentHosts;
  deployment = managedDeployment;
  realization = realization // {
    nodes = generatedRealizationNodes;
  };
}
