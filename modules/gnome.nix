{
  config,
  pkgs,
  lib,
  ...
}:
{

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = with pkgs; [
          gnomeExtensions.dash-to-dock.extensionUuid
          gnomeExtensions.just-perfection.extensionUuid
          gnomeExtensions.power-tracker.extensionUuid
        ];

      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        num-workspaces = 1;
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = false;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        click-method = "areas";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
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
      };

      "org/gnome/shell/extensions/just-perfection" = {
        activities-button = false;
      };

      "org/gnome/shell/extensions/powertracker" = {
        refreshrate = 1;
      };
    };
  };
}
