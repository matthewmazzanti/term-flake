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
        # less.follows = "less";
        # nvim.follows = "nvim";
        # short-pwd.follows = "short-pwd";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    with flake-utils.lib;
    eachSystem defaultSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
        readDefault = name: inputs.${name}.packages.${system}.default;
      in
      {
        packages = {
          less = readDefault "less";
          nvim = readDefault "nvim";
          short-pwd = readDefault "short-pwd";
          zsh = readDefault "zsh";
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
