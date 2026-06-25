let
  upstream = import ../GAMP/HAT/emulated-isp-residential-testnet/intent.nix;

  originalRelationId = "allow-client-to-testnet-host-isp";
  emulatedSmsRelationId =
    "FS-166-HDS-010-SDS-010-SMS-900__allow-client-to-testnet-host-isp";

  rewriteRelationIds =
    value:
    if builtins.isAttrs value then
      builtins.mapAttrs (_: rewriteRelationIds) (
        if value ? id && value.id == originalRelationId then
          value // { id = emulatedSmsRelationId; }
        else
          value
      )
    else if builtins.isList value then
      map rewriteRelationIds value
    else
      value;
in
rewriteRelationIds upstream
