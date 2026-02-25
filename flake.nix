{
  description = "DomiNix OS - An opinionated NixOS configuration for me";

  inputs = {
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    { self, nixvim, ... }:
    {
      nixosModules = {
        base = import ./modules/base/default.nix;
        fonts = import ./modules/base/fonts.nix;
        git = import ./modules/tools/git.nix;
        gnome = import ./modules/desktop/gnome.nix;
        displaylink = import ./modules/hardware/displaylink.nix;
        security_1password = import ./modules/security/security_1password.nix;
        user = import ./modules/user/default.nix;
        zsh = import ./modules/shell/zsh.nix;
        bash = import ./modules/shell/bash.nix;
        tmux = import ./modules/tools/tmux.nix;
        docker = import ./modules/tools/docker.nix;
        virtualization = import ./modules/virtualization/default.nix;
        fingerprint = import ./modules/hardware/fingerprint.nix;
        onedrive = import ./modules/cloud/onedrive.nix;

        nixvim = {
          imports = [
            nixvim.nixosModules.nixvim
            ./modules/editors/nixvim.nix
          ];
        };
      };
    };
}
