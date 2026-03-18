{ pkgs, userConfig, ... }:

{
  # activate Thunderbird
  programs.thunderbird.enable = true;

  # install Birdtray for Thunderbird system tray icon
  environment.systemPackages = [ pkgs.birdtray ];

  # add autostart entry for Birdtray
  home-manager.users.${userConfig.username} = {
    xdg.configFile."autostart/birdtray.desktop".text = ''
      [Desktop Entry]
      Name=Birdtray
      Comment=System tray icon for Thunderbird
      Exec=${pkgs.birdtray}/bin/birdtray
      Icon=birdtray
      Terminal=false
      Type=Application
      Categories=Network;Email;
      StartupNotify=false
    '';
  };
}
