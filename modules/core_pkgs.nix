{
  config,
  pkgs,
  lib,
  ...
}:

{
  config.home.packages = lib.mkBefore (
    with pkgs;
    [
      vim

      git
      gh

      xclip
      file
      gnupg

      neofetch
      cloc
      htop
      acpi
      lm_sensors

      zip
      lrzip
    ]
  );

}
