{
  meta = {
    traceId = "FS-560-HDS-010-SDS-010-SMS-050";
    renderer = "nixos";
    evidenceBoundary = "cross-repo-construction-only";
  };
  realization = {
    scopeId = "lab-client";
    dnsService = "lab-client-dns";
    reservationSource = {
      schema = "gamp-protected-reservation-set-v1";
      sourceClass = "protected";
      sourceFile = "/run/secrets/fs560-lab-client-reservations.json";
      namePublication = {
        namespace = "client.lab.";
        ownerScope = "lab-client";
        requesterScopes = [ "lab-client" ];
        recordClasses = [
          "A"
          "AAAA"
          "PTR"
        ];
        fallbackBehavior = "local-only";
        publicationDenialDiagnostic =
          "diagnostic.protected-reservation-name-publication-denied";
      };
    };
  };
}
