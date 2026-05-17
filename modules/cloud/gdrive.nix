{ pkgs, userConfig, ... }:

{
  environment.systemPackages = with pkgs; [
    rclone
    libsecret
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  home-manager.users.${userConfig.username} =
    { pkgs, ... }:
    {
      xdg.configFile."rclone/bisync-filters.txt".text = ''
        - .DS_Store
        - **/.Trash/**
        - **/*.swp
        - **/*.tmp
        - .~lock.*
        - **/.cache/**
      '';

      systemd.user.services.rclone-gdrive-bisync =
        let
          syncScript = pkgs.writeShellApplication {
            name = "rclone-gdrive-sync";
            runtimeInputs = [
              pkgs.libsecret
              pkgs.rclone
            ];
            text = ''
              secret-tool lookup rclone gdrive > "$STATE_DIRECTORY/rclone.conf"
              chmod 600 "$STATE_DIRECTORY/rclone.conf"
              cp "$HOME/.config/rclone/bisync-filters.txt" \
                "$STATE_DIRECTORY/bisync-filters.txt"

              rclone bisync \
                gdrive: "$HOME/GoogleDrive" \
                --create-empty-src-dirs \
                --drive-export-formats link.html \
                --compare size,modtime \
                --check-access \
                --conflict-resolve none \
                --conflict-loser pathname \
                --conflict-suffix \
                "cloud-{2006-01-02_150405},local-{2006-01-02_150405}" \
                --suffix-keep-extension \
                --filter-from "$STATE_DIRECTORY/bisync-filters.txt" \
                --fast-list \
                --transfers 16 \
                --checkers 16 \
                --tpslimit 10 \
                --retries 3 \
                --max-lock 3m \
                --recover \
                --resilient \
                --drive-acknowledge-abuse \
                --max-delete 50 \
                --log-file "$STATE_DIRECTORY/bisync.log" \
                --verbose \
                --config "$STATE_DIRECTORY/rclone.conf"

              rm "$STATE_DIRECTORY/rclone.conf"
            '';
          };
        in
        {
          Unit = {
            Description = "Bidirectional Sync for Google Drive";
          };
          Service = {
            Type = "oneshot";
            TimeoutStartSec = 3600;
            StateDirectory = "rclone-gdrive";
            ExecStart = pkgs.lib.getExe syncScript;
            Environment = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus";
          };
        };

      systemd.user.timers.rclone-gdrive-bisync = {
        Unit = {
          Description = "Pacing Timer for Google Drive Bisync";
        };
        Timer = {
          OnStartupSec = "2m";
          OnUnitInactiveSec = "10m";
          RandomizedDelaySec = "30s";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      home.shellAliases = {
        sync-drive = "systemctl --user start rclone-gdrive-bisync.service";
      };
    };
}
