{
  description = "s-sigma s-router-test three-site lab staging inputs";

  outputs =
    { self }:
    {
      getIntent = import ./intent.nix;
      getCompilerInput = import ./getCompilerInput.nix;
      getInventory = import ./getInventory.nix;
      getInventorySops = import ./getInventorySops.nix;
      getResolvedInventory = import ./getResolvedInventory.nix;
      packages.x86_64-linux.default = self.getCompilerInput;
    };
}
