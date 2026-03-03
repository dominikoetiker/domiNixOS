{
  pkgs,
  config,
  ...
}:

{
  # Install the graphical interface and system tray icon
  environment.systemPackages = with pkgs; [
    onedrive
    onedrivegui
  ];
}
