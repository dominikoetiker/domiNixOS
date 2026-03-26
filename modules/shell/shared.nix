{ pkgs, userConfig, ... }:

let
  # -------------------------------------------------------------------------
  # Global Variables for Scripts
  # -------------------------------------------------------------------------
  flakeDir = "$HOME/.dominixos";
  cacheDir = "$HOME/.cache/nixos-update";
  resultLink = "${cacheDir}/nixos-update-result";
  diffFile = "${cacheDir}/nixos-update-diff.txt";
  msgFile = "${cacheDir}/nixos-commit-msg.txt";

  # -------------------------------------------------------------------------
  # Update workflow
  # -------------------------------------------------------------------------

  # Update, Build & Diff (nuc = Nix Update Check)
  nix-update-check = pkgs.writeShellScriptBin "nuc" ''
    echo "Updating flake.lock..."
    nix flake update --flake ${flakeDir}

    echo "Building system in the background..."
    mkdir -p ${cacheDir}
    cd ${cacheDir} || exit 1
    rm -f result ${resultLink} ${diffFile}

    # Run the build process
    if nixos-rebuild build --flake ${flakeDir}; then
      mv result ${resultLink}
    else
      echo "Error: Build failed. Aborting."
      exit 1
    fi

    echo "Comparing versions..."
    ${pkgs.nvd}/bin/nvd --color never diff /run/current-system ${resultLink} > ${diffFile}
    ${pkgs.nvd}/bin/nvd --color always diff /run/current-system ${resultLink}
  '';

  # Automatic Commit (nco = Nix Commit)
  nix-commit-update = pkgs.writeShellScriptBin "nco" ''
    if [ ! -f ${diffFile} ]; then
      echo "Error: No update information found. Please run 'nuc' first."
      exit 1
    fi

    git -C ${flakeDir} add flake.lock

    echo "chore: update flake.lock and system" > ${msgFile}
    echo "" >> ${msgFile}
    grep -E '\[[UDNC][*.]?\]' ${diffFile} >> ${msgFile}

    git -C ${flakeDir} commit -F ${msgFile}

    echo "Commit created successfully."
    rm -rf ${cacheDir}
  '';

in
{
  home-manager.users.${userConfig.username} = {
    home = {

      # --- Installed user packages ---
      packages = [
        pkgs.nvd
        nix-update-check
        nix-commit-update
      ];

      # --- Environment Variables ---
      sessionVariables = {
        VISUAL = "nvim";
        EDITOR = "nvim";
        FZF_DEFAULT_OPTS = "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8";
        TEXMFHOME = "$HOME/.local/share/texmf";
        npm_config_prefix = "$HOME/.local";

        # --- Colored Man Pages ---
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        MANROFFOPT = "-c";
      };

      # --- Aliases ---
      shellAliases = {
        # Neovim
        v = "nvim";
        vi = "nvim";
        vim = "nvim";

        # ls replacement with icons and color
        ls = "eza --color=auto --icons";
        ll = "eza -l --icons --git";
        la = "eza -la --icons --git";
        l = "eza -F --icons";

        # colorize other tools
        grep = "grep --color=auto";
        tree = "eza --tree --icons";
        ip = "ip -color=auto";

        # colorized concatenator replacement
        cat = "bat";

        # NixOS configuration management
        nrs = "sudo nixos-rebuild switch --flake ${flakeDir}";
      };
    };
  };
}
