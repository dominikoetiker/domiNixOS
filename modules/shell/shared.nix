{ pkgs, userConfig, ... }:

let
  # --- Update workflow ---

  # Update, Build & Diff (nuc = Nix Update Check)
  nix-update-check = pkgs.writeShellScriptBin "nuc" ''
    echo "Updating flake.lock..."
    nix flake update --flake ~/.dominixos

    echo "Building system in the background..."
    # --out-link creates the result symlink in /tmp to keep the working directory clean
    nixos-rebuild build --flake ~/.dominixos --out-link /tmp/nixos-update-result

    echo "Comparing versions..."
    # Save the uncolored output for the subsequent Git commit
    ${pkgs.nvd}/bin/nvd --color never diff /run/current-system /tmp/nixos-update-result > /tmp/nixos-update-diff.txt

    # Display the colored output in the terminal
    ${pkgs.nvd}/bin/nvd --color always diff /run/current-system /tmp/nixos-update-result
  '';

  # Commit updates (nco = Nix Commit)
  nix-commit-update = pkgs.writeShellScriptBin "nco" ''
    if [ ! -f /tmp/nixos-update-diff.txt ]; then
      echo "Error: No update information found. Please run 'nuc' first."
      exit 1
    fi

    cd ~/.dominixos
    git add flake.lock

    # Create the commit message
    echo "chore: update flake.lock and system" > /tmp/nixos-commit-msg.txt
    echo "" >> /tmp/nixos-commit-msg.txt

    # Append only the relevant lines (Upgrades [U], Downgrades [D], etc.) to the message
    grep -E '\[U\]|\[D\]|\[N\]|\[C\]' /tmp/nixos-update-diff.txt >> /tmp/nixos-commit-msg.txt

    # Execute the commit using the file as the message
    git commit -F /tmp/nixos-commit-msg.txt

    echo "Commit created successfully."

    # Clean up temporary files and the symlink in /tmp
    rm -f /tmp/nixos-update-result /tmp/nixos-update-diff.txt /tmp/nixos-commit-msg.txt
  '';

in
{
  home-manager.users.${userConfig.username} = {
    home = {

      # --- Installed user packages (including custom scripts and nvd) ---
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
        nrs = "sudo nixos-rebuild switch --flake ~/.dominixos";
      };
    };
  };
}
