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
        v = "nvim";
        vi = "nvim";
        vim = "nvim";

        ls = "ls --color=auto";
        grep = "grep --color=auto";

        ll = "ls -lF";
        la = "ls -lAF";
        l = "ls -F";

        nix-update = "sudo nixos-rebuild switch --flake ~/.dominixos";
      };
    };
  };
}
