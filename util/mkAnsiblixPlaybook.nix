{
  pkgs,
  ansiblixPlaybook,
  host,
  extraArgs ? "",
  specialArgs ? {},
  ...
}: let
  # Needed binaries
  echo = "${pkgs.coreutils}/bin/echo";
  ansible = "${pkgs.ansible}/bin/ansible-playbook";

  executable = pkgs.writeShellScriptBin "ansiblix-exec" ''
    set -eu -o pipefail
    ${echo} '${builtins.toJSON (ansiblixPlaybook {
      inherit pkgs;
      inherit specialArgs;
      lib = pkgs.lib;
    })}' | ${ansible} -i '${host},' /dev/stdin'';
in {
  type = "app";
  program = "${executable}/bin/ansiblix-exec";
}
