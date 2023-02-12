{
  description = "nix polyglot demo";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      supportedSystems = [ "aarch64-darwin" "x86_64-linux" ];
      eachSystem = flake-utils.lib.eachSystem supportedSystems;
    in eachSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
          {
            packages.short-pwd = pkgs.callPackage ./short-pwd {};
            devShells.default = with pkgs; mkShell {
              buildInputs = [
                go
                nixpkgs-fmt
              ];
            };
          }
      );
}
