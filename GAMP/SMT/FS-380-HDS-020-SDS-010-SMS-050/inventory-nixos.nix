let
  pppoeHandoffInterface = "pppoe-handoff-client-edge-emulated-isp";
  pppoeHandoffBridge = "br-${pppoeHandoffInterface}";
  pppoeCredentials = {
    labOnly = true;
    usernameFile = "/run/secrets/hat-pppoe-username";
    passwordFile = "/run/secrets/hat-pppoe-password";
  };
  pppoeRealization = {
    mini-smt-FS-380-HDS-020-SDS-010-SMS-050-client-edge = {
      ports.${pppoeHandoffInterface} = {
        serviceInterface = pppoeHandoffInterface;
        adapterName = "${pppoeHandoffInterface}-client-edge";
        attach = {
          kind = "bridge";
          bridge = pppoeHandoffBridge;
        };
        interface.name = "pppoe0";
      };
      services.pppoe.client = {
        interface = pppoeHandoffInterface;
        runtimeInterface = "ppp0";
        credentials = pppoeCredentials;
        defaultRoute = true;
        mtu = 1492;
        usePeerDns = true;
      };
    };
    mini-smt-FS-380-HDS-020-SDS-010-SMS-050-emulated-isp = {
      ports.${pppoeHandoffInterface} = {
        serviceInterface = pppoeHandoffInterface;
        adapterName = "${pppoeHandoffInterface}-emulated-isp";
        attach = {
          kind = "bridge";
          bridge = pppoeHandoffBridge;
        };
        interface.name = "pppoe0";
      };
      advertisements = {
        dhcp4.${pppoeHandoffInterface}.enabled = false;
        ipv6Ra.${pppoeHandoffInterface}.enabled = false;
      };
      services.pppoe.server = {
        interface = pppoeHandoffInterface;
        credentials = pppoeCredentials;
        customerAddress = "203.0.113.10";
        implementation = "rp-pppoe";
        maxSessions = 32;
        mtu = 1492;
        providerAddress = "203.0.113.9";
      };
    };
  };
  internetUplinks = {
    isp = {
      bridge = "isp";
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
      mode = "vlan";
      parent = "eth0";
      vlan = 4;
    };
    pppoe-provider = {
      bridge = "pppoe-provider";
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
      mode = "vlan";
      parent = "eth0";
      vlan = 5;
    };
  };
in
{
  meta = {
    traceId = "FS-380-HDS-020-SDS-010-SMS-050";
    scope = "internet-mode-emulated-isp";
  };
  hosts = { };
  deploymentHosts = {
    s-router-nixos = {
      accessHandoff = {
        kind = "pppoe";
        server = "emulated-isp";
      };
      bridgeNetworks = {
        admin = { };
        branch = { };
        client = { };
        testnet = {
          hostAddresses = ["10.11.0.1/24"];
        };
        ${pppoeHandoffBridge} = { };
      };
      uplinks = internetUplinks;
    };
  };
  realization.nodes = pppoeRealization;
}
