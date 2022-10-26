let
  two-space = builtins.readFile ./two_space.lua;
  tab = builtins.readFile ./tab.lua;
in {
    # Tab based languages
    go = tab;
    c = tab;

    # Four space languages
    python = ''
      vim.opt_local.colorcolumn = "80"
      vim.opt_local.textwidth = 79
    '';
    # Use vim :help for Lua files
    lua = ''
      vim.opt_local.keywordprg = ""
    '';

    # Two-space languages
    javascript = two-space;
    typescript = two-space;
    html = two-space;
    css = two-space;
    json = two-space;
    yaml = two-space;
    nix = two-space;
    cpp = two-space;
    h = two-space;
    markdown = ''
      ${two-space}
      vim.opt_local.spell = true
    '';
}
