let
  compatName = builtins.replaceStrings
    [
      "east-west"
      "simulated-isp"
      "s-router-hetzner-anywhere"
    ]
    [
      "inter-site"
      "testnet-host-isp"
      "s-router-hetz"
    ];

  compatValue =
    value:
    if builtins.isAttrs value then
      builtins.listToAttrs (
        map (name: {
          name = compatName name;
          value = compatValue value.${name};
        }) (builtins.attrNames value)
      )
    else if builtins.isList value then
      map compatValue value
    else if builtins.isString value then
      compatName value
    else
      value;

  runtimeTargetAliases =
    nodes:
    builtins.listToAttrs (
      map (name: {
        name =
          let
            logical = nodes.${name}.logicalNode;
          in
          "${logical.enterprise}-${logical.site}-${logical.name}";
        value = nodes.${name};
      }) (builtins.attrNames nodes)
    );

  uniqueStrings = list: builtins.attrNames (builtins.listToAttrs (map (value: { name = value; value = true; }) list));

  mergeHost =
    left: right:
    left
    // right
    // {
      bridgeNetworks = (left.bridgeNetworks or { }) // (right.bridgeNetworks or { });
      uplinks = (left.uplinks or { }) // (right.uplinks or { });
      hat = (left.hat or { }) // (right.hat or { });
    };

  mergeHostSets =
    left: right:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = mergeHost (left.${name} or { }) (right.${name} or { });
      }) (uniqueStrings ((builtins.attrNames left) ++ (builtins.attrNames right)))
    );

  recursiveMerge =
    left: right:
    if builtins.isAttrs left && builtins.isAttrs right then
      builtins.listToAttrs (
        map (name: {
          inherit name;
          value =
            if builtins.hasAttr name left && builtins.hasAttr name right then
              recursiveMerge left.${name} right.${name}
            else if builtins.hasAttr name right then
              right.${name}
            else
              left.${name};
        }) (uniqueStrings ((builtins.attrNames left) ++ (builtins.attrNames right)))
      )
    else
      right;

  withManagementBridgeDefault =
    host:
    let
      uplinks = host.uplinks or { };
      management = uplinks.management or null;
      wan = uplinks.wan or null;
    in
    if management != null && !(builtins.hasAttr "bridge" management) && wan != null && builtins.hasAttr "bridge" wan then
      host
      // {
        uplinks = uplinks // {
          management = management // {
            bridge = wan.bridge;
          };
        };
      }
    else
      host;

  withManagementBridgeDefaults = hosts: builtins.mapAttrs (_: withManagementBridgeDefault) hosts;

  portAttachBridgeEntries =
    nodes:
    builtins.concatLists (
      map (
        nodeName:
        let
          node = nodes.${nodeName};
          host = node.host or null;
          ports = node.ports or { };
        in
        if host == null then
          [ ]
        else
          builtins.concatLists (
            map (
              portName:
              let
                bridge = ((ports.${portName}.attach or { }).bridge or null);
              in
              if bridge == null then
                [ ]
              else
                [
                  {
                    inherit host bridge;
                  }
                ]
            ) (builtins.attrNames ports)
          )
      ) (builtins.attrNames nodes)
    );

  portUplinkEntries =
    nodes:
    builtins.concatLists (
      map (
        nodeName:
        let
          node = nodes.${nodeName};
          host = node.host or null;
          ports = node.ports or { };
        in
        if host == null then
          [ ]
        else
          builtins.concatLists (
            map (
              portName:
              let
                port = ports.${portName};
                uplink = port.uplink or null;
                bridge = ((port.attach or { }).bridge or null);
              in
              if uplink == null || bridge == null then
                [ ]
              else
                [
                  {
                    inherit host uplink bridge;
                  }
                ]
            ) (builtins.attrNames ports)
          )
      ) (builtins.attrNames nodes)
    );

  withRealizationHostUplinks =
    hosts: nodes:
    builtins.foldl'
      (
        result: entry:
        let
          host = result.${entry.host} or { };
          uplinks = host.uplinks or { };
          fallback = uplinks.uplink-isp-b or uplinks.uplink-isp-a or uplinks.management or { };
        in
        if builtins.hasAttr entry.uplink uplinks then
          result
        else
          result
          // {
            ${entry.host} = mergeHost host {
              uplinks = {
                ${entry.uplink} =
                  fallback
                  // {
                    bridge = entry.bridge;
                    upstream = entry.uplink;
                  };
              };
            };
          }
      )
      hosts
      (portUplinkEntries nodes);

  withRealizationHostBridges =
    hosts: nodes:
    builtins.foldl'
      (
        result: entry:
        let
          host = result.${entry.host} or { };
          uplinks = host.uplinks or { };
          uplinkBridges =
            builtins.map
              (uplink: uplinks.${uplink}.bridge or null)
              (builtins.attrNames uplinks);
        in
        if builtins.elem entry.bridge uplinkBridges then
          result
        else
          result
          // {
            ${entry.host} = mergeHost host {
              bridgeNetworks = {
                ${entry.bridge} = { };
              };
            };
          }
      )
      hosts
      (portAttachBridgeEntries nodes);

  withoutOldHetzHost =
    inventory:
    inventory
    // {
      deployment = inventory.deployment // {
        hosts = withManagementBridgeDefaults (
          builtins.removeAttrs (inventory.deployment.hosts or { }) [ "s-router-hetzner-anywhere" ]
        );
      };
    };
in
{
  inherit
    compatName
    compatValue
    mergeHost
    mergeHostSets
    recursiveMerge
    runtimeTargetAliases
    withRealizationHostBridges
    withRealizationHostUplinks
    ;

  inventory = inventory: compatValue (withoutOldHetzHost inventory);

  realizationNodes =
    inventory:
    let
      nodes = (compatValue (withoutOldHetzHost inventory)).realization.nodes or { };
    in
    runtimeTargetAliases nodes;
}
