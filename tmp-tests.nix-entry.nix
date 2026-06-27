      maxRuntimeTargets = 0;
    };

    service-exposure-classification = {
      id = "service-exposure-classification";
      traceId = "FS-190-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-190-HDS-010-SDS-010;
        SMS = ../../SMS/FS-190-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-190-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-190-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-190-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-service-exposure-classification-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "service exposure classification: one service with explicit exposureClass=shared-local; validates classification record emitted, seeded negatives for missing exposure class and no inference from host placement/address/route";
      maxRuntimeTargets = 2;
    };
  };
}