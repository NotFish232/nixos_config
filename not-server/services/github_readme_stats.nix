{ config, pkgs, ... }:

{
  systemd.services.github-readme-stats = {
    path = with pkgs; [ git ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Run the github-readme-stats repository";
    serviceConfig = {
      Type = "simple";
      User = "justin";
      WorkingDirectory = "/home/justin/github-readme-stats";
      ExecStart = ''${pkgs.nix}/bin/nix develop --command ${pkgs.nodejs_24}/bin/node express.js'';
    };
  };

  systemd.services.funnel-github-readme-stats = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Tailscale forward the github-readme-stats repository";
    serviceConfig = {
      Type = "simple";
      User = "justin";
      ExecStart = ''${pkgs.tailscale}/bin/tailscale funnel 9000'';
    };
  };
}
