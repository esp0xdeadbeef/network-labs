{
  layer = "SIT";
  traceId = "FS-380-HDS-020-SDS-010";
  smsInputs = {
    "FS-380-HDS-020-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-380-HDS-020-SDS-010-SMS-050;
      sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-050/intent.nix";
      role = "internet-mode-verification";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh internet-mode-verification";
    sourcePaths = [
      "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-050/intent.nix"
    ];
    observedResult = "NOT OK on 2026-06-29 scoped active-lab live run: row-local mini SMT and selected CPM artifacts pass; s-router-clab live passes; s-router-nixos selected profile fails eval in wan-attachment.nix on emulated-ISP upstream identities internet-vlan4/internet-vlan5; s-router-test-clients live artifact omits deploymentHosts.s-router-test-clients.accessHandoff.";
  };
}
