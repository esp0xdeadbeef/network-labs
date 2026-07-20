{
  traceId,
  controlPlaneModel,
}:

let
  artifactDigest = builtins.hashString "sha256" (builtins.toJSON controlPlaneModel);
in
{
  kind = "network-control-plane-artifact";
  artifactIdentity = artifactDigest;
  inherit artifactDigest;
  control_plane_model = controlPlaneModel;
  provenance = {
    producer = "network-labs";
    inherit traceId;
    contract = "network-control-plane-artifact/v1";
    declaredFirstActiveBoundary = "network-realization-model";
  };
}
