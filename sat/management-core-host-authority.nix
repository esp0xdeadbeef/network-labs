{
  site-nixos = {
    sourceSite = "esp.nixos";
    managementAccess = [
      {
        id = "nixos-admin-to-mgmt-router-ssh";
        policyClass = "management";
        sourceScope = "admin";
        targetRole = "core-boundary";
        targetHost = "nixos-router-core";
        protocol = "tcp";
        ports = [ 22 ];
        authenticationBoundary = "managed-admin-ssh-keys";
        recoveryMode = "normal-admin";
        nonManagementAuthority = false;
      }
      {
        id = "nixos-recovery-console";
        policyClass = "management";
        sourceScope = "external-harness";
        targetRole = "hardware-management";
        targetHost = "s-router-nixos";
        protocol = "ssh";
        ports = [ 22 ];
        authenticationBoundary = "harness-root-key";
        recoveryMode = "break-glass";
        nonManagementAuthority = false;
      }
    ];
    coreHostExceptions = [
      {
        id = "nixos-admin-core-ssh-host-local";
        sourceScope = "admin";
        targetRole = "core-boundary";
        targetAddress = "router-self";
        protocol = "tcp";
        ports = [ 22 ];
        attachmentSurface = "mgmt-access";
        trafficClass = "host-management";
        forwardingSideEffects = false;
        serviceExposure = false;
      }
    ];
  };

  site-hetz = {
    sourceSite = "esp.hetz";
    managementAccess = [
      {
        id = "hetz-harness-management";
        policyClass = "management";
        sourceScope = "external-harness";
        targetRole = "hosted-edge";
        targetHost = "hetz-edge-host";
        protocol = "ssh";
        ports = [ 22 ];
        authenticationBoundary = "hetzner-admin-key";
        recoveryMode = "provider-console";
        nonManagementAuthority = false;
      }
    ];
    coreHostExceptions = [
      {
        id = "hetz-provider-core-host-control";
        sourceScope = "external-harness";
        targetRole = "core-boundary";
        targetAddress = "provider-edge-self";
        protocol = "ssh";
        ports = [ 22 ];
        attachmentSurface = "provider-management";
        trafficClass = "host-management";
        forwardingSideEffects = false;
        serviceExposure = false;
      }
    ];
  };

  site-clab = {
    sourceSite = "esp.clab";
    managementAccess = [
      {
        id = "clab-admin-to-mgmt-router-ssh";
        policyClass = "management";
        sourceScope = "admin";
        targetRole = "core-boundary";
        targetHost = "clab-router-core";
        protocol = "tcp";
        ports = [ 22 ];
        authenticationBoundary = "managed-admin-ssh-keys";
        recoveryMode = "normal-admin";
        nonManagementAuthority = false;
      }
      {
        id = "clab-recovery-host";
        policyClass = "management";
        sourceScope = "external-harness";
        targetRole = "hardware-management";
        targetHost = "s-router-clab";
        protocol = "ssh";
        ports = [ 22 ];
        authenticationBoundary = "harness-root-key";
        recoveryMode = "break-glass";
        nonManagementAuthority = false;
      }
    ];
    coreHostExceptions = [
      {
        id = "clab-admin-core-ssh-host-local";
        sourceScope = "admin";
        targetRole = "core-boundary";
        targetAddress = "router-self";
        protocol = "tcp";
        ports = [ 22 ];
        attachmentSurface = "mgmt-access";
        trafficClass = "host-management";
        forwardingSideEffects = false;
        serviceExposure = false;
      }
    ];
  };
}
