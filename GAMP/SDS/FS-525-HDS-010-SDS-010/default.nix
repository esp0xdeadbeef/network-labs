{
  layer = "SDS";
  traceId = "FS-525-HDS-010-SDS-010";
  purpose = "Named core resolver binding and deterministic DNS warning contract.";
  smsInputs = {
    "FS-525-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-525-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
