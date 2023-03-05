{ pkgs, lib, ... }: with lib; let
  # Add modules for simple vim plugins just based off of a plugin package
  mkBasicModule = name: plugins: { pkgs, lib, config, ... }: let
    cfg = config.plugins.${name};
  in with lib; {
    options.plugins.${name} = {
      enable = mkEnableOption "Enable ${name}";
      config = mkOption {
        type = types.str;
        default = "";
      };
    };

    config.vim = mkIf cfg.enable {
      plugins.start = if isList plugins then plugins else [plugins];

      setup = if cfg.config == "" then {} else {
        ${name} = pkgs.writeTextFile {
          name = "${name}-setup.lua";
          text = cfg.config;
        };
      };
    };
  };

  mkImports = set: attrValues (mapAttrs mkBasicModule set);
in {
  imports = with pkgs.vimPlugins; mkImports {
    "python-indent" = vim-python-pep8-indent;
    "fugitive" = vim-fugitive;
    "signature" = vim-signature;
    "nix" = vim-nix;
    "wordmotion" = vim-wordmotion;
    "easyclip" = vim-easyclip;
    "gruvbox" = gruvbox-nvim;
    "lspconfig" = nvim-lspconfig;
    "lualine" = lualine-nvim;
    "searchbox" = vim-searchbox;
    "sandwich" = vim-sandwich;
    "fine-cmdline" = vim-fine-cmdline;
    "cmp" = [
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        luasnip
        cmp_luasnip
    ];
    "treesitter" = [
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-ts-autotag
      # Disabled for now
      # spellsitter-nvim
    ];
    "telescope" = [
      telescope-nvim
      telescope-fzf-native-nvim
    ];
  };

  options = {
    viAlias = mkOption {
      type = types.bool;
      default = false;
    };

    vimAlias = mkOption {
      type = types.bool;
      default = false;
    };

    # Options to configure vim itself
    vim = {
      ftplugin = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
        contents of ftplugins to load
        '';
      };

      setup = mkOption {
        type = types.attrsOf types.package;
        default = {};
        description = ''
        Lua config packages to link into $XDG_CONFIG_HOME/nvim/lua
        '';
      };

      init = mkOption {
        type = types.str;
        default = "";
      };

      plugins = {
        start = mkOption {
          type = types.listOf types.package;
          default = [];
          description = ''
          Plugins to load on start
          '';
        };

        opt = mkOption {
          type = types.listOf types.package;
          default = [];
          description = ''
          Plugins to optionally load
          '';
        };
      };
    };
  };
}
