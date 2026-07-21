let
  indicators = [
    {
      rule = "nl-article-de";
      token = builtins.concatStringsSep "" [
        "d"
        "e"
      ];
    }
    {
      rule = "nl-article-het";
      token = builtins.concatStringsSep "" [
        "h"
        "e"
        "t"
      ];
    }
    {
      rule = "nl-article-een";
      token = builtins.concatStringsSep "" [
        "e"
        "e"
        "n"
      ];
    }
  ];
  identityInput = {
    schema = "controlled-document-language/v1";
    inherit indicators;
    matching = {
      caseSensitive = false;
      unit = "whole-word";
    };
  };
in
identityInput
// {
  traceId = "FS-164-HDS-010-SDS-010-SMS-010";
  ruleIdentity = builtins.hashString "sha256" (builtins.toJSON identityInput);
  diagnostics = [
    "DOC_NON_ENGLISH_NORMATIVE"
    "DOC_UNCLASSIFIED_TEXT"
    "DOC_DECODE_FAILED"
    "DOC_DIAGNOSTIC_PRIVACY_LEAK"
  ];
  successExit = 0;
  failureExit = 2;
}
