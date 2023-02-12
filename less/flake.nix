{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    with flake-utils.lib;
    eachSystem defaultSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        less-pkg = pkgs.callPackage ./less.nix { };
      in
      rec {
        packages = rec {
          default = pkgs.lib.makeOverridable less-pkg {
            imports = [ profiles.mmazzanti ];
          };
          profiles = import ./config;
        };
      }
    );
}
