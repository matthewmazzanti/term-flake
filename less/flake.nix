{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    in flake-utils.lib.eachSystem systems (system: let 
        pkgs = import nixpkgs {
          inherit system;
        };

        less-pkg = pkgs.callPackage ./less.nix {};
      in rec {
        packages = rec {
          default = pkgs.lib.makeOverridable less-pkg {
            imports = [ profiles.mmazzanti ];
          };
          profiles = import ./config;
        };
      }
    );
}
