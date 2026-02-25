{
  pkgs,
  lib,
  ...
}:

{
  # Create directory and store fonts there /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  # Default font-config
  fonts.fontconfig.enable = true;

  # Install fonts
  fonts.packages = with pkgs; [

    # Google Fonts
    google-fonts
    roboto
    roboto-flex
    roboto-mono
    roboto-serif
    roboto-slab

    # Linux default fonts
    liberation_ttf
    libertine
    libertine-g
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    ubuntu-classic
    ubuntu-sans
    ubuntu-sans-mono

    # Microsoft fonts and similar
    caladea
    carlito
    corefonts
    vista-fonts

    # Nerd Fonts
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.liberation
    nerd-fonts.noto
    nerd-fonts.roboto-mono
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans

    # Other fonts
    dejavu_fonts
    hack-font
    lato
  ];
}
