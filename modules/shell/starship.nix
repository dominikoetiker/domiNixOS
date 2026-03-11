{
  userConfig,
  ...
}:

let
  # load colors from theme file
  palettes = import ../theming/palettes.nix;
  colors = palettes.${userConfig.theme};
in
{
  home-manager.users.${userConfig.username} = {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

      settings = {
        add_newline = false;

        line_break = {
          disabled = true;
        };

        character = {
          success_symbol = "[❯](bold ${colors.green})";
          error_symbol = "[❯](bold ${colors.red})";
        };

        directory = {
          style = "bold ${colors.blue}";
          truncation_length = 3;
          truncate_to_repo = true;
          read_only = " 󰌾";
        };

        git_branch = {
          symbol = " ";
          style = "bold ${colors.primary}";
          format = "on [$symbol$branch]($style) ";
        };

        git_status = {
          style = "bold ${colors.red}";
          format = "([$all_status$ahead_behind]($style) )";
        };

        cmd_duration = {
          style = "${colors.yellow}";
          format = "took [$duration]($style) ";
        };

        nix_shell = {
          symbol = " ";
          style = "bold ${colors.cyan}";
          format = "via [$symbol$state]($style) ";
        };
      };
    };
  };
}
