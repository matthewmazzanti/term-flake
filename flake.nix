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

    # NEOVIM PLUGINS
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
    # END NEOVIM PLUGINS

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
        short-pwd.follows = "short-pwd";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    with flake-utils.lib;
    eachSystem defaultSystems (system:
      let
        # Add flake inputs as vim plugins
        # TODO: Upstream easyclip - or un-upstream everything?
        vimPluginOverlay = _: super:
          let
            buildPlugin = super.vimUtils.buildVimPluginFrom2Nix;
            versionOf = src: builtins.toString src.lastModified;
          in
          {
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

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ vimPluginOverlay ];
        };
      in
      {
        packages = {
          less = inputs.less.packages.${system}.default;
          short-pwd = inputs.short-pwd.packages.${system}.default;
          zsh = inputs.zsh.packages.${system}.default;

          nvim = pkgs.callPackage ./nvim {};
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
