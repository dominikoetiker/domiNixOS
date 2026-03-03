{
  pkgs-unstable,
  userConfig,
  ...
}:

{
  # Install the graphical interface and system tray icon
  environment.systemPackages = [
    pkgs-unstable.onedrive
    pkgs-unstable.onedrivegui
  ];

  # Autostart the GUI on login
  home-manager.users.${userConfig.username} = {
    xdg.configFile."autostart/OneDriveGUI.desktop".text = ''
      [Desktop Entry]
      Name=OneDriveGUI
      Comment=OneDrive GUI client
      Exec=${pkgs-unstable.onedrivegui}/bin/onedrivegui
      Icon=onedrive
      Terminal=false
      Type=Application
      Categories=Network;
      StartupNotify=false
    '';
    xdg.desktopEntries."OneDriveGUI" = {
      name = "OneDrive";
      comment = "Manage your OneDrive sync";
      exec = "onedrivegui";
      icon = "onedrive";
      terminal = false;
      categories = [
        "Network"
        "Utility"
      ];
    };
  };
}
