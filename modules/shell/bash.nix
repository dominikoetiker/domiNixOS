{ userConfig, ... }:

{
  imports = [ ./shared.nix ];

  users.defaultUserShell = pkgs.bashInteractive;

  home-manager.users.${userConfig.username} = {
    programs.bash = {
      enable = true;

      # --- History Configuration ---
      historySize = 1000;
      historyFileSize = 2000;
      historyControl = [
        "ignoredups"
        "ignorespace"
      ];

      # --- Shell Options ---
      shellOptions = [
        "histappend"
        "checkwinsize"
      ];

      # --- Extra Initialization ---
      initExtra = ''
        PS1='[\u@\h \W]\$ '
      '';
    };
  };
}
