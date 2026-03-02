{ pkgs, userConfig, ... }:

{
  environment.systemPackages = with pkgs; [
    ghostty
  ];

  home-manager.users.${userConfig.username} = {
    xdg.configFile."ghostty/config".text = ''
      # Theme
      theme = catppuccin-mocha

      # Fonts
      font-family = "JetBrainsMono Nerd Font"
      font-size = 12

      # Hide mouse cursor when typing
      mouse-hide-while-typing = true
    '';
  };
}
