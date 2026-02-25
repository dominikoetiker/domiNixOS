{
  config,
  pkgs,
  ...
}:

{
  # load evdi module at boot time
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    initrd.kernelModules = [ "evdi" ];
  };

  # define drivers for Xserver
  services.xserver.videoDrivers = [ "modesetting" ];

  # install displaylink package
  environment.systemPackages = with pkgs; [ 
    displaylink 
  ];

  # start the DisplayLink systemd service
  systemd.services.displaylink-server = {
    enable = true;
    requires = [ "systemd-udevd.service" ];
    after = [ "systemd-udevd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.displaylink}/bin/DisplayLinkManager";
      User = "root";
      Group = "root";
      Restart = "on-failure";
      RestartSec = 5; 
    };
  };
}