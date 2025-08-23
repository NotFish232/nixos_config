{
  config,
  pkgs,
  lib,
  ...
}:

{
  config.home.packages = with pkgs; [
    vim

    git
    gh

    tmux
    xclip
    file
    gnupg
    ffmpeg

    neofetch
    cloc
    htop
    btop
    acpi
    lm_sensors

    zip
    unzip
    lrzip
  ];
}
