{
  nodeConfig,
  masterConfig,
  ...
}: {
  deployment = {
    targetHost = nodeConfig.networking.ipv4Address;
    targetPort = masterConfig.deployment.port;
    targetUser = masterConfig.deployment.userName;
  };

  nix.settings.trusted-users = [masterConfig.deployment.userName];

  users.users."${masterConfig.deployment.userName}" = {
    openssh.authorizedKeys.keys = [masterConfig.deployment.publicKey];
    extraGroups = ["wheel"];
    isNormalUser = true;
  };

  security.sudo.extraRules = [
    {
      users = [masterConfig.deployment.userName];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
