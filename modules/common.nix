{...}: {
  time.timeZone = "Europe/Berlin";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.11";
}
