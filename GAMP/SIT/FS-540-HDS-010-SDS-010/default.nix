{
  layer = "SIT";
  traceId = "FS-540-HDS-010-SDS-010";
  smsInputs = {
    "FS-540-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "dns-resolver-config";
    };
    "FS-540-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "requester-lane-recursive-reachability";
      evidenceBoundary = "construction-only";
    };
    "FS-540-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    command = ''
      tests/run-active-lab-mini-smt.sh dns-resolver-config &&
      tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh
    '';
    sourcePaths = [
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix"
    ];
    observedResult = "NOT OK live on 2026-06-29: current-lab is selected to SIT FS-540-HDS-010-SDS-010 and both 192.168.1.17/s-router-nixos and 192.168.1.19/s-router-clab expose the five-node mini path access-dns, downstream-selector, policy, upstream-selector, resolver-node. Live probe tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh proves resolver-source artifacts have local-recursive=1, none=9, public-fallback=0 on both surfaces, then fails real route/DNS assertions: NixOS resolver-node has no modeled u0 IPv4 upstream route, CLAB resolver-node has no IPv4/default route on u0, and access-dns recursive resolution for cache.nixos.org fails on both. Focused runtime-debugger check wan_upstream_egress confirms NixOS missing interface u0 and CLAB missing IPv4/default route. Row source now declares the required CLAB harness fake-provider prerequisite (handoffVlan=11, liveUpstreamVlan=4); runtime DNS remains NOT OK until NixOS consumes the renderer WAN-veth fix and CLAB deployment consumes the explicit provider-emulation source/provider side so u0 obtains upstream reachability.";
  };
}
