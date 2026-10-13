{pkgs, ...}: {
  home.packages = with pkgs; [
    # poetry
    uv
    python3
    nodejs_22

    ruff
    basedpyright

    gnumake
    gcc
    git
    lazygit
    cloc

    mycli
    dbeaver-bin
    neovim
    vimPlugins.nvim-dbee
  ];
}
