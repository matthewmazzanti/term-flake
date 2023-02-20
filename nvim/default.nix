{ pkgs, lib, ... }:
let
  config = import ./config;

  cfg = let
    module = lib.evalModules {
      modules = [
        ./options.nix
        config.mmazzanti
      ];

      specialArgs = {
        inherit pkgs;
        inherit lib;
      };
    };
  in module.config;
in cfg.out
