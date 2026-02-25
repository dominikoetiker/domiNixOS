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

        # --- Git Prompt (vcs_info) ---
        autoload -Uz vcs_info

        function update_git_prompt() {
          vcs_info
          local untracked_status=""
          if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" && \
                -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]]; then
            untracked_status="%F{cyan}U%f"
          fi
          
          GIT_PROMPT_STRING=" ''${vcs_info_msg_0_}''${untracked_status}"
        }
        precmd_functions+=(update_git_prompt)

        zstyle ':vcs_info:*' enable git
        zstyle ':vcs_info:*' check-for-changes true
        zstyle ':vcs_info:git:*' stagedstr "%F{green}+%f"
        zstyle ':vcs_info:git:*' unstagedstr "%F{red}*%f"
        zstyle ':vcs_info:git:*' formats 'on %F{yellow} %b%f %c%u'

        # --- Prompt ---
        PROMPT='%F{blue}%~%f%F{white}$GIT_PROMPT_STRING%f %# '

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
