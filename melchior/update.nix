{...}: let
  aptUpdate = import ../shared/aptUpdate.nix;
in [
  {
    name = "Update Melchior";
    hosts = "all";
    tasks = aptUpdate;
  }
]
