{
  layer = "SMT";
  traceId = "FS-470-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-470-HDS-010-SDS-010-SMS-010-wireguard-remote-egress.md";
  titleSlug = "wireguard-remote-egress";
  source = {
    kind = "renderer-input";
    sourcePath = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/renderer-input/wireguard-remote-egress-cpm.nix";
    inventories = {
      clab = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "active-lab renderer-input mini SMT/SIT";
  };
  status = "OK";
  evidence = {
    observedResult = "2026-07-01: focused runner evaluates the row-local CPM renderer input with network-renderer-wireguard hostModule and proves provider runtime import, NAT44/NAT66, DHCPv4, RA/RDNSS, bootstrap separation, and row-local SOPS private-key binding. Active-lab selector and empty host artifacts use the full FS-470-HDS-010-SDS-010-SMS-010 trace ID. Live host evidence is recorded at the NCA SIT row after lock bump and s-router shutdown/rebuild.";
  };
}
