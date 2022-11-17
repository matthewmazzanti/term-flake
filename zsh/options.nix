{ pkgs, lib, ... }: with lib; {
  options = {
    compinit = mkOption {
      type = types.bool;
      default = false;
      description = ''
        run compinit
      '';
    };

    bashcompinit = mkOption {
      type = types.bool;
      default = false;
      description = ''
        run bashcompinit
      '';
    };

    brackedPaste = {
      type = types.bool;
      default = false;
      description = ''
        instruct terminal enable bracked paste via escape code
      '';
    };

    aliases = mkOption {
      type = types.attrsOf types.string;
      default = {};
      description = ''
        aliases to add
      '';
    };

    locals = mkOption {
      type = types.attrsOf types.string;
      default = {};
      description = ''
        local variables to set
      '';
    };

    path = mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        derivations to add to path
      '';
    };
  };
}
