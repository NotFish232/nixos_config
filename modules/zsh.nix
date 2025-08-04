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
        [ -z "$TMUX"  ] && { exec tmux new -A }
      '')

      (lib.mkOrder 1000 ''
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


        function nix_shell_prompt() {
          if [[ -n "$IN_NIX_SHELL" ]]; then
            echo "(nix-env) "
          fi
        }

        PROMPT='$(nix_shell_prompt)'$PROMPT
      '')
    ];
  };
}
