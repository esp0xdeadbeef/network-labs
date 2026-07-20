{
  constructionScenario = {
    traceId = "FS-162-HDS-010-SDS-040-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md";
    titleSlug = "s-router-prod-comparable-projection";
    sourceTrace = "FS-230-HDS-010-SDS-010-SMS-040";
    requiredPosture = {
      family = "ipv6";
      protocol = "udp";
      port = 4242;
      translationMode = "none";
      sourcePreservation = "preserve-source";
      returnBehavior = "stateful";
      inheritedPublicEgress = false;
    };
    evidenceBoundary = "construction-only";
    runnable = false;
    notRunnableReason = "The owning OpenConfig construction test and mini-SMT registration are not implemented yet.";
  };
}
