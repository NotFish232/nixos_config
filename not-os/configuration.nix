# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.justin = import ./home.nix;
  home-manager.extraSpecialArgs = { inherit inputs; };

  # Swapfile
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32 GB
    }
  ];

  # Boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "not-os"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # Chinese support
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        kdePackages.fcitx5-chinese-addons
        fcitx5-nord
      ];
    };
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code

    # A separate variable family for Zed's UI: Fira Code plus circular Braille
    # glyphs, retaining Fira Code's normal weight axis.
    (runCommand "fira-code-braille" {
      nativeBuildInputs = [ (python3.withPackages (ps: [ ps.fonttools ])) ];
    } ''
        mkdir -p "$out/share/fonts/truetype/FiraCodeBraille"
        python ${../scripts/fira-code-braille.py} \
          "${fira-code}/share/fonts/truetype/FiraCode-VF.ttf" \
          "$out/share/fonts/truetype/FiraCodeBraille/FiraCodeBraille-VF.ttf"
    '')

    noto-fonts-cjk-sans # Chinese font
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.justin = {
    isNormalUser = true;
    description = "Justin Lee";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Add overlays for nixpkgs
  nixpkgs.overlays = [
    inputs.fenix.overlays.default
  ];

  # Settings for using IPAD as second monitor
  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };
  services.gnome.gnome-remote-desktop.enable = true;
  networking.firewall.allowedTCPPorts = [ 3389 ];
  # Work around invisible mouse cursors in GNOME Remote Desktop / Wayland RDP.
  environment.sessionVariables.MUTTER_DEBUG_DISABLE_HW_CURSORS = "1";

  # Enable nix-ld
  programs.nix-ld.enable = true;

  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable Steam
  programs.steam = {
    enable = true;
  };

  programs.gnupg.agent.enable = true;
  programs.zsh.enable = true;

  # Fix Times on Windows
  time.hardwareClockInLocalTime = true;

  # Tailscale
  services.tailscale.enable = true;

  # Switch to TLP for power profiles
  services.power-profiles-daemon.enable = true;
  # services.auto-cpufreq.enable = true;
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_BOOST_ON_BAT = 0;
  #     CPU_BOOST_ON_AC = 1;
  #   };
  # };

  # Keyd and map copilot btn to ctrl
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          "rightalt" = "leftcontrol";
          "f23+leftmeta+leftshift" = "rightalt";
        };
      };
    };
  };

  # Stop bluetooth from starting when the system starts
  hardware.bluetooth.powerOnBoot = false;

  # Auto optimise store
  nix.settings.auto-optimise-store = true;

  # Add openconnect plugin to NetworkManager
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
