# Host-specific inventory projection for Containerlab.
#
# Public-safe topology projection only.

{
  hostName = "clab-test";
  backend = "clab";

  topology = {
    name = "active-lab";

    nodes = { };

    links = [ ];
  };
}
