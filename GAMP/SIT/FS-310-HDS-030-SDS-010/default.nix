{
  layer = "SIT";
  traceId = "FS-310-HDS-030-SDS-010";
  smsInputs = {
    "FS-310-HDS-030-SDS-010-SMS-080" = {
      smtRow = ../../SMT/FS-310-HDS-030-SDS-010-SMS-080;
      sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-080/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-080-renderer-shell-fallback-error-propagation.md";
      role = "renderer-shell-fallback-error-propagation";
      evidenceBoundary = "active mini-SMT runtime wrapper plus owning renderer construction proof";
    };
    "FS-310-HDS-030-SDS-010-SMS-090" = {
      smtRow = ../../SMT/FS-310-HDS-030-SDS-010-SMS-090;
      sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-090/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-090-renderer-check-bypass-prevention.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-030-SDS-010-SMS-110" = {
      smtRow = ../../SMT/FS-310-HDS-030-SDS-010-SMS-110;
      sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-110/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-110-renderer-fail-closed-contract.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-030-SDS-010-SMS-111" = {
      smtRow = ../../SMT/FS-310-HDS-030-SDS-010-SMS-111;
      sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-111/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-111-nixos-fail-closed-contract.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-030-SDS-010-SMS-112" = {
      smtRow = ../../SMT/FS-310-HDS-030-SDS-010-SMS-112;
      sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-112/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-112-clab-fail-closed-contract.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-310-HDS-030-SDS-010-SMS-080";
    liveCommand = ''
      cd /home/deadbeef/github/network-codex-agent &&
      NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
      S_ROUTER_NIXOS=s-router-nixos \
      S_ROUTER_CLAB=s-router-clab \
      S_ROUTER_TEST_CLIENTS=s-router-test-clients \
      bash scripts/smt-live-FS-310-HDS-030-SDS-010-SMS-080.sh
    '';
    sourcePaths = [
      "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-080/intent.nix"
    ];
    observedResult = "registered runtime wrapper for the SMS-080 mini profile; row remains unpromoted until the live wrapper passes after the selected active-lab build and the owning CLAB renderer construction test remains passing";
  };
}
