# On-Prem VLAN2 Host Adapter Template

Use this template for controlled GAMP validation work that needs an on-prem host
adapter. It is intentionally minimal so validation stubs do not attach extra
host networks by accident.

Template file:

```text
GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix
```

The template models only the management uplink:

- bridge `vlan2`;
- parent interface `eth0`;
- VLAN ID `2`;
- IPv4 DHCP enabled;
- IPv6, Router Advertisement, DHCPv6, and DHCPv6-PD disabled.

Examples may omit VLAN2. Controlled files under `GAMP/**` must not omit the
VLAN2 host-adapter requirement when they define on-prem validation surfaces.
