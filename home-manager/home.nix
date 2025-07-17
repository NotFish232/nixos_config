# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  # nixpkgs = {
  #   # You can add overlays here
  #   overlays = [
  #     # If you want to use overlays exported from other flakes:
  #     # neovim-nightly-overlay.overlays.default

  #     # Or define it inline, for example:
  #     # (final: prev: {
  #     #   hi = final.hello.overrideAttrs (oldAttrs: {
  #     #     patches = [ ./change-hello-to-hi.patch ];
  #     #   });
  #     # })
  #   ];
  #   # Configure your nixpkgs instance
  #   config = {
  #     # Disable if you don't want unfree packages
  #     allowUnfree = true;
  #     # Workaround for https://github.com/nix-community/home-manager/issues/2942
  #     allowUnfreePredicate = _: true;
  #   };
  # };

  home = {
    username = "justin";
    homeDirectory = "/home/justin";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # Applications
    google-chrome
    discord
    spotify
    vscode   

    # CLI's
    leetcode-cli
    file
    neofetch
    gnupg
    git
    gh
    cloc
    acpi
    lm_sensors
    gnumake
    cmake
    gradle
    vim
    neovim
    docker

    # Tools
    mypy
    ripgrep

    # Programming Languages
    (pkgs.buildEnv {
      name = "multi-python";
      paths = [ python310 python314 ];
      ignoreCollisions = true; 
    })
    rustup
    gcc
    nodejs_24
    jdk24
    flutter
  ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
  };

  # Install Home Manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
