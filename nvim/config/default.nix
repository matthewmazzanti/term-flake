# These are organized into "profiles" or modules that can be selected with the "profile" field on
# the final derivation. This can be extended via the "configure" field, where these settings can be
# defined explicitly
with builtins; rec {
  minimal.config = {
    vim = {
      ftplugin = import ./ftplugin;
      init = readFile ./init.lua;
    };

    plugins = {
      # Indentation plugins - hopefully phased out with treesitter
      nix.enable = true;
      python-indent.enable = true;

      gruvbox = {
        enable = true;
        config = readFile ./gruvbox.lua;
      };
    };
  };

  mmazzanti = { pkgs, lib, ... }: {
    imports = [ minimal ];
    config = {
      plugins = {
        # Language intellegence
        lspconfig = {
          enable = true;
          config = import ./lspconfig pkgs;
        };
        treesitter = {
          enable = true;
          config = readFile ./treesitter.lua;

          /*
          plugins = {
            textobjects.enable = true;
            autotag.enable = true;
            spellsitter.enable = false;
          };
          */
        };
        cmp = {
          enable = true;
          config = readFile ./cmp.lua;
        };

        # Motion improvements
        wordmotion.enable = true;
        sandwich = {
          enable = true;
          config = ''
            vim.keymap.set({"n", "x"}, "s", "<Nop>")
          '';
        };
        easyclip = {
          enable = true;
          config = ''
            vim.g.EasyClipUseCutDefaults = 0
            vim.keymap.set("n", "x", "<Plug>MoveMotionPlug")
            vim.keymap.set("x", "x", "<Plug>MoveMotionXPlug")
            vim.keymap.set("n", "xx", "<Plug>MoveMotionLinePlug")
            vim.keymap.set("n", "X", "<Plug>MoveMotionEndOfLinePlug")
          '';
        };

        # Visual enhancements
        signature.enable = true;
        lualine = {
          enable = true;
          config = readFile ./lualine.lua;
        };

        # Misc improvements
        fugitive.enable = true;
        telescope = {
          enable = true;
          config = ''
            local fdPath = "${pkgs.fd}/bin/fd"
            ${readFile ./telescope.lua}
          '';
        };

        # WIP
        # TODO: Improve these plugins - would love to move commandline to something more eye-candy
        fine-cmdline.enable = false;
        searchbox.enable = false;
      };
    };
  };
}
