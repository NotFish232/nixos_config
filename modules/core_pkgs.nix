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
    git-lfs

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
