let
  source = ../GAMP/HAT/emulated-isp-residential-testnet/inventory-hetz.nix;
in
(import source)
// {
  activeLabInventoryStub = {
    kind = "runtime-hetz-inventory-stub";
    inherit source;
  };
}
