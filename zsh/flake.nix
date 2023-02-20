{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    /*
    nvim = {
      url = "github:matthewmazzanti/term-flake?dir=nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    */
    less = {
      url = "github:matthewmazzanti/term-flake?dir=less";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    short-pwd = {
      url = "github:matthewmazzanti/term-flake?dir=nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    with flake-utils.lib;
    eachSystem defaultSystems (system:
      let
        overlay = _: super: {
          nvim-cfg = inputs.nvim.packages.${system}.default;
          less-cfg = inputs.less.packages.${system}.default;
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };

        zsh-pkg = pkgs.callPackage ./zsh.nix { };
      in
      rec {
        packages = rec {
          default = pkgs.lib.makeOverridable zsh-pkg {
            imports = [ (import ./config).mmazzanti ];
          };
          profiles = import ./config;
        };
      }
    );
}
