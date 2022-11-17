{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    neovim-flake = {
      url = "git+file:///Users/mmazzanti/src/nix/term-flake?dir=nvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    less-flake = {
      url = "git+file:///Users/mmazzanti/src/nix/term-flake?dir=less";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    in flake-utils.lib.eachSystem systems (system: let
        overlay = _: super: {
          nvim-cfg = inputs.neovim-flake.packages.${system}.default;
          less-cfg = inputs.less-flake.packages.${system}.default;
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };

        zsh-pkg = pkgs.callPackage ./zsh.nix {};
      in rec {
        packages = rec {
          default = pkgs.lib.makeOverridable zsh-pkg {
            imports = [ (import ./config).mmazzanti ];
          };
          profiles = import ./config;
        };
      }
    );
}
