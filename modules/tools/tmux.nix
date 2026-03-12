{
  pkgs,
  userConfig,
  lib,
  ...
}:

let
  # Import colors
  palettes = import ../theming/palettes.nix;
  colors = palettes.${userConfig.theme};

  # Get list of project directories from userConfig and format them
  bashArrayStr = lib.concatMapStringsSep "\n        " (dir: ''"${dir}"'') userConfig.projectDirs;

  # tmux sessionizer
  tsScript = pkgs.writeShellScriptBin "ts" ''
    find_and_select_project() {
      local search_dirs=(
        ${bashArrayStr}
      )
      ${pkgs.findutils}/bin/find "''${search_dirs[@]}" -mindepth 1 -maxdepth 1 -type d | ${pkgs.fzf}/bin/fzf
    }

    create_or_switch_to_session() {
      local selected_path="$1"
      [[ -z "$selected_path" ]] && exit 0

      local session_name
      session_name=$(${pkgs.coreutils}/bin/basename "$selected_path" | ${pkgs.coreutils}/bin/tr '.:' '_')

      if ! ${pkgs.tmux}/bin/tmux has-session -t="$session_name" 2>/dev/null; then
        ${pkgs.tmux}/bin/tmux new-session -ds "$session_name" -c "$selected_path"
      fi

      if [[ -n "$TMUX" ]]; then
        ${pkgs.tmux}/bin/tmux switch-client -t "$session_name"
      else
        ${pkgs.tmux}/bin/tmux attach-session -t "$session_name"
      fi
    }

    selected_dir=$(find_and_select_project)
    create_or_switch_to_session "$selected_dir"
  '';

in
{
  home-manager.users.${userConfig.username} = {
    # 'ts' command
    home.packages = [ tsScript ];

    # tmux configuration
    programs.tmux = {
      enable = true;

      shortcut = "Space";
      escapeTime = 0;
      terminal = "tmux-256color";

      extraConfig = ''
        # -- Core Settings --
        set -ga terminal-overrides ",screen-256color*:sitm=\E[3m,ritm=\E[23m,smso=\E[1m,rmso=\E[22m"
        set -as terminal-features ",xterm-256color:RGB"
        set-option -g focus-events on
        set-option -g detach-on-destroy off
        set-option -g update-environment "DISPLAY WAYLAND_DISPLAY XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS SSH_AUTH_SOCK"

        # -- Keybindings --
        # (Note: Home Manager unbinds C-b and binds C-Space automatically due to shortcut = "Space" above)

        # Pane navigation
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        # Kill session confirmation
        bind-key X confirm-before -p "kill-session #S? (y/n)" kill-session
        bind-key S choose-tree -s

        # Bind 's' to popup window with absolute Nix script path!
        bind-key s display-popup -w 80% -h 80% -E "${tsScript}/bin/ts"

        # Jump back to session root (only if in Zsh or Bash)
        bind-key r if-shell 'echo "#{pane_current_command}" | grep -qE "zsh|bash|sh"' 'send-keys "cd \"\$(tmux display-message -p -F \"#{session_path}\")\"" C-m' 'display-message "Requires a shell! (Currently: #{pane_current_command})"'

        # -----------------------------------------------------------------------------
        # -- SYSTEM THEME
        # -----------------------------------------------------------------------------

        # -- Status Bar --
        set -g status-position top
        set -g status-justify left
        set -g status-style "fg=${colors.fg},bg=${colors.bg_alt}"

        # Left side: Session Name (Using the primary theme color!)
        set -g status-left-length 150
        set -g status-left "#[fg=${colors.bg},bg=${colors.primary},bold]  #S #[default]"

        # Right side: Date and Time (Using purple/secondary accent)
        set -g status-right-length 150
        set -g status-right "#[fg=${colors.bg},bg=${colors.purple},bold] %d-%m-%Y | %H:%M #[default]"

        # Window tabs
        set -g window-status-format "#[fg=${colors.overlay0}] #I:#W #[default]"
        set -g window-status-current-format "#[fg=${colors.bg},bg=${colors.cyan},bold] #I:#W #[default]"

        # -- Panes --
        # Inactive borders use the dark overlay color
        set -g pane-border-style "fg=${colors.overlay0}"

        # Active pane uses the primary theme accent
        set -g pane-active-border-style "fg=${colors.primary}"

        # -- Messages / Command line --
        set -g message-style "fg=${colors.fg},bg=${colors.surface0}"
        set -g message-command-style "fg=${colors.fg},bg=${colors.surface0}"

        set -g set-titles on
        set -g set-titles-string 'tmux: #S | #W'
      '';
    };
  };
}
