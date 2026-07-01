let
  source = import ../GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/inventory-nixos.nix;
  rowIntent = import ../GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix;
  forwardingEnterprise = builtins.fromJSON ''
{"mini-smt":{"site":{"FS-540-HDS-010-SDS-010-SMS-020":{"accessSpaceDiscovery":{"confined":[],"exported":[],"sharedServicePolicyAtoms":[]},"addressPools":{"local":{"ipv4":"10.54.0.0/24","ipv6":"fd42:540:ff::/118"},"p2p":{"ipv4":"10.54.255.0/24","ipv6":"fd42:540:fe::/118"}},"attachments":[{"kind":"tenant","name":"client","unit":"access-dns"}],"communicationContract":{"allowedRelations":[{"action":"allow","from":{"kind":"tenant","name":"client"},"id":"FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns","priority":50,"returnBehavior":"symmetric","to":{"kind":"service","name":"access-dns"},"trafficType":"dns"},{"action":"allow","from":{"kind":"service","name":"access-dns"},"id":"FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet","priority":60,"returnBehavior":"symmetric","to":{"kind":"external","uplinks":["testnet-vlan4"]},"trafficType":"dns"},{"action":"allow","from":{"kind":"tenant","name":"client"},"id":"FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet","priority":100,"returnBehavior":"symmetric","to":{"kind":"external","uplinks":["testnet-vlan4"]},"trafficType":"any"}],"services":[{"name":"access-dns","providers":["access-dns"],"trafficType":"dns"}],"trafficTypes":[{"match":[{"dports":[53],"family":"any","proto":"udp"},{"dports":[53],"family":"any","proto":"tcp"}],"name":"dns"},{"match":[{"family":"any","proto":"any"}],"name":"any"}]},"consumedInterfaces":{"access":[{"access":"access-dns","tenant":"client"}],"clients":[{"access":["access-dns"],"client":"access-dns","tenant":"client"}],"sharedServices":[],"tenants":[{"ipv4":"10.54.10.0/24","ipv6":"fd42:540::/64","name":"client"}]},"coreNodeNames":["resolver-node"],"domains":{"externals":[],"tenants":[{"ipv4":"10.54.10.0/24","ipv6":"fd42:540::/64","name":"client"}]},"egressIntent":{"eligibleNodeNames":["resolver-node","upstream-selector"],"exitNodeNames":["resolver-node"],"explicit":true,"externalDomains":[],"uplinkCoreNodeNames":["resolver-node"],"upstreamSelectorNodeName":"upstream-selector"},"enterprise":"mini-smt","forwardingSemantics":{"coreNodeNames":["resolver-node"],"dns":{"accessNodeNames":["access-dns"],"explicit":true,"nonWanCoreNodeNames":["resolver-node"],"resolverPreferenceNodeNames":["access-dns","resolver-node"],"serviceNodeNames":["access-dns","resolver-node"],"wanFallbackNodeNames":[]},"explicit":true,"nodes":{"access-dns":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","access-gateway","connected-prefix-origin","tenant-edge","traversal-entry"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":true},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":true,"participates":true,"transit":true,"upstreamSelection":false}},"downstream-selector":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","downstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"policy":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","policy-enforcer"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":true,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":true,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"resolver-node":{"egressIntent":{"eligible":true,"exit":true,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["testnet-vlan4"],"upstreamSelection":false,"wanInterfaces":["testnet-vlan4"]},"forwardingFunctions":["router-identity","transit-forwarder","external-egress","uplink-anchor"],"forwardingResponsibility":{"anchorsExternalUplinks":true,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":true,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":true,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"upstream-selector":{"egressIntent":{"eligible":true,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["testnet-vlan4"],"upstreamSelection":true,"wanInterfaces":["testnet-vlan4"]},"forwardingFunctions":["router-identity","transit-forwarder","egress-selector","upstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":true,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":true}}},"policyNodeName":"policy","traversalParticipantNodeNames":["access-dns","downstream-selector","policy","resolver-node","upstream-selector"],"upstreamSelectorNodeName":"upstream-selector"},"hostNatIngress":{},"ipv6":{},"isolationDecisions":[],"links":{"p2p-access-dns-downstream-selector":{"endpoints":{"access-dns":{"addr4":"10.54.255.0/31","addr6":"fd42:540:fe:0:0:0:0:0/127","interface":"p2p-access-dns-downstream-selector","node":"access-dns"},"downstream-selector":{"addr4":"10.54.255.1/31","addr6":"fd42:540:fe:0:0:0:0:1/127","interface":"p2p-access-dns-downstream-selector","node":"downstream-selector"}},"id":"link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-access-dns-downstream-selector","kind":"p2p","lane":"default","laneMeta":{"access":"access-dns","kind":"access-edge","uplink":null,"uplinks":[]},"members":["access-dns","downstream-selector"],"type":"p2p"},"p2p-downstream-selector-policy--access-access-dns":{"endpoints":{"downstream-selector":{"addr4":"10.54.255.2/31","addr6":"fd42:540:fe:0:0:0:0:2/127","interface":"p2p-downstream-selector-policy--access-access-dns","node":"downstream-selector"},"policy":{"addr4":"10.54.255.3/31","addr6":"fd42:540:fe:0:0:0:0:3/127","interface":"p2p-downstream-selector-policy--access-access-dns","node":"policy"}},"id":"link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-downstream-selector-policy--access-access-dns","kind":"p2p","lane":"access::access-dns","laneMeta":{"access":"access-dns","kind":"access","uplink":null,"uplinks":[]},"members":["downstream-selector","policy"],"type":"p2p"},"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4":{"endpoints":{"policy":{"addr4":"10.54.255.4/31","addr6":"fd42:540:fe:0:0:0:0:4/127","interface":"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","node":"policy"},"upstream-selector":{"addr4":"10.54.255.5/31","addr6":"fd42:540:fe:0:0:0:0:5/127","interface":"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","node":"upstream-selector"}},"id":"link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","kind":"p2p","lane":"access::access-dns::uplink::testnet-vlan4","laneMeta":{"access":"access-dns","kind":"access-uplink","uplink":"testnet-vlan4","uplinks":["testnet-vlan4"]},"members":["policy","upstream-selector"],"type":"p2p"},"p2p-resolver-node-upstream-selector":{"endpoints":{"resolver-node":{"addr4":"10.54.255.6/31","addr6":"fd42:540:fe:0:0:0:0:6/127","interface":"p2p-resolver-node-upstream-selector","node":"resolver-node"},"upstream-selector":{"addr4":"10.54.255.7/31","addr6":"fd42:540:fe:0:0:0:0:7/127","interface":"p2p-resolver-node-upstream-selector","node":"upstream-selector"}},"id":"link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-resolver-node-upstream-selector","kind":"p2p","lane":"uplink::testnet-vlan4","laneMeta":{"access":null,"kind":"uplink","uplink":"testnet-vlan4","uplinks":["testnet-vlan4"]},"members":["resolver-node","upstream-selector"],"type":"p2p","uplinks":["testnet-vlan4"]}},"nodes":{"access-dns":{"attachments":[{"kind":"tenant","name":"client"}],"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","access-gateway","connected-prefix-origin","tenant-edge","traversal-entry"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":true},"interfaces":{"p2p-access-dns-downstream-selector":{"acceptRA":false,"addr4":"10.54.255.0/31","addr6":"fd42:540:fe:0:0:0:0:0/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-access-dns-downstream-selector","kind":"p2p","link":"p2p-access-dns-downstream-selector","ll6":null,"name":"p2p-access-dns-downstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.54.255.1"},{"dst":"10.54.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.1"},{"dst":"10.54.0.2/31","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.1"},{"dst":"10.54.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.1"},{"dst":"10.54.255.0/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.54.255.2/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.1"},{"dst":"10.54.255.4/30","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.1"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:540:fe:0:0:0:0:1"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0000/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0002/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:1"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0004/126","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:1"},{"dst":"fd42:0540:00ff:0000:0000:0000:0000:0001/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:1"},{"dst":"fd42:0540:00ff:0000:0000:0000:0000:0002/127","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:1"},{"dst":"fd42:0540:00ff:0000:0000:0000:0000:0004/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:1"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"tenant-client":{"acceptRA":false,"addr4":"10.54.10.1/24","addr6":"fd42:540:0:0:0:0:0:1/64","carrier":"logical","dhcp":false,"gateway":false,"interface":"tenant-client","kind":"tenant","l2":false,"ll6":null,"logical":true,"name":"tenant-client","network":{"ipv4":"10.54.10.0/24","ipv6":"fd42:0540:0000:0000:0000:0000:0000:0000/64","kind":"tenant","name":"client"},"node":"access-dns","overlay":null,"peerAddr4":null,"peerAddr6":null,"routedPrefixes":[],"routes":{"ipv4":[{"dst":"10.54.10.0/24","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0540:0000:0000:0000:0000:0000:0000/64","intent":{"kind":"connected-reachability"},"proto":"connected"}]},"subnet4":"10.54.10.0/24","subnet6":"fd42:0540:0000:0000:0000:0000:0000:0000/64","tenant":"client","type":"logical","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null,"virtual":true}},"loopback":{"ipv4":"10.54.0.0/32","ipv6":"fd42:540:ff:0:0:0:0:0/128"},"networks":{"client":{"ipv4":"10.54.10.0/24","ipv6":"fd42:540::/64","kind":"tenant","name":"client","publicIpv4":null,"ra6Prefixes":[],"routedPrefixes":[]}},"role":"access","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"services":{"dns":{}},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":true,"participates":true,"transit":true,"upstreamSelection":false}},"downstream-selector":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","downstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-access-dns-downstream-selector":{"acceptRA":false,"addr4":"10.54.255.1/31","addr6":"fd42:540:fe:0:0:0:0:1/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-access-dns-downstream-selector","kind":"p2p","link":"p2p-access-dns-downstream-selector","ll6":null,"name":"p2p-access-dns-downstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.54.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.0"},{"dst":"10.54.10.0/24","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.0"},{"dst":"10.54.255.0/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0540:0000:0000:0000:0000:0000:0000/64","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:0"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0000/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:540:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:0"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-downstream-selector-policy--access-access-dns":{"acceptRA":false,"addr4":"10.54.255.2/31","addr6":"fd42:540:fe:0:0:0:0:2/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-downstream-selector-policy--access-access-dns","kind":"p2p","link":"p2p-downstream-selector-policy--access-access-dns","ll6":null,"name":"p2p-downstream-selector-policy--access-access-dns","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.54.255.3"},{"direction":"outbound","dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"lane":{"access":"access-dns","uplink":"testnet-vlan4"},"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet","FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet"],"returnBehavior":"symmetric","via4":"10.54.255.3"},{"dst":"10.54.0.2/31","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.3"},{"dst":"10.54.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.3"},{"dst":"10.54.255.2/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.54.255.4/30","intent":{"accessNode":"policy","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.3"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:540:fe:0:0:0:0:3"},{"direction":"outbound","dst":"::/0","intent":{"kind":"default-reachability"},"lane":{"access":"access-dns","uplink":"testnet-vlan4"},"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet","FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet"],"returnBehavior":"symmetric","via6":"fd42:540:fe:0:0:0:0:3"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0002/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0004/126","intent":{"accessNode":"policy","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:3"},{"dst":"fd42:0540:00ff:0000:0000:0000:0000:0002/127","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:3"},{"dst":"fd42:0540:00ff:0000:0000:0000:0000:0004/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:3"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.54.0.1/32","ipv6":"fd42:540:ff:0:0:0:0:1/128"},"role":"downstream-selector","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"policy":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","policy-enforcer"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":true,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-downstream-selector-policy--access-access-dns":{"acceptRA":false,"addr4":"10.54.255.3/31","addr6":"fd42:540:fe:0:0:0:0:3/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-downstream-selector-policy--access-access-dns","kind":"p2p","link":"p2p-downstream-selector-policy--access-access-dns","ll6":null,"name":"p2p-downstream-selector-policy--access-access-dns","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.54.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.2"},{"dst":"10.54.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.2"},{"dst":"10.54.10.0/24","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.2"},{"dst":"10.54.255.0/31","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.2"},{"dst":"10.54.255.2/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0540:0000:0000:0000:0000:0000:0000/64","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:2"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0000/127","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:2"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0002/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:540:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:2"},{"dst":"fd42:540:ff:0:0:0:0:1/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:2"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4":{"acceptRA":false,"addr4":"10.54.255.4/31","addr6":"fd42:540:fe:0:0:0:0:4/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","kind":"p2p","link":"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","ll6":null,"name":"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.54.255.5"},{"dst":"10.54.0.3/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.5"},{"dst":"10.54.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.5"},{"dst":"10.54.255.4/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.54.255.6/31","intent":{"accessNode":"resolver-node","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.5"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:540:fe:0:0:0:0:5"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0004/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0006/127","intent":{"accessNode":"resolver-node","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:5"},{"dst":"fd42:0540:00ff:0000:0000:0000:0000:0003/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:5"},{"dst":"fd42:0540:00ff:0000:0000:0000:0000:0004/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:5"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.54.0.2/32","ipv6":"fd42:540:ff:0:0:0:0:2/128"},"role":"policy","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":true,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"resolver-node":{"egressIntent":{"eligible":true,"exit":true,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["testnet-vlan4"],"upstreamSelection":false,"wanInterfaces":["testnet-vlan4"]},"forwardingFunctions":["router-identity","transit-forwarder","external-egress","uplink-anchor"],"forwardingResponsibility":{"anchorsExternalUplinks":true,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-resolver-node-upstream-selector":{"acceptRA":false,"addr4":"10.54.255.6/31","addr6":"fd42:540:fe:0:0:0:0:6/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-resolver-node-upstream-selector","kind":"p2p","link":"p2p-resolver-node-upstream-selector","ll6":null,"name":"p2p-resolver-node-upstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.54.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.7"},{"dst":"10.54.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.7"},{"dst":"10.54.0.2/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.7"},{"dst":"10.54.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.7"},{"dst":"10.54.10.0/24","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.7"},{"dst":"10.54.255.0/31","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.7"},{"dst":"10.54.255.2/31","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.7"},{"dst":"10.54.255.4/31","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.7"},{"dst":"10.54.255.6/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0540:0000:0000:0000:0000:0000:0000/64","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:7"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0000/127","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:7"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0002/127","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:7"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0004/127","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:7"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0006/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:540:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:7"},{"dst":"fd42:540:ff:0:0:0:0:1/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:7"},{"dst":"fd42:540:ff:0:0:0:0:2/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:7"},{"dst":"fd42:540:ff:0:0:0:0:4/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:7"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.54.0.3/32","ipv6":"fd42:540:ff:0:0:0:0:3/128"},"role":"core","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":true,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"services":{"dns":{}},"traversalParticipation":{"enforcement":false,"exit":true,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false},"uplinks":{"testnet-vlan4":{"ipv4":["10.20.0.0/24"],"ipv6":["fd42:540:20::/64"]}}},"upstream-selector":{"egressIntent":{"eligible":true,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["testnet-vlan4"],"upstreamSelection":true,"wanInterfaces":["testnet-vlan4"]},"forwardingFunctions":["router-identity","transit-forwarder","egress-selector","upstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4":{"acceptRA":false,"addr4":"10.54.255.5/31","addr6":"fd42:540:fe:0:0:0:0:5/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","kind":"p2p","link":"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","ll6":null,"name":"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.54.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.4"},{"dst":"10.54.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.4"},{"dst":"10.54.0.2/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.4"},{"dst":"10.54.10.0/24","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.4"},{"dst":"10.54.255.0/31","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.4"},{"dst":"10.54.255.2/31","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.4"},{"dst":"10.54.255.4/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0540:0000:0000:0000:0000:0000:0000/64","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:4"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0000/127","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:4"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0002/127","intent":{"accessNode":"access-dns","kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:4"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0004/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:540:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:4"},{"dst":"fd42:540:ff:0:0:0:0:1/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:4"},{"dst":"fd42:540:ff:0:0:0:0:2/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:4"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-resolver-node-upstream-selector":{"acceptRA":false,"addr4":"10.54.255.7/31","addr6":"fd42:540:fe:0:0:0:0:7/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-resolver-node-upstream-selector","kind":"p2p","link":"p2p-resolver-node-upstream-selector","ll6":null,"name":"p2p-resolver-node-upstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.54.255.6"},{"dst":"10.54.0.3/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.54.255.6"},{"dst":"10.54.255.6/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:540:fe:0:0:0:0:6"},{"dst":"fd42:0540:00fe:0000:0000:0000:0000:0006/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0540:00ff:0000:0000:0000:0000:0003/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:540:fe:0:0:0:0:6"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.54.0.4/32","ipv6":"fd42:540:ff:0:0:0:0:4/128"},"role":"upstream-selector","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":true,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":true}}},"overlayAddressPools":{},"overlayAttachments":{},"overlayReachability":{},"ownership":{"endpoints":[{"kind":"host","name":"access-dns","tenant":"client"}],"prefixes":[{"ipv4":"10.54.10.0/24","ipv6":"fd42:540::/64","kind":"tenant","name":"client"}]},"policy":{"interfaceTags":{"client":{"attachments":[{"kind":"tenant","name":"client","unit":"access-dns"}],"domains":[{"ipv4":"10.54.10.0/24","ipv6":"fd42:540::/64","kind":"tenant","name":"client"}]}}},"policyNodeName":"policy","prefixAuthority":{"consumerEligibility":{},"deniedGuaPlacementPreconditions":{},"deniedRouteExportPreconditions":{},"deniedRouteImportConstraints":{},"deniedSpace":{},"guaPlacementPreconditions":{},"records":{"prefix-authority::access-dns::4|10.54.10.0/24":{"authorityClass":"access-subnet-pool","childPurpose":"tenant-or-access-assignment","consumerEligibility":{"advertisement":false,"assignment":true,"exposure":false,"route":true,"translation":false},"family":4,"id":"prefix-authority::access-dns::4|10.54.10.0/24","netName":"client","owner":"access-dns","prefix":"10.54.10.0/24","reservationState":"assigned","scopeKind":"node","scopeName":"access-dns","sourceAuthority":{"kind":"modeled-prefix","owner":"access-dns","prefix":"10.54.10.0/24","routeIdentity":"10.54.10.0/24"}},"prefix-authority::access-dns::6|fd42:0540:0000:0000:0000:0000:0000:0000/64":{"authorityClass":"access-subnet-pool","childPurpose":"tenant-or-access-assignment","consumerEligibility":{"advertisement":false,"assignment":true,"exposure":false,"route":true,"translation":false},"family":6,"id":"prefix-authority::access-dns::6|fd42:0540:0000:0000:0000:0000:0000:0000/64","netName":"client","owner":"access-dns","prefix":"fd42:0540:0000:0000:0000:0000:0000:0000/64","reservationState":"assigned","scopeKind":"node","scopeName":"access-dns","sourceAuthority":{"kind":"modeled-prefix","owner":"access-dns","prefix":"fd42:0540:0000:0000:0000:0000:0000:0000/64","routeIdentity":"fd42:0540:0000:0000:0000:0000:0000:0000/64"}}},"routeExportPreconditions":{},"routeImportConstraints":{}},"publicIpv4DestinationPolicy":{"broadWanDenials":{},"destinationClasses":{},"diagnostics":{},"shortcutAuthorizations":{}},"relations":[{"action":"allow","from":{"kind":"tenant","name":"client"},"match":[{"dports":[53],"family":"any","proto":"udp"},{"dports":[53],"family":"any","proto":"tcp"}],"source":{"id":"FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns","kind":"relation","priority":50,"sourceAudit":{"authority":"network-compiler","outputPath":["relations",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",0]}},"to":{"kind":"service","name":"access-dns"},"trafficType":"dns"},{"action":"allow","from":{"kind":"service","name":"access-dns"},"match":[{"dports":[53],"family":"any","proto":"udp"},{"dports":[53],"family":"any","proto":"tcp"}],"source":{"id":"FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet","kind":"relation","priority":60,"sourceAudit":{"authority":"network-compiler","outputPath":["relations",1],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",1]}},"to":{"kind":"external","uplinks":["testnet-vlan4"]},"trafficType":"dns"},{"action":"allow","from":{"kind":"tenant","name":"client"},"match":[{"dports":[],"family":"any","proto":"any"}],"source":{"id":"FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet","kind":"relation","priority":100,"sourceAudit":{"authority":"network-compiler","outputPath":["relations",2],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",2]}},"to":{"kind":"external","uplinks":["testnet-vlan4"]},"trafficType":"any"}],"services":[{"name":"access-dns","providers":["access-dns"],"trafficType":"dns"}],"siteId":"FS-540-HDS-010-SDS-010-SMS-020","siteName":"mini-smt.FS-540-HDS-010-SDS-010-SMS-020","sourceAudit":{"behavior":[{"authority":"network-compiler","outputPath":["tenants",0],"sourceClass":"user-intent","sourcePath":["segments","tenants","client"]},{"authority":"network-compiler","outputPath":["services",0],"sourceClass":"user-intent","sourcePath":["communicationContract","services","access-dns"]},{"authority":"network-compiler","outputPath":["relations",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",0]},{"authority":"network-compiler","outputPath":["relations",1],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",1]},{"authority":"network-compiler","outputPath":["relations",2],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",2]},{"authority":"network-compiler","outputPath":["trafficPaths",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations","FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns"]},{"authority":"network-compiler","outputPath":["trafficPaths",1],"sourceClass":"user-intent","sourcePath":["communicationContract","relations","FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet"]},{"authority":"network-compiler","outputPath":["trafficPaths",2],"sourceClass":"user-intent","sourcePath":["communicationContract","relations","FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet"]}]},"tenantPrefixOwners":{"4|10.54.10.0/24":{"dst":"10.54.10.0/24","family":4,"netName":"client","owner":"access-dns"},"6|fd42:0540:0000:0000:0000:0000:0000:0000/64":{"dst":"fd42:0540:0000:0000:0000:0000:0000:0000/64","family":6,"netName":"client","owner":"access-dns"}},"tenants":[{"ipv4":"10.54.10.0/24","ipv6":"fd42:540::/64","name":"client"}],"topology":{"links":[["access-dns","downstream-selector"],["downstream-selector","policy"],["policy","upstream-selector"],["upstream-selector","resolver-node"]]},"trafficPathValidation":{"diagnostics":{},"invalidPathCount":0,"invalidPaths":[],"validPathCount":3,"validPaths":[{"action":"allow","corePathNodes":["resolver-node"],"destination":{"kind":"service","name":"access-dns"},"forbidsCoreToCoreP2P":true,"nodePath":["access-dns","downstream-selector","policy","downstream-selector","access-dns"],"nodePathAlternatives":[["access-dns","downstream-selector","policy","downstream-selector","access-dns"]],"p2pIsolationKey":"FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns","relationId":"FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns","requiresPolicy":true,"source":{"kind":"tenant","name":"client"},"stagePath":["access","downstream-selector","policy","downstream-selector","access"],"trafficType":"dns"},{"action":"allow","corePathNodes":["resolver-node"],"destination":{"kind":"external","uplinks":["testnet-vlan4"]},"forbidsCoreToCoreP2P":true,"nodePath":["access-dns","downstream-selector","policy","upstream-selector","resolver-node"],"nodePathAlternatives":[["access-dns","downstream-selector","policy","upstream-selector","resolver-node"]],"p2pIsolationKey":"FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet","relationId":"FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet","requiresPolicy":true,"source":{"kind":"service","name":"access-dns"},"stagePath":["access","downstream-selector","policy","upstream-selector","core"],"trafficType":"dns"},{"action":"allow","corePathNodes":["resolver-node"],"destination":{"kind":"external","uplinks":["testnet-vlan4"]},"forbidsCoreToCoreP2P":true,"nodePath":["access-dns","downstream-selector","policy","upstream-selector","resolver-node"],"nodePathAlternatives":[["access-dns","downstream-selector","policy","upstream-selector","resolver-node"]],"p2pIsolationKey":"FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet","relationId":"FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet","requiresPolicy":true,"source":{"kind":"tenant","name":"client"},"stagePath":["access","downstream-selector","policy","upstream-selector","core"],"trafficType":"any"}]},"trafficPaths":[{"action":"allow","corePathNodes":["resolver-node"],"destination":{"kind":"service","name":"access-dns"},"forbidsCoreToCoreP2P":true,"nodePath":["access-dns","downstream-selector","policy","downstream-selector","access-dns"],"nodePathAlternatives":[["access-dns","downstream-selector","policy","downstream-selector","access-dns"]],"p2pIsolationKey":"FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns","relationId":"FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns","requiresPolicy":true,"source":{"kind":"tenant","name":"client"},"stagePath":["access","downstream-selector","policy","downstream-selector","access"],"trafficType":"dns"},{"action":"allow","corePathNodes":["resolver-node"],"destination":{"kind":"external","uplinks":["testnet-vlan4"]},"forbidsCoreToCoreP2P":true,"nodePath":["access-dns","downstream-selector","policy","upstream-selector","resolver-node"],"nodePathAlternatives":[["access-dns","downstream-selector","policy","upstream-selector","resolver-node"]],"p2pIsolationKey":"FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet","relationId":"FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet","requiresPolicy":true,"source":{"kind":"service","name":"access-dns"},"stagePath":["access","downstream-selector","policy","upstream-selector","core"],"trafficType":"dns"},{"action":"allow","corePathNodes":["resolver-node"],"destination":{"kind":"external","uplinks":["testnet-vlan4"]},"forbidsCoreToCoreP2P":true,"nodePath":["access-dns","downstream-selector","policy","upstream-selector","resolver-node"],"nodePathAlternatives":[["access-dns","downstream-selector","policy","upstream-selector","resolver-node"]],"p2pIsolationKey":"FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet","relationId":"FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet","requiresPolicy":true,"source":{"kind":"tenant","name":"client"},"stagePath":["access","downstream-selector","policy","upstream-selector","core"],"trafficType":"any"}],"transit":{"adjacencies":[{"endpoints":[{"local":{"ipv4":"10.54.255.0","ipv6":"fd42:540:fe:0:0:0:0:0"},"unit":"access-dns"},{"local":{"ipv4":"10.54.255.1","ipv6":"fd42:540:fe:0:0:0:0:1"},"unit":"downstream-selector"}],"id":"link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-access-dns-downstream-selector","kind":"p2p","lane":"default","laneMeta":{"access":"access-dns","kind":"access-edge","uplink":null,"uplinks":[]},"link":"p2p-access-dns-downstream-selector","members":["access-dns","downstream-selector"],"name":"p2p-access-dns-downstream-selector"},{"endpoints":[{"local":{"ipv4":"10.54.255.2","ipv6":"fd42:540:fe:0:0:0:0:2"},"unit":"downstream-selector"},{"local":{"ipv4":"10.54.255.3","ipv6":"fd42:540:fe:0:0:0:0:3"},"unit":"policy"}],"id":"link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-downstream-selector-policy--access-access-dns","kind":"p2p","lane":"access::access-dns","laneMeta":{"access":"access-dns","kind":"access","uplink":null,"uplinks":[]},"link":"p2p-downstream-selector-policy--access-access-dns","members":["downstream-selector","policy"],"name":"p2p-downstream-selector-policy--access-access-dns"},{"endpoints":[{"local":{"ipv4":"10.54.255.4","ipv6":"fd42:540:fe:0:0:0:0:4"},"unit":"policy"},{"local":{"ipv4":"10.54.255.5","ipv6":"fd42:540:fe:0:0:0:0:5"},"unit":"upstream-selector"}],"id":"link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","kind":"p2p","lane":"access::access-dns::uplink::testnet-vlan4","laneMeta":{"access":"access-dns","kind":"access-uplink","uplink":"testnet-vlan4","uplinks":["testnet-vlan4"]},"link":"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","members":["policy","upstream-selector"],"name":"p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4"},{"endpoints":[{"local":{"ipv4":"10.54.255.6","ipv6":"fd42:540:fe:0:0:0:0:6"},"unit":"resolver-node"},{"local":{"ipv4":"10.54.255.7","ipv6":"fd42:540:fe:0:0:0:0:7"},"unit":"upstream-selector"}],"id":"link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-resolver-node-upstream-selector","kind":"p2p","lane":"uplink::testnet-vlan4","laneMeta":{"access":null,"kind":"uplink","uplink":"testnet-vlan4","uplinks":["testnet-vlan4"]},"link":"p2p-resolver-node-upstream-selector","members":["resolver-node","upstream-selector"],"name":"p2p-resolver-node-upstream-selector","uplinks":["testnet-vlan4"]}],"dedicatedLanes":true,"ordering":["link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-access-dns-downstream-selector","link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-downstream-selector-policy--access-access-dns","link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4","link::mini-smt.FS-540-HDS-010-SDS-010-SMS-020::p2p-resolver-node-upstream-selector"]},"uplinkCoreNames":["resolver-node"],"uplinkNames":["testnet-vlan4"],"upstreamSelectorNodeName":"upstream-selector"}}}}
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
  sanitize = value: builtins.replaceStrings [ "." "_" ":" "/" " " ] [ "-" "-" "-" "-" "-" ] value;
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
    in
    generated
    // existing
    // mergeFamily generated existing "ipv4"
    // mergeFamily generated existing "ipv6";
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
      linkPorts = builtins.listToAttrs (
        indexedMap
          (index: linkName: portForLink enterpriseName siteName nodeName index linkName)
          (linkNamesForNode enterpriseName siteName nodeName)
      );
      tenantPorts = builtins.listToAttrs (
        indexedMap
          (index: interfaceName: portForTenantInterface enterpriseName siteName nodeName index interfaceName)
          (tenantInterfaceNamesForNode enterpriseName siteName nodeName)
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
          (uplinkNamesForNode enterpriseName siteName nodeName)
      );
    in
    linkPorts // tenantPorts // uplinkPorts;
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
    };
  servicesForNode = enterpriseName: siteName: nodeName:
    if tenantInterfaceNamesForNode enterpriseName siteName nodeName == [ ] then
      { }
    else
      {
        dns = { };
      };
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
      host = "s-router-nixos";
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
    "s-router-nixos" = mergeHost (deploymentHosts."s-router-nixos" or { });
  };
  managedDeployment = deployment // {
    hosts = (deployment.hosts or { }) // managedDeploymentHosts;
  };
in
source // {
  deploymentHosts = managedDeploymentHosts;
  deployment = managedDeployment;
  realization = realization // {
    nodes = (realization.nodes or { }) // generatedRealizationNodes;
  };
}
