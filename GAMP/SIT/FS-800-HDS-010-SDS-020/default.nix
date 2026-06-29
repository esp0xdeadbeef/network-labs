{
  layer = "SIT";
  traceId = "FS-800-HDS-010-SDS-020";
  smsInputs = {
    "FS-800-HDS-010-SDS-020-SMS-040" = {
      smtRow = ../../SMT/FS-800-HDS-010-SDS-020-SMS-040;
      sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix";
      role = "provider-access-default-route";
    };
  };
  evidence = {
    command = ''
      bash tests/FS-800-HDS-010-SDS-020-SMS-040-provider-access-default-route.sh &&
      S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 \
        bash tests/FS-800-HDS-010-SDS-020-SIT-live-provider-access-default-route.sh
    '';
    sourcePaths = [
      "GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix"
    ];
    observedResult = "NOT OK live on 2026-06-29: row-local provider-access default-route structural test passes, but S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 bash tests/FS-800-HDS-010-SDS-020-SIT-live-provider-access-default-route.sh fails with 4 findings. NixOS access-a/access-b and CLAB access-a/access-b all have ppp0 with 203.0.113.5 or 203.0.113.1, but default routes and ip route get 1.1.1.1 from the PPP session address select ens21 via 10.10.44.50/10.10.44.52 or 10.50.44.50/10.50.44.52 instead of ppp0.";
  };
}
