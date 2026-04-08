{
  pkgs,
  pkgs-unstable,
  machineConfig,
  userConfig,
  ...
}:

{
  services.xserver = {
    enable = true;
    xkb = {
      layout = machineConfig.xkb.layout;
      variant = machineConfig.xkb.variant;
      options = "caps:swapescape";
    };
    excludePackages = with pkgs; [
      pkgs.xterm
    ];
    videoDrivers = [ "modesetting" ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      sessionPath = [ pkgs.gdm ];
    };
    udev.packages = with pkgs; [
      pkgs.gnome-settings-daemon
    ];
  };

  # Add option to open ghostty from nautilus
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  # Exclude blotware from Gnome
  environment.gnome.excludePackages = (
    with pkgs;
    [
      epiphany
      firefox
      geary
      gnome-boxes
      gnome-calendar
      gnome-connections
      gnome-contacts
      gnome-console
      gnome-font-viewer
      gnome-maps
      gnome-music
      gnome-software
      gnome-text-editor
      gnome-tour
      gnome-weather
      yelp
    ]
  );

  # Include essential gnome apps and tools.
  environment.systemPackages = with pkgs; [
    baobab # Gnome Disk Usage Analyzer
    citations # Gnome BibTeX bibliography manager
    decibels # Gnome Audio
    gaphor # Gnome UML diagram editor
    gnome-calculator
    gnome-characters
    gnome-clocks
    gnome-control-center
    gnome-decoder # Gnome QR code reader and generator
    gnome-disk-utility
    gnome-graphs # Plot and and manipulate data
    gnome-logs
    gnome-solanum # Pomodoro timer
    gnome-system-monitor
    gnome-tweaks
    hieroglyphic # Gnome tool to filnd LaTeX symbols
    lorem # Gnome Lorem Ipsum generator
    loupe
    nautilus
    nautilus-python
    pkgs-unstable.papers
    raider # Gnome File Shredder
    showtime
    simple-scan
    snapshot
  ];

  programs.dconf.enable = true;

  home-manager.users.${userConfig.username} =
    { pkgs, ... }:

    {

      home.packages = with pkgs; [
        gnomeExtensions.appindicator # System tray icons
        yaru-theme # Ubuntu like icon theme, etc.
        gnomeExtensions.blur-my-shell # Blur Gnome Shell background
        gnomeExtensions.tiling-assistant # Tiling window management for Gnome
        gnomeExtensions.dash-to-dock # Gnome Dash customization and enhancement
        gnomeExtensions.clipboard-indicator # Clipboard manager for Gnome Shell
      ];

      # Dconf settings for Gnome desktop (user level).
      dconf.settings = {

        # Interface look
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Yaru-dark";
          show-battery-percentage = true;
          icon-theme = "Yaru"; # Ubuntu like icon theme
        };

        # Mark Caps Lock as Escape.
        "org/gnome/desktop/input-sources" = {
          xkb-options = [
            "caps:swapescape"
          ];
        };

        # Shell settings.
        "org/gnome/shell" = {

          # Activate Gnome extensions.
          disable-user-extensions = false;
          disable-extension-version-validation = true;
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com" # System Tray.
            "blur-my-shell@aunetx" # Blur Gnome Shell background.
            "clipboard-indicator@tudmotu.com" # Clipboard manager for Gnome Shell.
            "dash-to-dock@micxgx.gmail.com" # Gnome Dash customization and enhancement.
            "tiling-assistant@leleat-on-github" # Tiling window management for Gnome.
          ];
          disabled-extensions = [ ];

          # Dash
          favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "com.mitchellh.ghostty.desktop"
            "google-chrome.desktop"
            "thunderbird.desktop"
            "writer.desktop"
            "calc.desktop"
            "signal.desktop"
            "element-desktop.desktop"
            "1password.desktop"
          ];
        };

        # Maximize and Minimize Buttons.
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
        };

        # Window manager
        "org/gnome/mutter" = {
          # Workspaces on all displays.
          workspaces-only-on-primary = false;
          # Fractional scaling
          experimental-features = [ "scale-monitor-framebuffer" ];
        };

        # App Folders
        "org/gnome/desktop/app-folders" = {
          folder-children = [
            "System"
          ];
        };
        "org/gnome/desktop/app-folders/folders/System" = {
          name = "System";
          translate = false;
          apps = [
            "org.gnome.Settings.desktop"
            "org.gnome.tweaks.desktop"
            "org.gnome.baobab.desktop"
            "org.gnome.DiskUtility.desktop"
            "org.gnome.SystemMonitor.desktop"
            "cups.desktop"
            "org.gnome.Logs.desktop"
            "org.gnome.Extensions.desktop"
            "btop.desktop"
            "nixos-manual.desktop"
            "org.gnome.seahorse.Application.desktop"
          ];
        };

        # Keybindings.
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>t";
          command = "ghostty";
          name = "Terminal";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<Super>e";
          command = "nautilus --new-window";
          name = "File Browser";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          binding = "<Super>b";
          command = "google-chrome-stable";
          name = "Web Browser";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
          binding = "<Super><Shift>p";
          command = "1password --quick-access";
          name = "Password Manager";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
          binding = "<Super><Shift>t";
          command = "ghostty -e ts";
          name = "Tmux Sessionizer";
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
          ];
        };
      };
    };
}
