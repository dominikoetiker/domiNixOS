{
  pkgs,
  pkgs-unstable,
  machineConfig,
  hardwareConfig,
  ...
}:

{
  imports = [
  ];

  # Networking.
  networking.hostName = machineConfig.hostName;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Boot
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    plymouth = {
      enable = true;
      theme = "spinner";
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true;

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "nvme_core.default_ps_max_latency_us=0"
    ];

    initrd.kernelModules = [
      hardwareConfig.kernelModules.gpu
    ];
  };

  # --- Garbage Collection ---
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages.
  environment.systemPackages = with pkgs; [

    # --- Browsers ---
    google-chrome

    # --- Communication ---
    element-desktop
    pkgs-unstable.signal-desktop
    pkgs-unstable.ferdium

    # --- Compression tools ---
    p7zip
    unrar
    unzip

    # --- Development: IDEs and Editors ---
    pkgs-unstable.jetbrains.idea
    pkgs-unstable.jetbrains.pycharm
    pkgs-unstable.jetbrains.webstorm
    pkgs-unstable.vscode

    # --- Development: Languages ---
    jdk
    jdk11
    jdk17
    jdk21
    jdk25
    jetbrains.jdk
    nodejs
    python3
    typescript

    # --- Development: Tools ---
    eslint
    jq
    prettier

    # --- Documents and Office ---
    librsvg
    mermaid-cli
    mermaid-filter
    libreoffice-fresh
    hunspell
    hunspellDicts.de_CH
    hunspellDicts.en_US
    hyphenDicts.de_CH
    hyphenDicts.en_US
    pandoc
    pandoc-plantuml-filter
    haskellPackages.pandoc-crossref
    haskellPackages.pandoc-lua-engine
    ocrmypdf
    pdfarranger
    pdfgrep
    pdftk
    plantuml
    poppler-utils
    texliveFull
    xournalpp

    # --- File management ---
    transmission_4-gtk

    # --- Graphics and multimedia ---
    gimp
    imagemagick
    exiftool

    # --- Hardware support ---
    brscan4
    mesa

    # --- Remote access ---
    openssh

    # --- Security ---
    borgbackup

    # --- System and CLI tools ---
    bat
    btop
    eza
    fastfetch
    fd
    fzf
    gcc
    gnumake
    ncdu
    psmisc
    ripgrep
    tree
    wget
  ];

  # Time zone & Locale.
  time.timeZone = machineConfig.timeZone;
  i18n.defaultLocale = machineConfig.defaultLocale;

  # Regional settings.
  i18n.extraLocaleSettings = {
    LC_ADDRESS = machineConfig.extraLocale;
    LC_IDENTIFICATION = machineConfig.extraLocale;
    LC_MEASUREMENT = machineConfig.extraLocale;
    LC_MONETARY = machineConfig.extraLocale;
    LC_NAME = machineConfig.extraLocale;
    LC_NUMERIC = machineConfig.extraLocale;
    LC_PAPER = machineConfig.extraLocale;
    LC_TELEPHONE = machineConfig.extraLocale;
    LC_TIME = machineConfig.extraLocale;
  };

  # Adapt keybord layout.
  console.useXkbConfig = true;

  # Enable flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Services.

  # Enable CUPS to print documents.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Firewall
  networking.firewall.enable = true;

  # NixOS release
  system.stateVersion = machineConfig.stateVersion;
}
