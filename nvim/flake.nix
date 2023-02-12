{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    vim-easyclip-src = {
      url = "github:svermeulen/vim-easyclip/master";
      flake = false;
    };

    vim-fine-cmdline-src = {
      url = "github:vonheikemen/fine-cmdline.nvim/main";
      flake = false;
    };

    vim-searchbox-src = {
      url = "github:VonHeikemen/searchbox.nvim/main";
      flake = false;
    };
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs: let
    # Add flake inputs as vim plugins
    # TODO: Upstream easyclip - or un-upstream everything?
    pluginOverlay = _: super: let
      buildPlugin = super.vimUtils.buildVimPluginFrom2Nix;
      versionOf = src: builtins.toString src.lastModified;
    in {
      vimPlugins = super.vimPlugins // {
        vim-easyclip = buildPlugin {
          pname = "vim-easyclip";
          version = versionOf inputs.vim-easyclip-src;
          src = inputs.vim-easyclip-src;
          dependencies = with super.vimPlugins; [ vim-repeat ];
        };

        vim-fine-cmdline = buildPlugin {
          pname = "vim-fine-cmdline";
          version = versionOf inputs.vim-fine-cmdline-src;
          src = inputs.vim-fine-cmdline-src;
          dependencies = with super.vimPlugins; [ nui-nvim ];
        };

        vim-searchbox = buildPlugin {
          pname = "vim-searchbox";
          version = versionOf inputs.vim-searchbox-src;
          src = inputs.vim-searchbox-src;
          dependencies = with super.vimPlugins; [ nui-nvim ];
        };
      };
    };

    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

  in flake-utils.lib.eachSystem systems (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          pluginOverlay
        ];
      };

      nvim-pkg = pkgs.callPackage ./neovim.nix {};
    in rec {
      packages = rec {
        default = pkgs.lib.makeOverridable nvim-pkg {
          imports = [ profiles.mmazzanti ];
        };
        profiles = import ./config;
      };
    }
  );
}
