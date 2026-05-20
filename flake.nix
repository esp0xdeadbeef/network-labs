{
  description = "Network lab examples";

  outputs =
    { self }:
    let
      lib = builtins;

      examplesDir = ./examples;

      entries = lib.readDir examplesDir;

      isExampleDir = name: entries.${name} == "directory";

      exampleNames = lib.filter isExampleDir (lib.attrNames entries);

      mkLab =
        name:
        let
          base = examplesDir + "/${name}";
        in
        {
          path = base;
          intent = base + "/intent.nix";
          inventory =
            if lib.pathExists (base + "/inventory-nixos.nix") then
              base + "/inventory-nixos.nix"
            else if lib.pathExists (base + "/inventory.nix") then
              base + "/inventory.nix"
            else
              null;
        };

      labs = lib.listToAttrs (
        map
          (name: {
            name = name;
            value = mkLab name;
          })
          exampleNames
      );

    in
    {
      labs = labs;
    };
}
