{
  pkgs,
  userConfig,
  ...
}:

{
  # Enable the Docker daemon
  virtualisation.docker.enable = true;

  # Add user to the docker group
  users.users.${userConfig.username}.extraGroups = [ "docker" ];

  # Install Docker-related tools
  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker
  ];
}
