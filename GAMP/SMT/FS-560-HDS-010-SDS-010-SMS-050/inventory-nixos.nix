let
  base = import ../FS-970-HDS-010-SDS-020-SMS-040/inventory-nixos.nix;
  baseNode = base.realization.nodes."mini-smt-fs-970-hds-010-sds-020-sms-040-client-edge";
  publishNames =
    reservationSource:
    reservationSource
    // {
      namePublication = {
        namespace = "client.lab.";
        ownerScope = "client";
        requesterScopes = [ "client" ];
        recordClasses = [
          "A"
          "AAAA"
          "PTR"
        ];
        fallbackBehavior = "local-only";
        publicationDenialDiagnostic = "diagnostic.protected-reservation-name-publication-denied";
      };
    };
in
{
  meta = {
    traceId = "FS-560-HDS-010-SDS-010-SMS-050";
    scope = "protected-reservation-name-live-probe";
  };

  deploymentHosts.s-router-nixos.bridgeNetworks.rsv560 = {
    mode = "vlan";
    parent = "eth0";
    vlan = 399;
  };
  realization.nodes."mini-smt-fs-560-hds-010-sds-010-sms-050-client-edge" = baseNode // {
    logicalNode = baseNode.logicalNode // {
      site = "FS-560-HDS-010-SDS-010-SMS-050";
    };
    ports.tenant-client.attach.bridge = "rsv560";
    advertisements = baseNode.advertisements // {
      dhcp4.tenant-client = baseNode.advertisements.dhcp4.tenant-client // {
        reservationSource = publishNames (
          baseNode.advertisements.dhcp4.tenant-client.reservationSource
          // {
            sourceFile = "/run/secrets/fs560-protected-reservations.json";
          }
        );
      };
      dhcpv6.tenant-client = baseNode.advertisements.dhcpv6.tenant-client // {
        reservationSource = publishNames (
          baseNode.advertisements.dhcpv6.tenant-client.reservationSource
          // {
            sourceFile = "/run/secrets/fs560-protected-reservations.json";
          }
        );
      };
    };
  };
}
