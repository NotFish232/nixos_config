# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ../modules/gnome.nix
    ../modules/core_pkgs.nix
    ../modules/zsh.nix
    ../modules/tmux.nix
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
    libreoffice-fresh
    inkscape

    # CLI's
    leetcode-cli

    # Utilies
    nixfmt-rfc-style
    docker

    # Build Tools
    gnumake
    cmake
    mypy
    black
    pkg-config
    openssl

    # Programming Languages

    # Python
    (buildEnv {
      name = "multi-python";
      paths = [
        python314
        python310
      ];
      ignoreCollisions = true;
    })

    # Rust
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rustc"
      "rust-src"
      "rustfmt"
    ])
    rust-analyzer-nightly

    # C++
    gdb
    gcc
    clang-tools

    # JavaScript
    nodejs_24

    # Dart
    flutter

    # Latex
    (pkgs.texlive.combine {
      inherit (pkgs.texlive.pkgs)
        scheme-minimal
        latex-bin
        ;
    })
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = lib.concatStringsSep ":" [
      (lib.makeSearchPath "lib/pkgconfig" [
        pkgs.openssl.dev
      ])
      "$PKG_CONFIG_PATH"
    ];
    LD_LIBRARY_PATH = lib.concatStringsSep ":" [
      (lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.zlib
        pkgs.openssl.out
        pkgs.clang.cc.lib
      ])
      "$LD_LIBRARY_PATH"
    ];
  };

  # direnv and nix-direnv
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Install Home Manager
  programs.home-manager.enable = true;

  # add vcs none to cargo config
  home.file.".cargo/config.toml".text = ''
    [cargo-new]
    vcs = "none"
  '';

  # add clang formatting options to config
  home.file.".clang-format".text = ''
    BasedOnStyle: LLVM
    UseTab: Never
    IndentWidth: 4
    TabWidth: 4
    AllowShortIfStatementsOnASingleLine: false
    IndentCaseLabels: false
    ColumnLimit: 0
    AccessModifierOffset: -4
    FixNamespaceComments: false
  '';

  # Oh the horror
  programs.java = {
    enable = true;
    package = pkgs.jdk23.override { enableJavaFX = true; };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
