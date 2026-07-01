{
  activeLabClientStub = {
    kind = "runtime-client-source-stub";
    scope = "NixOS access-endpoint renderer input path";
    miniSmtId = "FS-166-HDS-010-SDS-010-SMS-903";
    miniSmtManifestKey = "FS-166-HDS-010-SDS-010-SMS-903";
    source = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-access-endpoint-cpm.nix;
    test = ../tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh;
  };

  clients = { };
}
