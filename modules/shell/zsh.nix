{ pkgs, userConfig, ... }:

{
  imports = [ ./shared.nix ];

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  home-manager.users.${userConfig.username} = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;

      shellAliases = {
      };

      history = {
        size = 10000;
        save = 10000;
        path = "$HOME/.zsh_history";
        share = false;
      };

      # --- Extra Initialization ---
      initContent = ''
        # --- Shell Options ---
        setopt appendhistory inc_append_history prompt_subst

        # --- Keybindings ---
        bindkey -e
        bindkey '^[[1;5A' history-substring-search-up   # Control + up
        bindkey '^[[1;5B' history-substring-search-down # Control + down

        # --- Autocompletion for eza aliases ---
        compdef la=ls
        compdef ll=ls
        compdef l=ls

        # --- 1Password Shell Plugins Integration ---
        if [ -r ~/.config/op/plugins.sh ]; then
            source ~/.config/op/plugins.sh
        fi

        # --- Angular CLI Autocompletion ---
        if command -v ng >/dev/null 2>&1; then
          source <(ng completion script)
        fi
      '';
    };
  };
}
