let
  source = import ../GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/inventory-nixos.nix;
  rowIntent = import ../GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix;
  forwardingEnterprise = builtins.fromJSON ''
{"mini-smt":{"site":{"provider-access-default-route":{"accessSpaceDiscovery":{"confined":[],"exported":[],"sharedServicePolicyAtoms":[]},"addressPools":{"local":{"ipv4":"10.80.0.0/24","ipv6":"fd42:800:20:ff::/118"},"p2p":{"ipv4":"10.80.255.0/24","ipv6":"fd42:800:20:fe::/118"}},"attachments":[{"kind":"tenant","name":"provider-handoff-a","unit":"provider-handoff-access-a"}],"communicationContract":{"allowedRelations":[{"action":"allow","from":{"kind":"tenant","name":"provider-handoff-a"},"id":"FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet","priority":100,"returnBehavior":"symmetric","to":{"kind":"external","uplinks":["isp"]},"trafficType":"any"}],"services":[],"trafficTypes":[{"match":[{"family":"any","proto":"any"}],"name":"any"}]},"consumedInterfaces":{"access":[{"access":"provider-handoff-access-a","tenant":"provider-handoff-a"}],"clients":[],"sharedServices":[],"tenants":[{"ipv4":"203.0.113.0/24","ipv6":"2001:db8:800:113::/64","name":"provider-handoff-a"}]},"coreNodeNames":["fabric-core","pppoe-core"],"domains":{"externals":[],"tenants":[{"ipv4":"203.0.113.0/24","ipv6":"2001:db8:800:113::/64","name":"provider-handoff-a"}]},"egressIntent":{"eligibleNodeNames":["fabric-core","pppoe-core","upstream-selector"],"exitNodeNames":["fabric-core","pppoe-core"],"explicit":true,"externalDomains":[],"uplinkCoreNodeNames":["fabric-core","pppoe-core"],"upstreamSelectorNodeName":"upstream-selector"},"enterprise":"mini-smt","forwardingSemantics":{"coreNodeNames":["fabric-core","pppoe-core"],"dns":{"accessNodeNames":["provider-handoff-access-a"],"explicit":true,"nonWanCoreNodeNames":[],"resolverPreferenceNodeNames":["provider-handoff-access-a","fabric-core","pppoe-core"],"serviceNodeNames":["fabric-core","pppoe-core","provider-handoff-access-a"],"wanFallbackNodeNames":["fabric-core","pppoe-core"]},"explicit":true,"nodes":{"downstream-selector":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","downstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"fabric-core":{"egressIntent":{"eligible":true,"exit":true,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["isp"],"upstreamSelection":false,"wanInterfaces":["isp"]},"forwardingFunctions":["router-identity","transit-forwarder","external-egress","uplink-anchor"],"forwardingResponsibility":{"anchorsExternalUplinks":true,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":true,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":true,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"policy":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","policy-enforcer"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":true,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":true,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"pppoe-core":{"egressIntent":{"eligible":true,"exit":true,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["pppoe-provider"],"upstreamSelection":false,"wanInterfaces":["pppoe-provider"]},"forwardingFunctions":["router-identity","transit-forwarder","external-egress","uplink-anchor"],"forwardingResponsibility":{"anchorsExternalUplinks":true,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":true,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":true,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"provider-handoff-access-a":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","access-gateway","connected-prefix-origin","tenant-edge","traversal-entry"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":true},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":true,"participates":true,"transit":true,"upstreamSelection":false}},"upstream-selector":{"egressIntent":{"eligible":true,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["isp","pppoe-provider"],"upstreamSelection":true,"wanInterfaces":["isp","pppoe-provider"]},"forwardingFunctions":["router-identity","transit-forwarder","egress-selector","upstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":true,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":true}}},"policyNodeName":"policy","traversalParticipantNodeNames":["downstream-selector","fabric-core","policy","pppoe-core","provider-handoff-access-a","upstream-selector"],"upstreamSelectorNodeName":"upstream-selector"},"hostNatIngress":{},"ipv6":{},"isolationDecisions":[],"links":{"p2p-downstream-selector-policy--access-provider-handoff-access-a":{"endpoints":{"downstream-selector":{"addr4":"10.80.255.0/31","addr6":"fd42:800:20:fe:0:0:0:0/127","interface":"p2p-downstream-selector-policy--access-provider-handoff-access-a","node":"downstream-selector"},"policy":{"addr4":"10.80.255.1/31","addr6":"fd42:800:20:fe:0:0:0:1/127","interface":"p2p-downstream-selector-policy--access-provider-handoff-access-a","node":"policy"}},"id":"link::mini-smt.provider-access-default-route::p2p-downstream-selector-policy--access-provider-handoff-access-a","kind":"p2p","lane":"access::provider-handoff-access-a","laneMeta":{"access":"provider-handoff-access-a","kind":"access","uplink":null,"uplinks":[]},"members":["downstream-selector","policy"],"type":"p2p"},"p2p-downstream-selector-provider-handoff-access-a":{"endpoints":{"downstream-selector":{"addr4":"10.80.255.2/31","addr6":"fd42:800:20:fe:0:0:0:2/127","interface":"p2p-downstream-selector-provider-handoff-access-a","node":"downstream-selector"},"provider-handoff-access-a":{"addr4":"10.80.255.3/31","addr6":"fd42:800:20:fe:0:0:0:3/127","interface":"p2p-downstream-selector-provider-handoff-access-a","node":"provider-handoff-access-a"}},"id":"link::mini-smt.provider-access-default-route::p2p-downstream-selector-provider-handoff-access-a","kind":"p2p","lane":"default","laneMeta":{"access":"provider-handoff-access-a","kind":"access-edge","uplink":null,"uplinks":[]},"members":["downstream-selector","provider-handoff-access-a"],"type":"p2p"},"p2p-fabric-core-upstream-selector":{"endpoints":{"fabric-core":{"addr4":"10.80.255.4/31","addr6":"fd42:800:20:fe:0:0:0:4/127","interface":"p2p-fabric-core-upstream-selector","node":"fabric-core"},"upstream-selector":{"addr4":"10.80.255.5/31","addr6":"fd42:800:20:fe:0:0:0:5/127","interface":"p2p-fabric-core-upstream-selector","node":"upstream-selector"}},"id":"link::mini-smt.provider-access-default-route::p2p-fabric-core-upstream-selector","kind":"p2p","lane":"uplink::isp","laneMeta":{"access":null,"kind":"uplink","uplink":"isp","uplinks":["isp"]},"members":["fabric-core","upstream-selector"],"type":"p2p","uplinks":["isp"]},"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp":{"endpoints":{"policy":{"addr4":"10.80.255.6/31","addr6":"fd42:800:20:fe:0:0:0:6/127","interface":"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","node":"policy"},"upstream-selector":{"addr4":"10.80.255.7/31","addr6":"fd42:800:20:fe:0:0:0:7/127","interface":"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","node":"upstream-selector"}},"id":"link::mini-smt.provider-access-default-route::p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","kind":"p2p","lane":"access::provider-handoff-access-a::uplink::isp","laneMeta":{"access":"provider-handoff-access-a","kind":"access-uplink","uplink":"isp","uplinks":["isp"]},"members":["policy","upstream-selector"],"type":"p2p"},"p2p-pppoe-core-upstream-selector":{"endpoints":{"pppoe-core":{"addr4":"10.80.255.8/31","addr6":"fd42:800:20:fe:0:0:0:8/127","interface":"p2p-pppoe-core-upstream-selector","node":"pppoe-core"},"upstream-selector":{"addr4":"10.80.255.9/31","addr6":"fd42:800:20:fe:0:0:0:9/127","interface":"p2p-pppoe-core-upstream-selector","node":"upstream-selector"}},"id":"link::mini-smt.provider-access-default-route::p2p-pppoe-core-upstream-selector","kind":"p2p","lane":"uplink::pppoe-provider","laneMeta":{"access":null,"kind":"uplink","uplink":"pppoe-provider","uplinks":["pppoe-provider"]},"members":["pppoe-core","upstream-selector"],"type":"p2p","uplinks":["pppoe-provider"]}},"nodes":{"downstream-selector":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","downstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-downstream-selector-policy--access-provider-handoff-access-a":{"acceptRA":false,"addr4":"10.80.255.0/31","addr6":"fd42:800:20:fe:0:0:0:0/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-downstream-selector-policy--access-provider-handoff-access-a","kind":"p2p","link":"p2p-downstream-selector-policy--access-provider-handoff-access-a","ll6":null,"name":"p2p-downstream-selector-policy--access-provider-handoff-access-a","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.80.255.1"},{"direction":"outbound","dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"lane":{"access":"provider-handoff-access-a","uplink":"isp"},"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet"],"returnBehavior":"symmetric","via4":"10.80.255.1"},{"dst":"10.80.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.1"},{"dst":"10.80.0.2/31","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.1"},{"dst":"10.80.0.5/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.1"},{"dst":"10.80.255.0/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.80.255.4/30","intent":{"accessNode":"fabric-core","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.1"},{"dst":"10.80.255.8/31","intent":{"accessNode":"fabric-core","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.1"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:800:20:fe:0:0:0:1"},{"direction":"outbound","dst":"::/0","intent":{"kind":"default-reachability"},"lane":{"access":"provider-handoff-access-a","uplink":"isp"},"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet"],"returnBehavior":"symmetric","via6":"fd42:800:20:fe:0:0:0:1"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0000/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0004/126","intent":{"accessNode":"fabric-core","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:1"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0008/127","intent":{"accessNode":"fabric-core","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:1"},{"dst":"fd42:0800:0020:00ff:0000:0000:0000:0001/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:1"},{"dst":"fd42:0800:0020:00ff:0000:0000:0000:0002/127","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:1"},{"dst":"fd42:0800:0020:00ff:0000:0000:0000:0005/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:1"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-downstream-selector-provider-handoff-access-a":{"acceptRA":false,"addr4":"10.80.255.2/31","addr6":"fd42:800:20:fe:0:0:0:2/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-downstream-selector-provider-handoff-access-a","kind":"p2p","link":"p2p-downstream-selector-provider-handoff-access-a","ll6":null,"name":"p2p-downstream-selector-provider-handoff-access-a","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.80.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.3"},{"dst":"10.80.255.2/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"203.0.113.0/24","intent":{"accessNode":"provider-handoff-access-a","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.3"}],"ipv6":[{"dst":"2001:0db8:0800:0113:0000:0000:0000:0000/64","intent":{"accessNode":"provider-handoff-access-a","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:3"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0002/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:800:20:ff:0:0:0:4/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:3"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.80.0.0/32","ipv6":"fd42:800:20:ff:0:0:0:0/128"},"role":"downstream-selector","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"fabric-core":{"egressIntent":{"eligible":true,"exit":true,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["isp"],"upstreamSelection":false,"wanInterfaces":["isp"]},"forwardingFunctions":["router-identity","transit-forwarder","external-egress","uplink-anchor"],"forwardingResponsibility":{"anchorsExternalUplinks":true,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-fabric-core-upstream-selector":{"acceptRA":false,"addr4":"10.80.255.4/31","addr6":"fd42:800:20:fe:0:0:0:4/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-fabric-core-upstream-selector","kind":"p2p","link":"p2p-fabric-core-upstream-selector","ll6":null,"name":"p2p-fabric-core-upstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.80.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.5"},{"dst":"10.80.0.2/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.5"},{"dst":"10.80.0.3/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.5"},{"dst":"10.80.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.5"},{"dst":"10.80.0.5/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.5"},{"dst":"10.80.255.0/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.5"},{"dst":"10.80.255.2/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.5"},{"dst":"10.80.255.4/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.80.255.6/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.5"},{"dst":"10.80.255.8/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.5"},{"dst":"203.0.113.0/24","intent":{"accessNode":"provider-handoff-access-a","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.5"}],"ipv6":[{"dst":"2001:0db8:0800:0113:0000:0000:0000:0000/64","intent":{"accessNode":"provider-handoff-access-a","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:5"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0000/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:5"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0002/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:5"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0004/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0006/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:5"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0008/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:5"},{"dst":"fd42:800:20:ff:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:5"},{"dst":"fd42:800:20:ff:0:0:0:2/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:5"},{"dst":"fd42:800:20:ff:0:0:0:3/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:5"},{"dst":"fd42:800:20:ff:0:0:0:4/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:5"},{"dst":"fd42:800:20:ff:0:0:0:5/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:5"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.80.0.1/32","ipv6":"fd42:800:20:ff:0:0:0:1/128"},"role":"core","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":true,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":true,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false},"uplinks":{"isp":{"ipv4":["0.0.0.0/0"],"ipv6":["::/0"]}}},"policy":{"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","policy-enforcer"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":true,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-downstream-selector-policy--access-provider-handoff-access-a":{"acceptRA":false,"addr4":"10.80.255.1/31","addr6":"fd42:800:20:fe:0:0:0:1/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-downstream-selector-policy--access-provider-handoff-access-a","kind":"p2p","link":"p2p-downstream-selector-policy--access-provider-handoff-access-a","ll6":null,"name":"p2p-downstream-selector-policy--access-provider-handoff-access-a","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.80.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.0"},{"dst":"10.80.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.0"},{"dst":"10.80.255.0/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.80.255.2/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.0"},{"dst":"203.0.113.0/24","intent":{"accessNode":"provider-handoff-access-a","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.0"}],"ipv6":[{"dst":"2001:0db8:0800:0113:0000:0000:0000:0000/64","intent":{"accessNode":"provider-handoff-access-a","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:0"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0000/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0002/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:0"},{"dst":"fd42:800:20:ff:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:0"},{"dst":"fd42:800:20:ff:0:0:0:4/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:0"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp":{"acceptRA":false,"addr4":"10.80.255.6/31","addr6":"fd42:800:20:fe:0:0:0:6/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","kind":"p2p","link":"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","ll6":null,"name":"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.80.255.7"},{"direction":"outbound","dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"lane":{"access":"provider-handoff-access-a","uplink":"isp"},"metric":1000,"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet"],"returnBehavior":"symmetric","via4":"10.80.255.7"},{"dst":"10.80.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.7"},{"dst":"10.80.0.3/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.7"},{"dst":"10.80.0.5/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.7"},{"dst":"10.80.255.4/31","intent":{"accessNode":"fabric-core","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.7"},{"dst":"10.80.255.6/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.80.255.8/31","intent":{"accessNode":"fabric-core","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.7"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:800:20:fe:0:0:0:7"},{"direction":"outbound","dst":"::/0","intent":{"kind":"default-reachability"},"lane":{"access":"provider-handoff-access-a","uplink":"isp"},"metric":1000,"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet"],"returnBehavior":"symmetric","via6":"fd42:800:20:fe:0:0:0:7"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0004/127","intent":{"accessNode":"fabric-core","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:7"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0006/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0008/127","intent":{"accessNode":"fabric-core","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:7"},{"dst":"fd42:0800:0020:00ff:0000:0000:0000:0001/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:7"},{"dst":"fd42:0800:0020:00ff:0000:0000:0000:0003/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:7"},{"dst":"fd42:0800:0020:00ff:0000:0000:0000:0005/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:7"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.80.0.2/32","ipv6":"fd42:800:20:ff:0:0:0:2/128"},"role":"policy","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":true,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false}},"pppoe-core":{"egressIntent":{"eligible":true,"exit":true,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["pppoe-provider"],"upstreamSelection":false,"wanInterfaces":["pppoe-provider"]},"forwardingFunctions":["router-identity","transit-forwarder","external-egress","uplink-anchor"],"forwardingResponsibility":{"anchorsExternalUplinks":true,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-pppoe-core-upstream-selector":{"acceptRA":false,"addr4":"10.80.255.8/31","addr6":"fd42:800:20:fe:0:0:0:8/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-pppoe-core-upstream-selector","kind":"p2p","link":"p2p-pppoe-core-upstream-selector","ll6":null,"name":"p2p-pppoe-core-upstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.80.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.9"},{"dst":"10.80.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.9"},{"dst":"10.80.0.2/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.9"},{"dst":"10.80.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.9"},{"dst":"10.80.0.5/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.9"},{"dst":"10.80.255.0/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.9"},{"dst":"10.80.255.2/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.9"},{"dst":"10.80.255.4/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.9"},{"dst":"10.80.255.6/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.9"},{"dst":"10.80.255.8/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0000/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:9"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0002/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:9"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0004/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:9"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0006/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:9"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0008/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:800:20:ff:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:9"},{"dst":"fd42:800:20:ff:0:0:0:1/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:9"},{"dst":"fd42:800:20:ff:0:0:0:2/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:9"},{"dst":"fd42:800:20:ff:0:0:0:4/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:9"},{"dst":"fd42:800:20:ff:0:0:0:5/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:9"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.80.0.3/32","ipv6":"fd42:800:20:ff:0:0:0:3/128"},"role":"core","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":true,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":true,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":false},"uplinks":{"pppoe-provider":{"ipv4":["0.0.0.0/0"],"ipv6":["::/0"]}}},"provider-handoff-access-a":{"attachments":[{"kind":"tenant","name":"provider-handoff-a"}],"egressIntent":{"eligible":false,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":[],"upstreamSelection":false,"wanInterfaces":[]},"forwardingFunctions":["router-identity","transit-forwarder","access-gateway","connected-prefix-origin","tenant-edge","traversal-entry"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":false,"terminatesOverlays":false,"terminatesTenants":true},"interfaces":{"p2p-downstream-selector-provider-handoff-access-a":{"acceptRA":false,"addr4":"10.80.255.3/31","addr6":"fd42:800:20:fe:0:0:0:3/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-downstream-selector-provider-handoff-access-a","kind":"p2p","link":"p2p-downstream-selector-provider-handoff-access-a","ll6":null,"name":"p2p-downstream-selector-provider-handoff-access-a","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.80.255.2"},{"dst":"10.80.0.0/30","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.2"},{"dst":"10.80.0.5/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.2"},{"dst":"10.80.255.0/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.2"},{"dst":"10.80.255.2/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"10.80.255.4/30","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.2"},{"dst":"10.80.255.8/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.2"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:800:20:fe:0:0:0:2"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0000/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:2"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0002/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0004/126","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:2"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0008/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:2"},{"dst":"fd42:0800:0020:00ff:0000:0000:0000:0000/126","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:2"},{"dst":"fd42:0800:0020:00ff:0000:0000:0000:0005/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:2"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"tenant-provider-handoff-a":{"acceptRA":false,"addr4":"203.0.113.1/24","addr6":"2001:db8:800:113:0:0:0:1/64","carrier":"logical","dhcp":false,"gateway":false,"interface":"tenant-provider-handoff-a","kind":"tenant","l2":false,"ll6":null,"logical":true,"name":"tenant-provider-handoff-a","network":{"ipv4":"203.0.113.0/24","ipv6":"2001:0db8:0800:0113:0000:0000:0000:0000/64","kind":"tenant","name":"provider-handoff-a"},"node":"provider-handoff-access-a","overlay":null,"peerAddr4":null,"peerAddr6":null,"routedPrefixes":[],"routes":{"ipv4":[{"dst":"203.0.113.0/24","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"2001:0db8:0800:0113:0000:0000:0000:0000/64","intent":{"kind":"connected-reachability"},"proto":"connected"}]},"subnet4":"203.0.113.0/24","subnet6":"2001:0db8:0800:0113:0000:0000:0000:0000/64","tenant":"provider-handoff-a","type":"logical","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null,"virtual":true}},"loopback":{"ipv4":"10.80.0.4/32","ipv6":"fd42:800:20:ff:0:0:0:4/128"},"networks":{"provider-handoff-a":{"ipv4":"203.0.113.0/24","ipv6":"2001:db8:800:113::/64","kind":"tenant","name":"provider-handoff-a","publicIpv4":null,"ra6Prefixes":[],"routedPrefixes":[]}},"role":"access","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":false,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":true,"participates":true,"transit":true,"upstreamSelection":false}},"upstream-selector":{"egressIntent":{"eligible":true,"exit":false,"explicit":true,"externalDomains":[],"nat44":{},"nat66":{},"uplinks":["isp","pppoe-provider"],"upstreamSelection":true,"wanInterfaces":["isp","pppoe-provider"]},"forwardingFunctions":["router-identity","transit-forwarder","egress-selector","upstream-selector"],"forwardingResponsibility":{"anchorsExternalUplinks":false,"carriesTransit":true,"enforcesPolicy":false,"explicit":true,"participatesInUpstreamSelection":true,"terminatesOverlays":false,"terminatesTenants":false},"interfaces":{"p2p-fabric-core-upstream-selector":{"acceptRA":false,"addr4":"10.80.255.5/31","addr6":"fd42:800:20:fe:0:0:0:5/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-fabric-core-upstream-selector","kind":"p2p","link":"p2p-fabric-core-upstream-selector","ll6":null,"name":"p2p-fabric-core-upstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"proto":"default","via4":"10.80.255.4"},{"direction":"outbound","dst":"0.0.0.0/0","intent":{"kind":"default-reachability"},"lane":{"access":"provider-handoff-access-a","uplink":"isp"},"metric":1000,"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet"],"returnBehavior":"symmetric","via4":"10.80.255.4"},{"dst":"10.80.0.1/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.4"},{"dst":"10.80.255.4/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"::/0","intent":{"kind":"default-reachability"},"proto":"default","via6":"fd42:800:20:fe:0:0:0:4"},{"direction":"outbound","dst":"::/0","intent":{"kind":"default-reachability"},"lane":{"access":"provider-handoff-access-a","uplink":"isp"},"metric":1000,"policyOnly":true,"proto":"default","reason":"policy-derived-default","relationIds":["FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet"],"returnBehavior":"symmetric","via6":"fd42:800:20:fe:0:0:0:4"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0004/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:0800:0020:00ff:0000:0000:0000:0001/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:4"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp":{"acceptRA":false,"addr4":"10.80.255.7/31","addr6":"fd42:800:20:fe:0:0:0:7/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","kind":"p2p","link":"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","ll6":null,"name":"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.80.0.0/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.6"},{"dst":"10.80.0.2/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.6"},{"dst":"10.80.0.4/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.6"},{"dst":"10.80.255.0/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.6"},{"dst":"10.80.255.2/31","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.6"},{"dst":"10.80.255.6/31","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"203.0.113.0/24","intent":{"accessNode":"provider-handoff-access-a","kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.6"}],"ipv6":[{"dst":"2001:0db8:0800:0113:0000:0000:0000:0000/64","intent":{"accessNode":"provider-handoff-access-a","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:6"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0000/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:6"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0002/127","intent":{"accessNode":"downstream-selector","kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:6"},{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0006/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:800:20:ff:0:0:0:0/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:6"},{"dst":"fd42:800:20:ff:0:0:0:2/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:6"},{"dst":"fd42:800:20:ff:0:0:0:4/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:6"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null},"p2p-pppoe-core-upstream-selector":{"acceptRA":false,"addr4":"10.80.255.9/31","addr6":"fd42:800:20:fe:0:0:0:9/127","carrier":"lan","dhcp":false,"gateway":false,"interface":"p2p-pppoe-core-upstream-selector","kind":"p2p","link":"p2p-pppoe-core-upstream-selector","ll6":null,"name":"p2p-pppoe-core-upstream-selector","overlay":null,"peerAddr4":null,"peerAddr6":null,"routes":{"ipv4":[{"dst":"10.80.0.3/32","intent":{"kind":"internal-reachability"},"proto":"internal","via4":"10.80.255.8"},{"dst":"10.80.255.8/31","intent":{"kind":"connected-reachability"},"proto":"connected"}],"ipv6":[{"dst":"fd42:0800:0020:00fe:0000:0000:0000:0008/127","intent":{"kind":"connected-reachability"},"proto":"connected"},{"dst":"fd42:800:20:ff:0:0:0:3/128","intent":{"kind":"internal-reachability"},"proto":"internal","via6":"fd42:800:20:fe:0:0:0:8"}]},"tenant":null,"type":"p2p","uplink":null,"uplinkRoutes4":[],"uplinkRoutes6":[],"upstream":null}},"loopback":{"ipv4":"10.80.0.5/32","ipv6":"fd42:800:20:ff:0:0:0:5/128"},"role":"upstream-selector","routingAuthority":{"connectedReachability":true,"defaultReachability":false,"exitsSite":false,"explicit":true,"internalReachability":true,"overlayReachability":false,"selectsUpstream":true,"uplinkLearnedReachability":false},"traversalParticipation":{"enforcement":false,"exit":false,"explicit":true,"ingress":false,"participates":true,"transit":true,"upstreamSelection":true}}},"overlayAddressPools":{},"overlayAttachments":{},"overlayReachability":{},"ownership":{"prefixes":[{"ipv4":"203.0.113.0/24","ipv6":"2001:db8:800:113::/64","kind":"tenant","name":"provider-handoff-a"}]},"policy":{"interfaceTags":{"provider-handoff-a":{"attachments":[{"kind":"tenant","name":"provider-handoff-a","unit":"provider-handoff-access-a"}],"domains":[{"ipv4":"203.0.113.0/24","ipv6":"2001:db8:800:113::/64","kind":"tenant","name":"provider-handoff-a"}]}}},"policyNodeName":"policy","prefixAuthority":{"consumerEligibility":{},"deniedGuaPlacementPreconditions":{},"deniedRouteExportPreconditions":{},"deniedRouteImportConstraints":{},"deniedSpace":{},"guaPlacementPreconditions":{},"records":{"prefix-authority::provider-handoff-access-a::4|203.0.113.0/24":{"authorityClass":"access-subnet-pool","childPurpose":"tenant-or-access-assignment","consumerEligibility":{"advertisement":false,"assignment":true,"exposure":false,"route":true,"translation":false},"family":4,"id":"prefix-authority::provider-handoff-access-a::4|203.0.113.0/24","netName":"provider-handoff-a","owner":"provider-handoff-access-a","prefix":"203.0.113.0/24","reservationState":"assigned","scopeKind":"node","scopeName":"provider-handoff-access-a","sourceAuthority":{"kind":"modeled-prefix","owner":"provider-handoff-access-a","prefix":"203.0.113.0/24","routeIdentity":"203.0.113.0/24"}},"prefix-authority::provider-handoff-access-a::6|2001:0db8:0800:0113:0000:0000:0000:0000/64":{"authorityClass":"access-subnet-pool","childPurpose":"tenant-or-access-assignment","consumerEligibility":{"advertisement":false,"assignment":true,"exposure":false,"route":true,"translation":false},"family":6,"id":"prefix-authority::provider-handoff-access-a::6|2001:0db8:0800:0113:0000:0000:0000:0000/64","netName":"provider-handoff-a","owner":"provider-handoff-access-a","prefix":"2001:0db8:0800:0113:0000:0000:0000:0000/64","reservationState":"assigned","scopeKind":"node","scopeName":"provider-handoff-access-a","sourceAuthority":{"kind":"modeled-prefix","owner":"provider-handoff-access-a","prefix":"2001:0db8:0800:0113:0000:0000:0000:0000/64","routeIdentity":"2001:0db8:0800:0113:0000:0000:0000:0000/64"}}},"routeExportPreconditions":{},"routeImportConstraints":{}},"publicIpv4DestinationPolicy":{"broadWanDenials":{},"destinationClasses":{"public-ipv4-destination::203.0.113.0":{"address":"203.0.113.0","destinationClass":"enterprise-client","family":4,"genericWanInternet":false,"id":"public-ipv4-destination::203.0.113.0","modelOwned":true,"ownerKind":"tenant","ownerName":"provider-handoff-a","publicIngress":false,"serviceName":null,"source":"domains.tenants"},"public-ipv4-destination::203.0.113.1":{"address":"203.0.113.1","destinationClass":"locally-owned-routed","family":4,"genericWanInternet":false,"id":"public-ipv4-destination::203.0.113.1","modelOwned":true,"ownerKind":"interface","ownerName":"provider-handoff-access-a.tenant-provider-handoff-a","publicIngress":false,"serviceName":null,"source":"nodes.interfaces"}},"diagnostics":{},"shortcutAuthorizations":{}},"relations":[{"action":"allow","from":{"kind":"tenant","name":"provider-handoff-a"},"match":[{"dports":[],"family":"any","proto":"any"}],"source":{"id":"FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet","kind":"relation","priority":100,"sourceAudit":{"authority":"network-compiler","outputPath":["relations",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",0]}},"to":{"kind":"external","uplinks":["isp"]},"trafficType":"any"}],"services":[],"siteId":"provider-access-default-route","siteName":"mini-smt.provider-access-default-route","sourceAudit":{"behavior":[{"authority":"network-compiler","outputPath":["tenants",0],"sourceClass":"user-intent","sourcePath":["segments","tenants","provider-handoff-a"]},{"authority":"network-compiler","outputPath":["relations",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations",0]},{"authority":"network-compiler","outputPath":["trafficPaths",0],"sourceClass":"user-intent","sourcePath":["communicationContract","relations","FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet"]}]},"tenantPrefixOwners":{"4|203.0.113.0/24":{"dst":"203.0.113.0/24","family":4,"netName":"provider-handoff-a","owner":"provider-handoff-access-a"},"6|2001:0db8:0800:0113:0000:0000:0000:0000/64":{"dst":"2001:0db8:0800:0113:0000:0000:0000:0000/64","family":6,"netName":"provider-handoff-a","owner":"provider-handoff-access-a"}},"tenants":[{"ipv4":"203.0.113.0/24","ipv6":"2001:db8:800:113::/64","name":"provider-handoff-a"}],"topology":{"links":[["provider-handoff-access-a","downstream-selector"],["downstream-selector","policy"],["policy","upstream-selector"],["upstream-selector","fabric-core"],["upstream-selector","pppoe-core"]]},"trafficPathValidation":{"diagnostics":{},"invalidPathCount":0,"invalidPaths":[],"validPathCount":1,"validPaths":[{"action":"allow","corePathNodes":["fabric-core"],"destination":{"kind":"external","uplinks":["isp"]},"forbidsCoreToCoreP2P":true,"nodePath":["provider-handoff-access-a","downstream-selector","policy","upstream-selector","fabric-core"],"nodePathAlternatives":[["provider-handoff-access-a","downstream-selector","policy","upstream-selector","fabric-core"]],"p2pIsolationKey":"FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet","relationId":"FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet","requiresPolicy":true,"source":{"kind":"tenant","name":"provider-handoff-a"},"stagePath":["access","downstream-selector","policy","upstream-selector","core"],"trafficType":"any"}]},"trafficPaths":[{"action":"allow","corePathNodes":["fabric-core"],"destination":{"kind":"external","uplinks":["isp"]},"forbidsCoreToCoreP2P":true,"nodePath":["provider-handoff-access-a","downstream-selector","policy","upstream-selector","fabric-core"],"nodePathAlternatives":[["provider-handoff-access-a","downstream-selector","policy","upstream-selector","fabric-core"]],"p2pIsolationKey":"FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet","relationId":"FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet","requiresPolicy":true,"source":{"kind":"tenant","name":"provider-handoff-a"},"stagePath":["access","downstream-selector","policy","upstream-selector","core"],"trafficType":"any"}],"transit":{"adjacencies":[{"endpoints":[{"local":{"ipv4":"10.80.255.0","ipv6":"fd42:800:20:fe:0:0:0:0"},"unit":"downstream-selector"},{"local":{"ipv4":"10.80.255.1","ipv6":"fd42:800:20:fe:0:0:0:1"},"unit":"policy"}],"id":"link::mini-smt.provider-access-default-route::p2p-downstream-selector-policy--access-provider-handoff-access-a","kind":"p2p","lane":"access::provider-handoff-access-a","laneMeta":{"access":"provider-handoff-access-a","kind":"access","uplink":null,"uplinks":[]},"link":"p2p-downstream-selector-policy--access-provider-handoff-access-a","members":["downstream-selector","policy"],"name":"p2p-downstream-selector-policy--access-provider-handoff-access-a"},{"endpoints":[{"local":{"ipv4":"10.80.255.2","ipv6":"fd42:800:20:fe:0:0:0:2"},"unit":"downstream-selector"},{"local":{"ipv4":"10.80.255.3","ipv6":"fd42:800:20:fe:0:0:0:3"},"unit":"provider-handoff-access-a"}],"id":"link::mini-smt.provider-access-default-route::p2p-downstream-selector-provider-handoff-access-a","kind":"p2p","lane":"default","laneMeta":{"access":"provider-handoff-access-a","kind":"access-edge","uplink":null,"uplinks":[]},"link":"p2p-downstream-selector-provider-handoff-access-a","members":["downstream-selector","provider-handoff-access-a"],"name":"p2p-downstream-selector-provider-handoff-access-a"},{"endpoints":[{"local":{"ipv4":"10.80.255.4","ipv6":"fd42:800:20:fe:0:0:0:4"},"unit":"fabric-core"},{"local":{"ipv4":"10.80.255.5","ipv6":"fd42:800:20:fe:0:0:0:5"},"unit":"upstream-selector"}],"id":"link::mini-smt.provider-access-default-route::p2p-fabric-core-upstream-selector","kind":"p2p","lane":"uplink::isp","laneMeta":{"access":null,"kind":"uplink","uplink":"isp","uplinks":["isp"]},"link":"p2p-fabric-core-upstream-selector","members":["fabric-core","upstream-selector"],"name":"p2p-fabric-core-upstream-selector","uplinks":["isp"]},{"endpoints":[{"local":{"ipv4":"10.80.255.6","ipv6":"fd42:800:20:fe:0:0:0:6"},"unit":"policy"},{"local":{"ipv4":"10.80.255.7","ipv6":"fd42:800:20:fe:0:0:0:7"},"unit":"upstream-selector"}],"id":"link::mini-smt.provider-access-default-route::p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","kind":"p2p","lane":"access::provider-handoff-access-a::uplink::isp","laneMeta":{"access":"provider-handoff-access-a","kind":"access-uplink","uplink":"isp","uplinks":["isp"]},"link":"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","members":["policy","upstream-selector"],"name":"p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp"},{"endpoints":[{"local":{"ipv4":"10.80.255.8","ipv6":"fd42:800:20:fe:0:0:0:8"},"unit":"pppoe-core"},{"local":{"ipv4":"10.80.255.9","ipv6":"fd42:800:20:fe:0:0:0:9"},"unit":"upstream-selector"}],"id":"link::mini-smt.provider-access-default-route::p2p-pppoe-core-upstream-selector","kind":"p2p","lane":"uplink::pppoe-provider","laneMeta":{"access":null,"kind":"uplink","uplink":"pppoe-provider","uplinks":["pppoe-provider"]},"link":"p2p-pppoe-core-upstream-selector","members":["pppoe-core","upstream-selector"],"name":"p2p-pppoe-core-upstream-selector","uplinks":["pppoe-provider"]}],"dedicatedLanes":true,"ordering":["link::mini-smt.provider-access-default-route::p2p-downstream-selector-provider-handoff-access-a","link::mini-smt.provider-access-default-route::p2p-downstream-selector-policy--access-provider-handoff-access-a","link::mini-smt.provider-access-default-route::p2p-policy-upstream-selector--access-provider-handoff-access-a--uplink-isp","link::mini-smt.provider-access-default-route::p2p-fabric-core-upstream-selector","link::mini-smt.provider-access-default-route::p2p-pppoe-core-upstream-selector"]},"uplinkCoreNames":["fabric-core","pppoe-core"],"uplinkNames":["isp","pppoe-provider"],"upstreamSelectorNodeName":"upstream-selector"}}}}
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
