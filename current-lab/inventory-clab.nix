let
  source = import ../GAMP/SMT/FS-060-HDS-010-SDS-010-SMS-010/inventory-clab.nix;
  rowIntent = import ../GAMP/SMT/FS-060-HDS-010-SDS-010-SMS-010/intent.nix;
  forwardingEnterprise = builtins.fromJSON ''
{"mini-smt":{"site":{"FS-060-HDS-010-SDS-010-SMS-010":{"accessSpaceDiscovery":{"confined":[],"exported":[],"sharedServicePolicyAtoms":[]},"addressPools":{"local":{"ipv4":"10.0.0.0/24","ipv6":"fd42:003c:ff::/118"},"p2p":{"ipv4":"10.0.255.0/24","ipv6":"fd42:003c:fe::/118"}},"attachments":[{"kind":"tenant","name":"client","unit":"client-edge"}],"communicationContract":{"allowedRelations":[{"action":"allow","from":{"kind":"tenant","name":"client"},"id":"FS-060-HDS-010-SDS-010-SMS-010__mini-verify","priority":100,"returnBehavior":"symmetric","to":{"kind":"external","uplinks":["testnet"]},"trafficType":"any"}],"services":[],"trafficTypes":[{"match":[{"family":"any","proto":"any"}],"name":"any"}]},"consumedInterfaces":{"access":[{"access":"client-edge","tenant":"client"}],"clients":[],"sharedServices":[],"tenants":[{"ipv4":"10.0.60.0/24","ipv6":"fd42:003c:50::/64","name":"client"}]},"coreNodeNames":["testnet-edge"],"domains":{"externals":[],"tenants":[{"ipv4":"10.0.60.0/24","ipv6":"fd42:003c:50::/64","name":"client"}]},"egressIntent":{"eligibleNodeNames":["testnet-edge","upstream-selector"],"exitNodeNames":["testnet-edge"],"explicit":true,"externalDomains":[],"uplinkCoreNodeNames":["testnet-edge"],"upstreamSelectorNodeName":"upstream-selector"},"enterprise":"mini-smt","forwardingSemantics":{"coreNodeNames":["testnet-edge"],"dns":{"accessNodeNames":["client-edge"],"explicit":true,"nonWanCoreNodeNames":[],"resolverPreferenceNodeNames":["client-edge","testnet-edge"],"serviceNodeNames":["client-edge","testnet-edge"],"wanFallbackNodeNames":["testnet-edge"]},"explicit":true,"nodes":{"client-edge":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","access-gateway","connected-prefix-origin","tenant-edge","traversal-entry"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":true},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":true,"participates":true,"transit":true,"upstreamSelection":false}},"downstream-selector":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","downstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"policy":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","policy-enforcer"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":true,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":true,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"testnet-edge":{"egressIntent":{"eligible":true,"exit":true,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["testnet"],"upstreamSelection":false,"wanInterfaces":["testnet"]},"forwardingFunctions":["router-identity","transit-forwarder","external-egress","uplink-anchor"],"forwardingResponsibility":{"anchorsExternalUplinks":true,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":true,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":true,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"upstream-selector":{"egressIntent":{"eligible":true,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["testnet"],"upstreamSelection":true,"wanInterfaces":["testnet"]},"forwardingFunctions":["router-identity","transit-forwarder","egress-selector","upstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":true,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":true}}},"policyNodeName":"policy","traversalParticipantNodeNames":["client-edge","downstream-selector","policy","testnet-edge","upstream-selector"],"upstreamSelectorNodeName":"upstream-selector"},"hostNatIngress":{},"ipv6":{},"isolationDecisions":[],"links":{"p2p-client-edge-downstream-selector":{"endpoints":{"client-edge":{"addr4":"10.0.255.0/31","addr6":"fd42:3c:fe:0:0:0:0:0/127","interface":"p2p-client-edge-downstream-selector","node":"client-edge"},"downstream-selector":{"addr4":"10.0.255.1/31","addr6":"fd42:3c:fe:0:0:0:0:1/127","interface":"p2p-client-edge-downstream-selector","node":"downstream-selector"}},"id":"link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-client-edge-downstream-selector","kind":"p2p","lane":"default","laneMeta":{"access":"client-edge","kind":"access-edge","uplink":null,"uplinks":[]},"members":["client-edge","downstream-selector"],"type":"p2p"},"p2p-downstream-selector-policy--access-client-edge":{"endpoints":{"downstream-selector":{"addr4":"10.0.255.2/31","addr6":"fd42:3c:fe:0:0:0:0:2/127","interface":"p2p-downstream-selector-policy--access-client-edge","node":"downstream-selector"},"policy":{"addr4":"10.0.255.3/31","addr6":"fd42:3c:fe:0:0:0:0:3/127","interface":"p2p-downstream-selector-policy--access-client-edge","node":"policy"}},"id":"link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-downstream-selector-policy--access-client-edge","kind":"p2p","lane":"access::client-edge","laneMeta":{"access":"client-edge","kind":"access","uplink":null,"uplinks":[]},"members":["downstream-selector","policy"],"type":"p2p"},"p2p-policy-upstream-selector--access-client-edge--uplink-testnet":{"endpoints":{"policy":{"addr4":"10.0.255.4/31","addr6":"fd42:3c:fe:0:0:0:0:4/127","interface":"p2p-policy-upstream-selector--access-client-edge--uplink-testnet","node":"policy"},"upstream-selector":{"addr4":"10.0.255.5/31","addr6":"fd42:3c:fe:0:0:0:0:5/127","interface":"p2p-policy-upstream-selector--access-client-edge--uplink-testnet","node":"upstream-selector"}},"id":"link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-policy-upstream-selector--access-client-edge--uplink-testnet","kind":"p2p","lane":"access::client-edge::uplink::testnet","laneMeta":{"access":"client-edge","kind":"access-uplink","uplink":"testnet","uplinks":["testnet"]},"members":["policy","upstream-selector"],"type":"p2p"},"p2p-testnet-edge-upstream-selector":{"endpoints":{"testnet-edge":{"addr4":"10.0.255.6/31","addr6":"fd42:3c:fe:0:0:0:0:6/127","interface":"p2p-testnet-edge-upstream-selector","node":"testnet-edge"},"upstream-selector":{"addr4":"10.0.255.7/31","addr6":"fd42:3c:fe:0:0:0:0:7/127","interface":"p2p-testnet-edge-upstream-selector","node":"upstream-selector"}},"id":"link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-testnet-edge-upstream-selector","kind":"p2p","lane":"uplink::testnet","laneMeta":{"access":null,"kind":"uplink","uplink":"testnet","uplinks":["testnet"]},"members":["testnet-edge","upstream-selector"],"type":"p2p","uplinks":["testnet"]}},"nodes":{"client-edge":{"attachments":[{"kind":"tenant","name":"client"}],"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","access-gateway","connected-prefix-origin","tenant-edge","traversal-entry"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":true},"interfaces":{"p2p-client-edge-downstream-selector":{"acceptRA":false,"addr4":"10.0.255.0/31","addr6":"fd42:3c:fe:0:0:0:0:0/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-client-edge-downstream-selector","kind":"p2p","link":"p2p-client-edge-downstream-selector","ll6":null,"name":"p2p-client-edge-downstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.0.255.1"},{"dst":"10.0.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.1"},{"dst":"10.0.0.2/31","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.1"},{"dst":"10.0.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.1"},{"dst":"10.0.255.0/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.0.255.2/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.1"},{"dst":"10.0.255.4/30","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.1"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:3c:fe:0:0:0:0:1"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0000/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0002/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:1"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0004/126","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:1"},{"dst":"fd42:003c:00ff:0000:0000:0000:0000:0001/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:1"},{"dst":"fd42:003c:00ff:0000:0000:0000:0000:0002/127","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:1"},{"dst":"fd42:003c:00ff:0000:0000:0000:0000:0004/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:1"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"tenant-client":{"acceptRA":false,"addr4":"10.0.60.1/24","addr6":"fd42:3c:50:0:0:0:0:1/64","carrier":"logical","dhcp":false,"gateway":false,"interface":"tenant-client","kind":"tenant","l2":false,"ll6":null,"logical":true,"name":"tenant-client","network":{"ipv4":"10.0.60.0/24","ipv6":"fd42:003c:0050:0000:0000:0000:0000:0000/64","kind":"tenant","name":"client"},"node":"client-edge","overlay":null,"peerAddr4":null,"peerAddr6":null,"routedPrefixes":[],"routes":{"ipv4":[{"dst":"10.0.60.0/24","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:003c:0050:0000:0000:0000:0000:0000/64","intent":{"kind":"connected-reachability"},"proto":"connected"}]},"subnet4":"10.0.60.0/24","subnet6":"fd42:003c:0050:0000:0000:0000:0000:0000/64","tenant":"client","type":"logical","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null,"virtual":true}},"loopback":{"ipv4":"10.0.0.0/32","ipv6":"fd42:3c:ff:0:0:0:0:0/128"},"networks":{"client":{"ipv4":"10.0.60.0/24","ipv6":"fd42:003c:50::/64","kind":"tenant","name":"client","publicIpv4":null,"ra6Prefixes":[],"routedPrefixes":[]}},"role":"access","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":true,"participates":true,"transit":true,"upstreamSelection":false}},"downstream-selector":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","downstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-client-edge-downstream-selector":{"acceptRA":false,"addr4":"10.0.255.1/31","addr6":"fd42:3c:fe:0:0:0:0:1/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-client-edge-downstream-selector","kind":"p2p","link":"p2p-client-edge-downstream-selector","ll6":null,"name":"p2p-client-edge-downstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.0.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.0"},{"dst":"10.0.255.0/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.0.60.0/24","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.0"}],"ipv6":[{"dst":"fd42:003c:0050:0000:0000:0000:0000:0000/64","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:0"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0000/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:3c:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:0"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-downstream-selector-policy--access-client-edge":{"acceptRA":false,"addr4":"10.0.255.2/31","addr6":"fd42:3c:fe:0:0:0:0:2/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-downstream-selector-policy--access-client-edge","kind":"p2p","link":"p2p-downstream-selector-policy--access-client-edge","ll6":null,"name":"p2p-downstream-selector-policy--access-client-edge","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.0.255.3"},{"direction":"outbound","dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"lane":{"access":"client-edge","uplink":"testnet"},"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-060-HDS-010-SDS-010-SMS-010__mini-verify"],"returnBehavior":"symmetric","via4":"10.0.255.3"},{"dst":"10.0.0.2/31","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.3"},{"dst":"10.0.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.3"},{"dst":"10.0.255.2/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.0.255.4/30","intent":{"accessNode":"policy","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.3"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:3c:fe:0:0:0:0:3"},{"direction":"outbound","dst":"::/0","intent":{"kind":"default-reachability"},"lane":{"access":"client-edge","uplink":"testnet"},"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-060-HDS-010-SDS-010-SMS-010__mini-verify"],"returnBehavior":"symmetric","via6":"fd42:3c:fe:0:0:0:0:3"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0002/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0004/126","intent":{"accessNode":"policy","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:3"},{"dst":"fd42:003c:00ff:0000:0000:0000:0000:0002/127","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:3"},{"dst":"fd42:003c:00ff:0000:0000:0000:0000:0004/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:3"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.0.0.1/32","ipv6":"fd42:3c:ff:0:0:0:0:1/128"},"role":"downstream-selector","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"policy":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","policy-enforcer"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":true,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-downstream-selector-policy--access-client-edge":{"acceptRA":false,"addr4":"10.0.255.3/31","addr6":"fd42:3c:fe:0:0:0:0:3/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-downstream-selector-policy--access-client-edge","kind":"p2p","link":"p2p-downstream-selector-policy--access-client-edge","ll6":null,"name":"p2p-downstream-selector-policy--access-client-edge","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.0.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.2"},{"dst":"10.0.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.2"},{"dst":"10.0.255.0/31","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.2"},{"dst":"10.0.255.2/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.0.60.0/24","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.2"}],"ipv6":[{"dst":"fd42:003c:0050:0000:0000:0000:0000:0000/64","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:2"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0000/127","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:2"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0002/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:3c:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:2"},{"dst":"fd42:3c:ff:0:0:0:0:1/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:2"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-policy-upstream-selector--access-client-edge--uplink-testnet":{"acceptRA":false,"addr4":"10.0.255.4/31","addr6":"fd42:3c:fe:0:0:0:0:4/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-policy-upstream-selector--access-client-edge--uplink-testnet","kind":"p2p","link":"p2p-policy-upstream-selector--access-client-edge--uplink-testnet","ll6":null,"name":"p2p-policy-upstream-selector--access-client-edge--uplink-testnet","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.0.255.5"},{"direction":"outbound","dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"lane":{"access":"client-edge","uplink":"testnet"},"metric":1000,"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-060-HDS-010-SDS-010-SMS-010__mini-verify"],"returnBehavior":"symmetric","via4":"10.0.255.5"},{"dst":"10.0.0.3/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.5"},{"dst":"10.0.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.5"},{"dst":"10.0.255.4/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.0.255.6/31","intent":{"accessNode":"testnet-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.5"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:3c:fe:0:0:0:0:5"},{"direction":"outbound","dst":"::/0","intent":{"kind":"default-reachability"},"lane":{"access":"client-edge","uplink":"testnet"},"metric":1000,"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-060-HDS-010-SDS-010-SMS-010__mini-verify"],"returnBehavior":"symmetric","via6":"fd42:3c:fe:0:0:0:0:5"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0004/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0006/127","intent":{"accessNode":"testnet-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:5"},{"dst":"fd42:003c:00ff:0000:0000:0000:0000:0003/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:5"},{"dst":"fd42:003c:00ff:0000:0000:0000:0000:0004/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:5"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.0.0.2/32","ipv6":"fd42:3c:ff:0:0:0:0:2/128"},"role":"policy","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":true,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"testnet-edge":{"egressIntent":{"eligible":true,"exit":true,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["testnet"],"upstreamSelection":false,"wanInterfaces":["testnet"]},"external":"testnet","forwardingFunctions":["router-identity","transit-forwarder","external-egress","uplink-anchor"],"forwardingResponsibility":{"anchorsExternalUplinks":true,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-testnet-edge-upstream-selector":{"acceptRA":false,"addr4":"10.0.255.6/31","addr6":"fd42:3c:fe:0:0:0:0:6/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-testnet-edge-upstream-selector","kind":"p2p","link":"p2p-testnet-edge-upstream-selector","ll6":null,"name":"p2p-testnet-edge-upstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.0.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.7"},{"dst":"10.0.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.7"},{"dst":"10.0.0.2/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.7"},{"dst":"10.0.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.7"},{"dst":"10.0.255.0/31","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.7"},{"dst":"10.0.255.2/31","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.7"},{"dst":"10.0.255.4/31","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.7"},{"dst":"10.0.255.6/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.0.60.0/24","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.7"}],"ipv6":[{"dst":"fd42:003c:0050:0000:0000:0000:0000:0000/64","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:7"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0000/127","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:7"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0002/127","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:7"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0004/127","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:7"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0006/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:3c:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:7"},{"dst":"fd42:3c:ff:0:0:0:0:1/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:7"},{"dst":"fd42:3c:ff:0:0:0:0:2/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:7"},{"dst":"fd42:3c:ff:0:0:0:0:4/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:7"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.0.0.3/32","ipv6":"fd42:3c:ff:0:0:0:0:3/128"},"role":"core","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":true,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":true,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false},"uplinks":{"testnet":{"ipv4":["0.0.0.0/0"],"ipv6":["::/0"]}}},"upstream-selector":{"egressIntent":{"eligible":true,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["testnet"],"upstreamSelection":true,"wanInterfaces":["testnet"]},"forwardingFunctions":["router-identity","transit-forwarder","egress-selector","upstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-policy-upstream-selector--access-client-edge--uplink-testnet":{"acceptRA":false,"addr4":"10.0.255.5/31","addr6":"fd42:3c:fe:0:0:0:0:5/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-policy-upstream-selector--access-client-edge--uplink-testnet","kind":"p2p","link":"p2p-policy-upstream-selector--access-client-edge--uplink-testnet","ll6":null,"name":"p2p-policy-upstream-selector--access-client-edge--uplink-testnet","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.0.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.4"},{"dst":"10.0.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.4"},{"dst":"10.0.0.2/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.4"},{"dst":"10.0.255.0/31","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.4"},{"dst":"10.0.255.2/31","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.4"},{"dst":"10.0.255.4/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.0.60.0/24","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.4"}],"ipv6":[{"dst":"fd42:003c:0050:0000:0000:0000:0000:0000/64","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:4"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0000/127","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:4"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0002/127","intent":{"accessNode":"client-edge","kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:4"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0004/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:3c:ff:0:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:4"},{"dst":"fd42:3c:ff:0:0:0:0:1/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:4"},{"dst":"fd42:3c:ff:0:0:0:0:2/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:4"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-testnet-edge-upstream-selector":{"acceptRA":false,"addr4":"10.0.255.7/31","addr6":"fd42:3c:fe:0:0:0:0:7/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-testnet-edge-upstream-selector","kind":"p2p","link":"p2p-testnet-edge-upstream-selector","ll6":null,"name":"p2p-testnet-edge-upstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.0.255.6"},{"direction":"outbound","dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"lane":{"access":"client-edge","uplink":"testnet"},"metric":1000,"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-060-HDS-010-SDS-010-SMS-010__mini-verify"],"returnBehavior":"symmetric","via4":"10.0.255.6"},{"dst":"10.0.0.3/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.0.255.6"},{"dst":"10.0.255.6/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:3c:fe:0:0:0:0:6"},{"direction":"outbound","dst":"::/0","intent":{"kind":"default-reachability"},"lane":{"access":"client-edge","uplink":"testnet"},"metric":1000,"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-060-HDS-010-SDS-010-SMS-010__mini-verify"],"returnBehavior":"symmetric","via6":"fd42:3c:fe:0:0:0:0:6"},{"dst":"fd42:003c:00fe:0000:0000:0000:0000:0006/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:003c:00ff:0000:0000:0000:0000:0003/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:3c:fe:0:0:0:0:6"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.0.0.4/32","ipv6":"fd42:3c:ff:0:0:0:0:4/128"},"role":"upstream-selector","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":true,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":true}}},"overlayAddressPools":{},"overlayAttachments":{},"overlayReachability":{},"ownership":{"prefixes":[{"ipv4":"10.0.60.0/24","ipv6":"fd42:003c:50::/64","kind":"tenant","name":"client"}]},"policy":{"interfaceTags":{"client":{"attachments":[{"kind":"tenant","name":"client","unit":"client-edge"}],"domains":[{"ipv4":"10.0.60.0/24","ipv6":"fd42:003c:50::/64","kind":"tenant","name":"client"}]}}},"policyNodeName":"policy","prefixAuthority":{"consumerEligibility":{},"deniedGuaPlacementPreconditions":{},"deniedRouteExportPreconditions":{},"deniedRouteImportConstraints":{},"deniedSpace":{},"guaPlacementPreconditions":{},"records":{"prefix-authority::client-edge::4|10.0.60.0/24":{"authorityClass":"access-subnet-pool","childPurpose":"tenant-or-access-assignment","consumerEligibility":{"advertisement":false,"assignment":true,"exposure":false,"route":true,"translation":false},"family":4,"id":"prefix-authority::client-edge::4|10.0.60.0/24","netName":"client","owner":"client-edge","prefix":"10.0.60.0/24","reservationState":"assigned","scopeKind":"node","scopeName":"client-edge","sourceAuthority":{"kind":"modeled-prefix","owner":"client-edge","prefix":"10.0.60.0/24","routeIdentity":"10.0.60.0/24"}},"prefix-authority::client-edge::6|fd42:003c:0050:0000:0000:0000:0000:0000/64":{"authorityClass":"access-subnet-pool","childPurpose":"tenant-or-access-assignment","consumerEligibility":{"advertisement":false,"assignment":true,"exposure":false,"route":true,"translation":false},"family":6,"id":"prefix-authority::client-edge::6|fd42:003c:0050:0000:0000:0000:0000:0000/64","netName":"client","owner":"client-edge","prefix":"fd42:003c:0050:0000:0000:0000:0000:0000/64","reservationState":"assigned","scopeKind":"node","scopeName":"client-edge","sourceAuthority":{"kind":"modeled-prefix","owner":"client-edge","prefix":"fd42:003c:0050:0000:0000:0000:0000:0000/64","routeIdentity":"fd42:003c:0050:0000:0000:0000:0000:0000/64"}}},"routeExportPreconditions":{},"routeImportConstraints":{}},"publicIpv4DestinationPolicy":{"broadWanDenials":{},"destinationClasses":{},"diagnostics":{},"shortcutAuthorizations":{},"shortcutPolicyDenials":{}},"relations":[{"action":"allow","from":{"kind":"tenant","name":"client"},"match":[{"dports":[],"family":"any","proto":"any"}],"source":{"id":"FS-060-HDS-010-SDS-010-SMS-010__mini-verify","kind":"relation","priority":100,"sourceAudit":{"authority":"network-compiler","outputPath":["relations",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",0]}},"to":{"kind":"external","uplinks":["testnet"]},"trafficType":"any"}],"services":[],"siteId":"FS-060-HDS-010-SDS-010-SMS-010","siteName":"mini-smt.FS-060-HDS-010-SDS-010-SMS-010","sourceAudit":{"behavior":[{"authority":"network-compiler","outputPath":["tenants",0],"sourceClass":"user-intent","sourcePath":["segments","tenants","client"]},{"authority":"network-compiler","outputPath":["relations",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",0]},{"authority":"network-compiler","outputPath":["trafficPaths",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations","FS-060-HDS-010-SDS-010-SMS-010__mini-verify"]}]},"tenantPrefixOwners":{"4|10.0.60.0/24":{"dst":"10.0.60.0/24","family":4,"netName":"client","owner":"client-edge"},"6|fd42:003c:0050:0000:0000:0000:0000:0000/64":{"dst":"fd42:003c:0050:0000:0000:0000:0000:0000/64","family":6,"netName":"client","owner":"client-edge"}},"tenants":[{"ipv4":"10.0.60.0/24","ipv6":"fd42:003c:50::/64","name":"client"}],"topology":{"links":[["client-edge","downstream-selector"],["downstream-selector","policy"],["policy","upstream-selector"],["upstream-selector","testnet-edge"]]},"trafficPathValidation":{"diagnostics":{},"invalidPathCount":0,"invalidPaths":[],"validPathCount":1,"validPaths":[{"action":"allow","corePathNodes":["testnet-edge"],"destination":{"kind":"external","uplinks":["testnet"]},"forbidsCoreToCoreP2P":true,"nodePath":["client-edge","downstream-selector","policy","upstream-selector","testnet-edge"],"nodePathAlternatives":[["client-edge","downstream-selector","policy","upstream-selector","testnet-edge"]],"p2pIsolationKey":"FS-060-HDS-010-SDS-010-SMS-010__mini-verify","relationId":"FS-060-HDS-010-SDS-010-SMS-010__mini-verify","requiresPolicy":true,"source":{"kind":"tenant","name":"client"},"stagePath":["access","downstream-selector","policy","upstream-selector","core"],"trafficType":"any"}]},"trafficPaths":[{"action":"allow","corePathNodes":["testnet-edge"],"destination":{"kind":"external","uplinks":["testnet"]},"forbidsCoreToCoreP2P":true,"nodePath":["client-edge","downstream-selector","policy","upstream-selector","testnet-edge"],"nodePathAlternatives":[["client-edge","downstream-selector","policy","upstream-selector","testnet-edge"]],"p2pIsolationKey":"FS-060-HDS-010-SDS-010-SMS-010__mini-verify","relationId":"FS-060-HDS-010-SDS-010-SMS-010__mini-verify","requiresPolicy":true,"source":{"kind":"tenant","name":"client"},"stagePath":["access","downstream-selector","policy","upstream-selector","core"],"trafficType":"any"}],"transit":{"adjacencies":[{"endpoints":[{"local":{"ipv4":"10.0.255.0","ipv6":"fd42:3c:fe:0:0:0:0:0"},"unit":"client-edge"},{"local":{"ipv4":"10.0.255.1","ipv6":"fd42:3c:fe:0:0:0:0:1"},"unit":"downstream-selector"}],"id":"link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-client-edge-downstream-selector","kind":"p2p","lane":"default","laneMeta":{"access":"client-edge","kind":"access-edge","uplink":null,"uplinks":[]},"link":"p2p-client-edge-downstream-selector","members":["client-edge","downstream-selector"],"name":"p2p-client-edge-downstream-selector"},{"endpoints":[{"local":{"ipv4":"10.0.255.2","ipv6":"fd42:3c:fe:0:0:0:0:2"},"unit":"downstream-selector"},{"local":{"ipv4":"10.0.255.3","ipv6":"fd42:3c:fe:0:0:0:0:3"},"unit":"policy"}],"id":"link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-downstream-selector-policy--access-client-edge","kind":"p2p","lane":"access::client-edge","laneMeta":{"access":"client-edge","kind":"access","uplink":null,"uplinks":[]},"link":"p2p-downstream-selector-policy--access-client-edge","members":["downstream-selector","policy"],"name":"p2p-downstream-selector-policy--access-client-edge"},{"endpoints":[{"local":{"ipv4":"10.0.255.4","ipv6":"fd42:3c:fe:0:0:0:0:4"},"unit":"policy"},{"local":{"ipv4":"10.0.255.5","ipv6":"fd42:3c:fe:0:0:0:0:5"},"unit":"upstream-selector"}],"id":"link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-policy-upstream-selector--access-client-edge--uplink-testnet","kind":"p2p","lane":"access::client-edge::uplink::testnet","laneMeta":{"access":"client-edge","kind":"access-uplink","uplink":"testnet","uplinks":["testnet"]},"link":"p2p-policy-upstream-selector--access-client-edge--uplink-testnet","members":["policy","upstream-selector"],"name":"p2p-policy-upstream-selector--access-client-edge--uplink-testnet"},{"endpoints":[{"local":{"ipv4":"10.0.255.6","ipv6":"fd42:3c:fe:0:0:0:0:6"},"unit":"testnet-edge"},{"local":{"ipv4":"10.0.255.7","ipv6":"fd42:3c:fe:0:0:0:0:7"},"unit":"upstream-selector"}],"id":"link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-testnet-edge-upstream-selector","kind":"p2p","lane":"uplink::testnet","laneMeta":{"access":null,"kind":"uplink","uplink":"testnet","uplinks":["testnet"]},"link":"p2p-testnet-edge-upstream-selector","members":["testnet-edge","upstream-selector"],"name":"p2p-testnet-edge-upstream-selector","uplinks":["testnet"]}],"dedicatedLanes":true,"ordering":["link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-client-edge-downstream-selector","link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-downstream-selector-policy--access-client-edge","link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-policy-upstream-selector--access-client-edge--uplink-testnet","link::mini-smt.FS-060-HDS-010-SDS-010-SMS-010::p2p-testnet-edge-upstream-selector"]},"uplinkCoreNames":["testnet-edge"],"uplinkNames":["testnet"],"upstreamSelectorNodeName":"upstream-selector"}}}}
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
  existingRealizationNodeFor = enterpriseName: siteName: nodeName:
    (realization.nodes or { }).${realizationNodeName enterpriseName siteName nodeName} or { };
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
    mergeRecursive (linkPorts // tenantPorts // uplinkPorts) ((existingRealizationNodeFor enterpriseName siteName nodeName).ports or { });
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
    nodes = (realization.nodes or { }) // generatedRealizationNodes;
  };
}
