let
  repoRoot = ../../..;
  smtRoot = ../.;
  tracePattern = "FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+";

  traceIds = builtins.filter (
    name:
    (builtins.readDir smtRoot).${name} == "directory"
    && builtins.match tracePattern name != null
    && builtins.pathExists (smtRoot + "/${name}/default.nix")
  ) (builtins.attrNames (builtins.readDir smtRoot));

  parentSdsFor = traceId: builtins.head (builtins.match "(.*)-SMS-[0-9]+" traceId);

  maximum = values: builtins.foldl' (result: value: if value > result then value else result) 0 values;

  normalizeSource = traceId: rowSource:
    let
      rowDirectory = smtRoot + "/${traceId}";
      sourcePath =
        if rowSource != null && rowSource ? sourcePath
        then repoRoot + "/${rowSource.sourcePath}"
        else null;
      hasIntent = builtins.pathExists (rowDirectory + "/intent.nix");
      isCpmArtifact =
        rowSource != null
        && builtins.elem (rowSource.kind or "") [
          "renderer-input"
          "replacement-cpm-artifact"
        ];
    in
    if rowSource == null then null
    else
      rowSource
      // (if hasIntent then { intent = rowDirectory + "/intent.nix"; } else { })
      // (if isCpmArtifact && sourcePath != null then { cpm = sourcePath; } else { });

  normalizeRow = traceId:
    let
      rowDirectory = smtRoot + "/${traceId}";
      row = import (rowDirectory + "/default.nix");
      rowSource = row.source or null;
      source = normalizeSource traceId rowSource;
      rawBoundary = row.evidenceBoundary or (if rowSource == null then null else rowSource.evidenceBoundary or null);
      constructionOnly =
        (row.evidence.isConstructionOnly or false)
        || (
          rawBoundary != null
          && builtins.match ".*construction-only.*" rawBoundary != null
        );
      expectedRuntimeTargets =
        if rowSource != null && rowSource ? expectedRuntimeTargets
        then builtins.attrValues rowSource.expectedRuntimeTargets
        else [ ];
      declaredMaximum =
        row.evidence.maxRuntimeTargets
          or (if rowSource == null then null else rowSource.maxRuntimeTargets or null);
      maxRuntimeTargets =
        if constructionOnly then 0
        else if declaredMaximum != null then declaredMaximum
        else if expectedRuntimeTargets != [ ] then maximum expectedRuntimeTargets
        else 5;
      evidenceBoundary =
        if constructionOnly then "construction-only"
        else if rawBoundary == null || rawBoundary == "source-stub-only" then "runtime"
        else rawBoundary;
      rendererTarget = if rowSource == null then null else rowSource.rendererTarget or null;
    in
    {
      id = traceId;
      inherit traceId source evidenceBoundary maxRuntimeTargets rendererTarget;
      status = row.status or row.evidence.status or null;
      rowDirectories = {
        SDS = ../../SDS + "/${parentSdsFor traceId}";
        SMS = ../../SMS + "/${traceId}";
        SMT = rowDirectory;
        SIT = ../../SIT + "/${parentSdsFor traceId}";
      };
      evidenceLevels = if constructionOnly then [ "SMT" ] else [ "SMT" "SIT" ];
      independent = true;
      aggregateOnly = false;
      scope = row.evidence.scope or row.purpose or "${traceId} controlled validation";
    };
in
{
  meta = {
    contract = "trace-derived controlled validation catalog";
    rule = "Every SMS row is discovered from its full trace ID; executable availability is derived from canonical entrypoint names.";
  };

  tests = builtins.listToAttrs (
    map (traceId: {
      name = traceId;
      value = normalizeRow traceId;
    }) traceIds
  );
}
