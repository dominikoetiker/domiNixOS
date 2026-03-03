{ pkgs, userConfig, ... }:

{
  home-manager.users.${userConfig.username} = {

    programs.ghostty = {
      enable = true;

      # Activate Shell integration
      enableBashIntegration = true;
      enableZshIntegration = true;

      # Theming
      settings = {
        theme = "Catppuccin Mocha";
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;
        mouse-hide-while-typing = true;
      };
    };
    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = [ "com.mitchellh.ghostty.desktop" ];
      };
    };
  };
}
