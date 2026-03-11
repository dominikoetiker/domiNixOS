{ userConfig, ... }:

{
  home-manager.users.${userConfig.username} = {
    home = {
      # --- Environment Variables ---
      sessionVariables = {
        VISUAL = "nvim";
        EDITOR = "nvim";
        TEXMFHOME = "$HOME/.local/share/texmf";
        npm_config_prefix = "$HOME/.local";
      };

      # --- Prompt ---
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };

      # --- Aliases ---
      shellAliases = {
        # Neovim
        v = "nvim";
        vi = "nvim";
        vim = "nvim";

        # colorized grep
        grep = "grep --color=auto";

        ## ls variants
        #ls = "ls --color=auto";
        #ll = "ls -lF";
        #la = "ls -lAF";
        #l = "ls -F";

        # ls replacement with icons and color
        ls = "eza --color=auto --icons";
        ll = "eza -l --icons --git";
        la = "eza -la --icons --git";
        l = "eza -F --icons";

        # colorized concatenator
        cat = "bat";

        # NixOS configuration management
        nfu = "nix flake update --flake ~/.dominixos";
        nrs = "sudo nixos-rebuild switch --flake ~/.dominixos";
      };
    };
  };
}
