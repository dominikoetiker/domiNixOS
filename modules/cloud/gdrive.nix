{ pkgs, userConfig, ... }:

{
  environment.systemPackages = with pkgs; [
    rclone
    libsecret
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
