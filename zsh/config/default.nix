{
  mmazzanti = { pkgs, lib, ... }: {
    config.path = with pkgs; [
      nvim-cfg
      less-cfg

      coreutils
      less
      vim
      curl
      wget
      git

      ripgrep
      fd
      bat
      tree
      direnv
      fzf
      jq
      # Fix python3.10 openssl
      # httpie

      gnupg
      pass
    ];
  };
}
