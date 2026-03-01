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

      # --- Aliases ---
      shellAliases = {
        # Neovim
        v = "nvim";
        vi = "nvim";
        vim = "nvim";

        # colorized output
        ls = "ls --color=auto";
        grep = "grep --color=auto";

        # ls variants
        ll = "ls -lF";
        la = "ls -lAF";
        l = "ls -F";

        # NixOS configuration management
        nfu = "nix flake update --flake ~/.dominixos";
        nrs = "sudo nixos-rebuild switch --flake ~/.dominixos";
      };
    };
  };
}
