let
  mkSource =
    { intent ? ./intent.nix }:
    {
      intent = import intent;

      sourcePaths = {
        inherit intent;
      };
    };
in
(mkSource { })
// {
  inherit mkSource;
}
