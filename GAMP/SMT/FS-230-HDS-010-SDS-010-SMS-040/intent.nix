{
  traceId = "FS-230-HDS-010-SDS-010-SMS-040";
  communicationContract.relations = [
    {
      id = "FS-230-HDS-010-SDS-010-SMS-040__lab-wan-to-nebula-ipv6";
      action = "allow";
      from = {
        kind = "external";
        uplinks = [ "lab-wan" ];
      };
      to = {
        kind = "service";
        name = "nebula-lab";
      };
      returnBehavior = "stateful-return";
      publicIngressTupleAuthority = {
        family = "ipv6";
        targetService = "nebula-lab";
        targetPort = 4242;
        tuples = [
          {
            protocol = "udp";
            publicPort = 4242;
          }
        ];
        translationMode = "none";
        sourcePreservation = "preserve-source";
        returnBehavior = "stateful-return";
      };
    }
  ];
}
