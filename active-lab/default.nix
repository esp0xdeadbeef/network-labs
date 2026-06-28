let
  mkSource =
    { intent ? ./intent.nix }:
    {
      intent = import intent;

      sourcePaths = {
        inherit intent;
        sops = ./sops.nix;
      };
    };
in
(mkSource { })
// {
  inherit mkSource;
}
