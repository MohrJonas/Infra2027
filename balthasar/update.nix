{...}: let
  aptUpdate = import ../shared/aptUpdate.nix;
in [
  {
    name = "Update Balthasar";
    hosts = "all";
    tasks = aptUpdate;
  }
]
