{...}: let
  aptUpdate = import ../shared/aptUpdate.nix;
in [
  {
    name = "Update Guf";
    hosts = "all";
    tasks = aptUpdate;
  }
]
