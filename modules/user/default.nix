{
  pkgs,
  config,
  userConfig,
  machineConfig,
  ...
}:

{
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.fullName;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Home Manager
  home-manager.users.${userConfig.username} =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      home.username = userConfig.username;
      home.homeDirectory = "/home/${userConfig.username}";
      home.stateVersion = machineConfig.stateVersion;

      xdg.userDirs = {
        enable = true;
        createDirectories = true;

        # Only create the download directory
        download = "${config.home.homeDirectory}/Downloads";

        # Point all others to the home directory to prevent folder creation:
        desktop = "${config.home.homeDirectory}";
        documents = "${config.home.homeDirectory}";
        music = "${config.home.homeDirectory}";
        pictures = "${config.home.homeDirectory}";
        publicShare = "${config.home.homeDirectory}";
        templates = "${config.home.homeDirectory}";
        videos = "${config.home.homeDirectory}";
      };

      # Create the project directories defined in settings.nix
      home.activation.createProjectDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${builtins.concatStringsSep "\n" (map (dir: "$DRY_RUN_CMD mkdir -p ${dir}") userConfig.projectDirs)}
      '';
    };
}
