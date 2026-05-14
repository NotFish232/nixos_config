{
  pkgs,
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
    wl-clipboard
    file
    ripgrep
    gnupg
    ffmpeg

    fastfetch
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
