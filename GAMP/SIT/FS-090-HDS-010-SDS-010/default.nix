{
  layer = "SIT";
  traceId = "FS-090-HDS-010-SDS-010";
  smsInputs = {
    "FS-090-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-090-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-090-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-090-HDS-010-SDS-010-SMS-010-no-downstream-heuristic-repair.md";
      role = "no-downstream-heuristic-repair-mini-path";
      evidenceBoundary = "runtime";
    };
  };
  evidence = {
    observedResult = "OK live on 2026-07-04: locked source /nix/store/bldixbjx05i8fj4nmj3y7nnibp67n3ss-source selected full SMS trace FS-090-HDS-010-SDS-010-SMS-010 and full-loop active-lab evidence /tmp/s-router-live-smoke/FS-090-HDS-010-SDS-010-SMS-010/20260704T093244Z plus /tmp/s-router-live-smoke/FS-090-HDS-010-SDS-010-SMS-010/20260704T093329Z passed. s-router-clab active-lab readiness reported active-targets=5. The child full-trace artifact checks verified five bounded runtime targets on s-router-nixos and s-router-clab, zero router runtime targets on s-router-test-clients, downstreamRepairRecords=0, downstreamInventionRecords=0, nameShortcutRecords=0, defaultInferenceRecords=0, and relationHits=38 on both router hosts. Construction proof `bash tests/test-gamp-sms-input-contracts.sh` confirmed incomplete downstream handoff, missing interface declarations, downstream continuation after failure, name-based shortcuts, and downstream-invented behavior are rejected. This is SMT/SIT live evidence only, not HAT/SAT or production readiness.";
  };
}
