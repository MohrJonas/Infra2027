{pkgs, ...}: let
  sources = pkgs.writeText "debian.sources" ''
    Types: deb
    URIs: http://ftp2.de.debian.org/debian/
    Suites: trixie trixie-updates
    Components: main contrib non-free non-free-firmware
    Signed-By: /usr/share/keyrings/debian-archive-keyring.pgp

    Types: deb
    URIs: http://deb.debian.org/debian-security/
    Suites: trixie-security
    Components: main contrib non-free non-free-firmware
    Signed-By: /usr/share/keyrings/debian-archive-keyring.pgp
  '';
  systemdService = pkgs.writeText "systemdService" ''
    [Unit]
    Description=SystemD service for overview display

    [Service]
    ExecStart=/usr/bin/python3 /opt/OverviewDisplay/main.py
    Restart=on-failure
    RestartSec=5
    User=overview_display
    Group=overview_display
    SupplementaryGroups=988 986 15
    Environment=LG_WD=/tmp

    [Install]
    WantedBy=multi-user.target
  '';
in [
  {
    name = "Setup Guf";
    hosts = "all";
    tasks = [
      {
        name = "Switch to local debian mirror";
        "ansible.builtin.copy" = {
          src = "${sources}";
          dest = "/etc/apt/sources.list.d/debian.sources";
          force = true;
          owner = "root";
          group = "root";
          mode = "0644";
        };
      }
      {
        name = "Update package sources";
        "ansible.builtin.apt" = {
          update_cache = true;
        };
      }
      {
        name = "Clone Overview Display repo";
        "ansible.builtin.git" = {
          repo = "https://github.com/MohrJonas/OverviewDisplay";
          dest = "/opt/OverviewDisplay";
        };
      }
      {
        name = "Create group overview_display";
        "ansible.builtin.group" = {
          name = "oveview_display";
          state = "present";
        };
      }
      {
        name = "Create user overview_display";
        "ansible.builtin.user" = {
          name = "oveview_display";
          group = "oveview_display";
          system = true;
        };
      }
      {
        name = "Change ownership of repo";
        "ansible.builtin.file" = {
          path = "/opt/OverviewDisplay";
          owner = "oveview_display";
          group = "oveview_display";
          recurse = true;
        };
      }
      {
        name = "Create systemd service";
        "ansible.builtin.copy" = {
          src = "${systemdService}";
          dest = "/etc/systemd/system/overview_display.service";
          owner = "root";
          group = "root";
          mode = "0644";
        };
      }
      {
        name = "Enable and start systemd service";
        "ansible.builtin.systemd" = {
          service = "overview_display.service";
          state = "started";
          enabled = true;
        };
      }
      {
        name = "Check if PBS is already installed";
        "ansible.builtin.stat" = {
          path = "/usr/lib/systemd/system/proxmox-backup.service";
        };
        register = "pbs_stat";
      }
      {
        name = "Fetch PBS install script";
        "ansible.builtin.get_url" = {
          url = "https://raw.githubusercontent.com/wofferl/proxmox-backup-arm64/refs/heads/main/build.sh";
          dest = "/tmp/build.sh";
          owner = "root";
          group = "root";
        };
        when = "pbs_stat.stat.exists == False";
      }
      {
        name = "Run install script";
        "ansible.builtin.shell" = "bash /tmp/build.sh";
        when = "pbs_stat.stat.exists == False";
      }
      {
        name = "Delete enterprise repository";
        "ansible.builtin.file" = {
            path = "/etc/apt/sources.list.d/pbs-enterprise.sources";
            state = "absent";
        };
        when = "pbs_stat.stat.exists == False";
      }
      {
        name = "Fetch Proxmox GPG key";
        "ansible.builtin.get_url" = {
          url = "https://enterprise.proxmox.com/debian/proxmox-archive-keyring-trixie.gpg";
          dest = "/usr/share/keyrings/proxmox-archive-keyring.gpg";
          owner = "root";
          group = "root";
        };
        when = "pbs_stat.stat.exists == False";
      }
    ];
  }
]
