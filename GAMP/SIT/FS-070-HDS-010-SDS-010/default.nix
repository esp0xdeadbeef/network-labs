{
  layer = "SIT";
  traceId = "FS-070-HDS-010-SDS-010";
  smsInputs = {
    "FS-070-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-070-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-070-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-070-HDS-010-SDS-010-SMS-010-validation-context-boundary.md";
      role = "validation-context-boundary-mini-path";
      evidenceBoundary = "runtime";
    };
  };
  evidence = {
    observedResult = "OK live on 2026-07-04: locked source /nix/store/3mxrnfjhys741zavf161hs64wyd5nbza-source selected full SMS trace FS-070-HDS-010-SDS-010-SMS-010 and full-loop active-lab evidence /tmp/s-router-live-smoke/FS-070-HDS-010-SDS-010-SMS-010/20260704T080618Z plus /tmp/s-router-live-smoke/FS-070-HDS-010-SDS-010-SMS-010/20260704T080720Z passed. s-router-clab active-lab readiness reported active-targets=5. The child full-trace artifact checks verified five bounded runtime targets on s-router-nixos and s-router-clab, zero router runtime targets on s-router-test-clients, validation-context mutation records equal zero on all three hosts, and construction rejects validation-context model/render mutation. Manual enumeration confirmed relationHits=38 on s-router-nixos and s-router-clab. This is SMT/SIT live evidence only, not HAT/SAT or production readiness.";
  };
}
