{
  pkgs,
  config,
  ...
}:

{
  # Enable OneDrive client for Linux
  services.onedrive.enable = true;

  # Install the graphical interface and system tray icon
  environment.systemPackages = with pkgs; [
    onedrivegui
  ];
}
