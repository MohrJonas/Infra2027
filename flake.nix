{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    colmena = {
      url = "github:nix-community/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    serverSecrets = {
      url = "git+ssh://git@github.com/mohrjonas/serversecrets";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    colmena,
    serverSecrets,
    disko,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    secrets = import "${serverSecrets}/default.nix";
    config = import ./config.nix secrets;
    #mkNode = {modules ? []}: {
    #  imports =
    #    [
    #      disko.nixosModules.disko
    #      ./modules/common.nix
    #      ./modules/deployment.nix
    #      ./modules/networking.nix
    #      ./modules/ssh.nix
    #      ./modules/users.nix
    #    ]
    #    ++ modules;
    #};
    mkAnsiblixPlaybook = import ./util/mkAnsiblixPlaybook.nix;
  in {
    #colmenaHive = colmena.lib.makeHive {
    #  meta = {
    #    nixpkgs = pkgs;
    #    specialArgs.masterConfig = config;
    #    nodeSpecialArgs = {
    #      storageNode.nodeConfig = config.nodes.storageNode;
    #      appNode.nodeConfig = config.nodes.appNode;
    #    };
    #  };
    #};
    apps."${system}" = {
      casper = let
        nodeConfig = config.nodes.casper;
      in {
        setup = mkAnsiblixPlaybook {
          inherit pkgs;
          ansiblixPlaybook = import ./casper/setup.nix;
          host = nodeConfig.networking.ipv4Address;
          specialArgs = {
            inherit config;
            inherit nodeConfig;
          };
        };
        update = mkAnsiblixPlaybook {
          inherit pkgs;
          ansiblixPlaybook = import ./casper/update.nix;
          host = nodeConfig.networking.ipv4Address;
        };
      };
      melchior = let
        nodeConfig = config.nodes.melchior;
      in {
        setup = mkAnsiblixPlaybook {
          inherit pkgs;
          ansiblixPlaybook = import ./melchior/setup.nix;
          host = nodeConfig.networking.ipv4Address;
          specialArgs = {
            inherit config;
            inherit nodeConfig;
          };
        };
        update = mkAnsiblixPlaybook {
          inherit pkgs;
          ansiblixPlaybook = import ./melchior/update.nix;
          host = nodeConfig.networking.ipv4Address;
        };
      };
      balthasar = let
        nodeConfig = config.nodes.balthasar;
      in {
        setup = mkAnsiblixPlaybook {
          inherit pkgs;
          ansiblixPlaybook = import ./balthasar/setup.nix;
          host = nodeConfig.networking.ipv4Address;
          specialArgs = {
            inherit config;
            inherit nodeConfig;
          };
        };
        update = mkAnsiblixPlaybook {
          inherit pkgs;
          ansiblixPlaybook = import ./balthasar/update.nix;
          host = nodeConfig.networking.ipv4Address;
        };
      };
      guf = let
        nodeConfig = config.nodes.guf;
      in {
        setup = mkAnsiblixPlaybook {
          inherit pkgs;
          ansiblixPlaybook = import ./guf/setup.nix;
          host = nodeConfig.networking.ipv4Address;
        };
        update = mkAnsiblixPlaybook {
          inherit pkgs;
          ansiblixPlaybook = import ./guf/update.nix;
          host = nodeConfig.networking.ipv4Address;
        };
      };
    };
  };
}
