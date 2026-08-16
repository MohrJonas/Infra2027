{pkgs, ...}: {
  users.users.jonas = {
    shell = pkgs.fish;
    extraGroups = ["wheel"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSy4RF1njMXk8FIyXD6gsl2VL0LT0R91vVE+lUZBbIE"];
  };
  programs.fish.enable = true;
}
