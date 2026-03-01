{
  config,
  pkgs,
  userConfig,
  ...
}:

{

  # Add user to the docker group
  users.users.${userConfig.username}.extraGroups = [ "input" ];

  # enable fingerprint reader
  services.fprintd.enable = true;
}
