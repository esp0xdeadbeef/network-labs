{
  layer = "SMT";
  traceId = "FS-705-HDS-010-SDS-010-SMS-030";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-codex-agent";
    focusedTest = "tests/FS-705-HDS-010-SDS-010-SMS-030-validation-profile-posture-reuse.sh";
    smtRow = "GAMP/SMT/README.md FS-705-HDS-010-SDS-010-SMS-030";
    status = "OK";
    scope = "Validation profile posture reuse: shared SMT/SIT validation profile posture record with VLAN2 management (bridge=vlan2, parent=eth0, VLAN ID 2, IPv4 DHCP enabled, no payload/upstream semantics), VLAN4 default IPv4/IPv6 upstream/provider surface, VLAN5 failover/alternate upstream surface, VLAN11/VLAN12 emulated ISP fixtures. Profile-default inheritance ledger covers management reachability and host/client classes. Six seeded negatives exercised: missing shared profile reference (0 hits), VLAN2 payload misuse (2 hits: FS-380-120, FS-540-045), repeated global posture payload (2 repeaters: FS-380-120, FS-540-045), missing VLAN5 failover posture, emulated ISP reachability by placement (explicit binding absent), host profile realization logic (0 violations). Recovery assertion: selector correctly injects managementVlan2 as shared default. NixOS host profiles confirmed thin (labSource pattern, 0 violations).";
    sealedNegatives = [
      "diagnostic.validation-profile-missing"
      "diagnostic.validation-profile-vlan2-not-management"
      "diagnostic.validation-profile-defaults-repeated"
      "diagnostic.validation-profile-failover-uplink-missing"
      "diagnostic.validation-profile-isp-binding-missing"
      "diagnostic.validation-profile-host-realization-logic"
    ];
  };
}
