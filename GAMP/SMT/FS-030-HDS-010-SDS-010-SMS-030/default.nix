{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-010-SMS-030";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-010-SMS-030__mini-verify"
    ];
  };
  evidence = {
    owningRepo = "network-compiler";
    focusedTest = "tests/test-FS-030-HDS-010-SDS-010-SMS-030.sh";
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-010-SMS-030";
    status = "OK";
    maxRuntimeTargets = 5;
    scope = "Compiler behavior source audit: ensures every behavior-creating compiler output field carries a user-intent source-class audit reference, fails closed on missing or non-intent sourceClass, and proves row-local mini-SMT artifacts";
  };
}
