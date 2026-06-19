# FS-830-HDS-010-SDS-010-SMS-010: Controlled Secret Preparation Context Validation
# Takes resolved inventory + preparation context config, returns validation records with diagnostics.
#
# This module validates that secret declarations requiring controlled preparation
# context have:
#   1. A matching preparation context config entry
#   2. A selected source binding
#   3. A lifecycle that matches the context's allowed lifecycles
#   4. A source path within the controlled preparation boundary
#
# Construction: CMC-FS830-SMS010-PREP-CTX
# Owning repo: network-labs

{
  inventory,           # Attrset with secretDeclarations, secretSources, sourceBindings
  preparationConfig ? {},  # { controlled = { allowedLifecycles = [...]; allowedRoots = [...]; }; ... }
}:

let
  decls = inventory.secretDeclarations or [];
  sources = inventory.secretSources or [];
  bindings = inventory.sourceBindings or [];

  # Find source record for a declaration
  getSource = declId:
    let matches = builtins.filter (s: s.declarationId == declId) sources;
    in if matches == [] then null else builtins.head matches;

  # Find binding record for a declaration
  getBinding = declId:
    let matches = builtins.filter (b: b.declarationId == declId) bindings;
    in if matches == [] then null else builtins.head matches;

  # Check if a path string starts with any of the allowed root prefixes
  pathWithinRoots = path: roots:
    if roots == [] then true
    else builtins.any
      (root: builtins.substring 0 (builtins.stringLength root) path == root)
      roots;

  # Validate a single declaration that has a preparationContext
  validateDecl = decl:
    let
      ctx = decl.preparationContext or null;
    in
    if ctx == null then null  # Declaration does not require controlled preparation context
    else
      let
        config = preparationConfig.${ctx} or null;
        binding = getBinding decl.id;
        source = getSource decl.id;

        # Collect all diagnostics; null entries are filtered out
        allDiagnostics = builtins.filter (d: d != null) [

          # SN1: Missing preparation context config
          # The declaration requires a specific context but no matching config exists
          (if config == null then {
            code = "no controlled preparation context";
            detail = "declaration \"${decl.id}\" requires preparationContext \"${ctx}\" but no matching context config exists in preparationConfig";
          } else null)

          # SN2: Missing source binding
          # The declaration has no source binding record
          (if config != null && binding == null then {
            code = "no selected source binding";
            detail = "declaration \"${decl.id}\" requires preparationContext \"${ctx}\" but has no source binding";
          } else null)

          # SN3: Lifecycle mismatch
          # The declaration's lifecycle is not in the context's allowed lifecycles
          (if config != null && binding != null then
            let
              allowed = config.allowedLifecycles or [];
            in
            if allowed != [] && !(builtins.elem decl.lifecycle allowed) then {
              code = "lifecycle stage mismatch";
              detail = "declaration \"${decl.id}\" lifecycle \"${toString decl.lifecycle}\" not in allowed lifecycles [${builtins.concatStringsSep ", " allowed}] for context \"${ctx}\"";
            } else null
          else null)

          # SN4: Out-of-boundary path
          # The source field path is not within the allowed root prefixes
          (if config != null && source != null then
            let
              path = source.reference.sourceFieldPath or "";
              roots = config.allowedRoots or [];
            in
            if roots != [] && !(pathWithinRoots path roots) then {
              code = "source binding outside preparation boundary";
              detail = "source path \"${path}\" is outside allowed roots [${builtins.concatStringsSep ", " roots}] for context \"${ctx}\"";
            } else null
          else null)

        ];
      in
      if allDiagnostics == [] then {
        secret_id = decl.id;
        ok = true;
        preparation_context = ctx;
        lifecycle = decl.lifecycle;
      } else {
        secret_id = decl.id;
        ok = false;
        preparation_context = ctx;
        lifecycle = decl.lifecycle;
        diagnostics = allDiagnostics;
      };

  # All validation records (filter out nulls for declarations without preparationContext)
  records = builtins.filter (r: r != null) (map validateDecl decls);

in
{
  validationRecords = records;
  allOk = builtins.all (r: r.ok) records;
  declarationsChecked = builtins.length records;
  # Expose for diagnostics
  gampId = "FS-830-HDS-010-SDS-010-SMS-010";
}
