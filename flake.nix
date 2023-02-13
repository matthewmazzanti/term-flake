{
  description = "nix polyglot demo";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    less = {
      url = "path:./less";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nvim = {
      url = "path:./nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    short-pwd = {
      url = "path:./short-pwd";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    zsh = {
      url = "path:./zsh";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        less.follows = "less";
        nvim.follows = "nvim";
        short-pwd.follows = "short-pwd";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    with flake-utils.lib;
    eachSystem defaultSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          less = inputs.less.packages.${system}.default;
          nvim = inputs.nvim.packages.${system}.default;
          short-pwd = inputs.short-pwd.packages.${system}.default;
          zsh = inputs.zsh.packages.${system}.default;
        };

        devShells.default = with pkgs; mkShell {
          buildInputs = [
            nixpkgs-fmt
            nix-tree
            go # for short-pwd
          ];
        };
      }
    );
}
