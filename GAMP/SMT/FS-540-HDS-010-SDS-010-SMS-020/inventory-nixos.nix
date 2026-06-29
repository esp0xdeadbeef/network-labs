{
  meta = {
    traceId = "FS-540-HDS-010-SDS-010-SMS-020";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-020-cpm-dns-resolver-configuration-authority.md";
    renderer = "nixos";
    scope = "canonical-sms-source-stub";
    evidenceBoundary = "source-stub-only";
  };
  endpoints = {
    access-dns = {
      ipv4 = [ "10.54.10.1" ];
      ipv6 = [ "fd42:540::1" ];
    };
  };
  hosts = { };
  deploymentHosts = { };
}
