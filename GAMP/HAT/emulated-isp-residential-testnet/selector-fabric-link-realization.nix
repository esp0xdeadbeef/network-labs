inventory:
let
  legacySelectorNodeNames = [
    "clab-downstream-selector"
    "clab-upstream-selector"
    "nixos-downstream-selector"
    "nixos-upstream-selector"
  ];

  realization = inventory.realization or { };
  nodes = realization.nodes or { };

  asString = value: if builtins.isString value then value else "";

  selectorLogicalName =
    target:
    asString ((target.logicalNode or { }).name or "");

  selectorRole =
    target:
    let
      logicalRole = (target.logicalNode or { }).role or null;
      targetRole = target.role or null;
    in
    asString (if logicalRole != null then logicalRole else targetRole);

  isSelectorRole = role: role == "downstream-selector" || role == "upstream-selector";

  isSelectorLogicalName =
    name:
    builtins.elem name legacySelectorNodeNames
    || name == "downstream-selector"
    || name == "upstream-selector"
    || builtins.match ".*-downstream-selector" name != null
    || builtins.match ".*-upstream-selector" name != null;

  isSelectorTarget =
    target:
    isSelectorRole (selectorRole target) || isSelectorLogicalName (selectorLogicalName target);

  linkPorts =
    target:
    let
      ports = target.ports or { };
    in
    builtins.listToAttrs (
      builtins.concatLists (
        builtins.map
          (portName:
            let port = ports.${portName};
            in
            if builtins.isString (port.link or null) && port.link != "" then
              [
                {
                  name = portName;
                  value = port;
                }
              ]
            else
              [ ])
          (builtins.attrNames ports)
      )
    );

  selectorFabricLinks =
    builtins.listToAttrs (
      builtins.concatLists (
        builtins.map
          (targetName:
            let
              target = nodes.${targetName};
              ports = linkPorts target;
            in
            if isSelectorTarget target && ports != { } then
              [
                {
                  name = targetName;
                  value =
                    builtins.mapAttrs
                      (_portName: port: {
                        kind = "selector-fabric-link";
                        link = port.link;
                        transport.hostFacing = false;
                      })
                      ports;
                }
              ]
            else
              [ ])
          (builtins.attrNames nodes)
      )
    );

  stripSelectorPorts =
    _targetName: target:
    if isSelectorTarget target then target // { ports = { }; } else target;
in
inventory
// {
  realization =
    realization
    // {
      fabricLinks = (realization.fabricLinks or { }) // selectorFabricLinks;
      nodes = builtins.mapAttrs stripSelectorPorts nodes;
    };
}
