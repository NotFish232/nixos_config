{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      "n-update" = "nix flake update";
      "n-switch" = "sudo nixos-rebuild switch --flake .#$(hostname)";
      "n-list" = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      "n-del" = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system";
      "n-gc" = "sudo nix-collect-garbage -d";
      "n-dev" = "nix develop -c zsh";
      "x" = "xclip -sel clip";
      "um" = "umount /run/media/$USER/*";
      "t" = "acpi -t";
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "tmux"
      ];
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 500 ''
        [ "$TERM_PROGRAM" != tmux ] && { exec tmux new }
      '')

      (lib.mkOrder 1000 ''
        function prompt_dir() {
          # %1~ shows just the current directory, ~ for home
          prompt_segment blue black '%1~'
        }

        function v() {
          is_active="$(nmcli -f GENERAL.STATE con show $1 | grep activated)"

          if [ $is_active ]; then
            nmcli connection down $1
          else
            nmcli connection up $1 --ask
          fi
        }

        function _nmcli_connections() {
          local -a connections
          connections=(''${(f)"$(nmcli -t -f NAME connection show)"})
          compadd "$@" -- "''${connections[@]}"
        }

        compdef _nmcli_connections v


        # Locating lib files within the nix store
        function loc() {
          find /nix/store -name $1 -printf '%h\n' -quit
        }

        # Python on NixOS is horrid
        unset _PYTHON_SYSCONFIGDATA_NAME
        unset _PYTHON_HOST_PLATFORM 
        unset SOURCE_DATE_EPOCH
        unset CXX
        unset CC
      '')
    ];
  };
}
