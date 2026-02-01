# See https://github.com/NixOS/nixpkgs/pull/462747

final: prev:
let
  # Transformations for each version
  patchClangTools =
    llvmPkgSet:
    llvmPkgSet.overrideScope (
      lfinal: lprev: {
        clang-tools = lprev.clang-tools.overrideAttrs (oldAttrs: {
          postInstall = (oldAttrs.postInstall or "") + ''
            patch -i ${
              prev.fetchpatch {
                url = "https://github.com/NixOS/nixpkgs/pull/462747.diff";
                hash = "sha256-WDP/WJAflkYw8YQDgXK3q9G7/Z6BXTu7QpNGAKjO3co=";
              }
            } $out/bin/clangd
          '';
        });
      }
    );

  # ... all the llvm version we'd like to apply this to
  llvm_versions = [ "21" ];

in
prev.lib.genAttrs (map (v: "llvmPackages_${v}") llvm_versions) (name: patchClangTools prev.${name})
