{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = {
    home.packages = with pkgs; [
      gnomeExtensions.dash-to-dock
      gnomeExtensions.just-perfection
      gnomeExtensions.power-tracker
      gnomeExtensions.bluetooth-battery-meter
    ];

    home.file.".config/backgrounds/wallpaper.png".source = ../assets/wallpaper.png;

    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "code.desktop"
            "org.gnome.Console.desktop"
            "google-chrome.desktop"
            "spotify.desktop"
            "discord.desktop"
            "obsidian.desktop"
            "org.gnome.SystemMonitor.desktop"
          ];
          enabled-extensions = with pkgs; [
            gnomeExtensions.dash-to-dock.extensionUuid
            gnomeExtensions.just-perfection.extensionUuid
            gnomeExtensions.power-tracker.extensionUuid
            gnomeExtensions.bluetooth-battery-meter.extensionUuid
          ];

        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          num-workspaces = 1;
        };

        "org/gnome/mutter" = {
          dynamic-workspaces = false;
          experimental-features = [ "variable-refresh-rate" ];
        };

        "org/gnome/desktop/peripherals/touchpad" = {
          click-method = "areas";
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          clock-format = "12h";
          show-battery-percentage = true;
        };

        "org/gnome/desktop/background" = {
          picture-uri = "file://${config.home.homeDirectory}/.config/backgrounds/wallpaper.png";
          picture-uri-dark = "file://${config.home.homeDirectory}/.config/backgrounds/wallpaper.png";
        };

        "org/gnome/shell/extensions/dash-to-dock" = {
          dock-position = "LEFT";
          dock-fixed = true;
          disable-overview-on-startup = true;
          extend-height = true;
          always-center-icons = true;
          transparency-mode = "FIXED";
          background-opacity = 0.2;
          show-show-apps-button = false;
          running-indicator-style = "DOTS";
          custom-theme-shrink = true;
        };

        "org/gnome/shell/extensions/just-perfection" = {
          activities-button = false;
          startup-status = 0;
        };

        "org/gnome/shell/extensions/powertracker" = {
          refreshrate = 1;
        };

        "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
          enable-battery-level-icon = true;
          enable-battery-level-text = true;
        };
      };
    };
  };
}
