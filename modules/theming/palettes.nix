{
  catppuccin-mocha = {
    # -- Backgrounds --
    bg_dim = "#11111b"; # crust (darkest)
    bg_alt = "#181825"; # mantle (slightly darker)
    bg = "#1e1e2e"; # base (default background)

    # -- Surfaces (Elevations/UI Backgrounds) --
    surface0 = "#313244";
    surface1 = "#45475a";
    surface2 = "#585b70";

    # -- Overlays (Borders/Dividers/Inactive elements) --
    overlay0 = "#6c7086";
    overlay1 = "#7f849c";
    overlay2 = "#9399b2";

    # -- Foreground/Text --
    fg_dim = "#a6adc8"; # subtext0
    fg_alt = "#bac2de"; # subtext1
    fg = "#cdd6f4"; # text (default text)

    # -- Core Accents --
    red = "#f38ba8";
    orange = "#fab387"; # peach
    yellow = "#f9e2af";
    green = "#a6e3a1";
    cyan = "#89dceb"; # sky
    blue = "#89b4fa";
    purple = "#cba6f7"; # mauve
    pink = "#f5c2e7";

    # -- Extended Accents (Optional, but nice to have) --
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    teal = "#94e2d5";
    sapphire = "#74c7ec";
    lavender = "#b4befe";

    # -- Semantic Aliases --
    # This is the secret sauce. You define what the "main" accent is for this theme.
    primary = "#cba6f7"; # Mauve Catppuccin's signature color
    alert = "#f38ba8"; # Red
    warning = "#f9e2af"; # Yellow
    success = "#a6e3a1"; # Green
    info = "#89b4fa"; # Blue
  };

  gruvbox-dark = {
    # -- Backgrounds --
    bg_dim = "#1d2021"; # bg0_h
    bg_alt = "#282828"; # bg0
    bg = "#282828"; # bg

    # -- Surfaces (Elevations/UI Backgrounds) --
    surface0 = "#32302f"; # bg1
    surface1 = "#3c3836"; # bg2
    surface2 = "#504945"; # bg3

    # -- Overlays (Borders/Dividers/Inactive elements) --
    overlay0 = "#665c54"; # bg4
    overlay1 = "#7c6f64"; # gray
    overlay2 = "#928374"; # gray

    # -- Foreground/Text --
    fg_dim = "#a89984"; # fg4
    fg_alt = "#bdae93"; # fg3
    fg = "#ebdbb2"; # fg

    # -- Core Accents --
    red = "#cc241d";
    orange = "#d65d0e";
    yellow = "#d79921";
    green = "#98971a";
    cyan = "#689d6a";
    blue = "#458588";
    purple = "#b16286";
    pink = "#d3869b";

    # -- Extended Accents (Fallback to core accents if theme lacks them) --
    rosewater = "#d3869b";
    flamingo = "#d3869b";
    teal = "#8ec07c";
    sapphire = "#83a598";
    lavender = "#d3869b";

    # -- Semantic Aliases --
    primary = "#d79921";
    alert = "#cc241d";
    warning = "#d79921";
    success = "#98971a";
    info = "#458588";
  };
}
