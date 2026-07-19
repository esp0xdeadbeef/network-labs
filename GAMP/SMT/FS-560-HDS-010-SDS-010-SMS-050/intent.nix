let
  base = import ../FS-970-HDS-010-SDS-020-SMS-040/intent.nix;
  baseSite = base.mini-smt.FS-970-HDS-010-SDS-020-SMS-040;
in
{
  mini-smt.FS-560-HDS-010-SDS-010-SMS-050 = baseSite // {
    communicationContract = baseSite.communicationContract // {
      relations = map (
        relation:
        relation
        // {
          id = "FS-560-HDS-010-SDS-010-SMS-050__mini-verify";
        }
      ) baseSite.communicationContract.relations;
    };
  };
}
