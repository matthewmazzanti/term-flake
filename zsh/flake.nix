{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    # neovim-flake.url = "/Users/mmazzanti/src/nix/neovim-flake";
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    in flake-utils.lib.eachSystem systems (system: let 
        pkgs = import nixpkgs {
          inherit system;
        };

        zsh-pkg = pkgs.callPackage ./zsh.nix {};
      in rec {
        packages = rec {
          default = pkgs.lib.makeOverridable zsh-pkg {
            imports = [ profiles.mmazzanti ];
          };
          profiles = import ./config;
        };
      }
    );
}
