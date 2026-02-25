{ userConfig, ... }:

{
  home-manager.users.${userConfig.username} = {

    # Git
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = userConfig.fullName;
          email = userConfig.email;
        };
      };
      settings = {
        init.defaultBranch = "main";
        fetch.prune = true;
        core.autocrlf = "input";

        # Generate credential blocks for each URL in settings.nix
        credential = builtins.listToAttrs (
          map (url: {
            name = url;
            value = {
              helper = [
                "" # Clears the default helper
                "!op plugin run -- gh auth git-credential"
              ];
            };
          }) userConfig.gitCredentialUrls
        );
      };
    };

    # Github CLI
    programs.gh = {
      enable = true;
    };

    # LazyGit
    programs.lazygit = {
      enable = true;
    };
  };
}
