{...}: let
  aptUpdate = import ../shared/aptUpdate.nix;
in [
  {
    name = "Update Casper";
    hosts = "all";
    tasks = aptUpdate;
  }
]
