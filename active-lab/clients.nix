{
  activeLabClientStub = {
    kind = "runtime-client-source-stub";
    scope = "NixOS access-endpoint renderer input path";
    miniSmtId = "renderer-nixos-clients";
    source = ../GAMP/SMT/layer-entry-poc/renderer-input/minimal-access-endpoint-cpm.nix;
    test = ../tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh;
  };

  clients = { };
}
