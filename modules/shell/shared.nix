{ userConfig, ... }:

{
  home-manager.users.${userConfig.username} = {
    home = {
      # --- Environment Variables ---
      sessionVariables = {
        VISUAL = "nvim";
        EDITOR = "nvim";
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        FZF_DEFAULT_OPTS = "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8";
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

        # ls replacement with icons and color
        ls = "eza --color=auto --icons";
        ll = "eza -l --icons --git";
        la = "eza -la --icons --git";
        l = "eza -F --icons";

        # colorize other tools
        grep = "grep --color=auto";
        tree = "eza --tree --icons";
        ip = "ip -color=auto";

        # colorized concatenator replacement
        cat = "bat";

        # NixOS configuration management
        nfu = "nix flake update --flake ~/.dominixos";
        nrs = "sudo nixos-rebuild switch --flake ~/.dominixos";
      };
    };
  };
}
