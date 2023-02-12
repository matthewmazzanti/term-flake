{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    with flake-utils.lib;
    eachSystem defaultSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pkg = pkgs.callPackage ./. { };
      in
      rec {
        packages.default = pkgs.lib.makeOverridable pkg {
          imports = [ lib.profiles.mmazzanti ];
        };

        lib.profiles = import ./config;
      }
    );
}
