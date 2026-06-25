{ ... }:

{
  _module.args.activeLabSopsStub = {
    kind = "runtime-sops-import-stub";
    hostName = "s-router-nixos";
    sourceBoundary = "active-lab/secrets";
    gampIds = [
      "FS-800-HDS-020-SDS-020"
      "FS-800-HDS-010-SDS-030-SMS-020"
    ];
    note = "This selected mini runtime has no extra sops.secrets declarations, but the active-lab SOPS tree remains controlled FS material for the active-lab runtime boundary.";
  };
}
