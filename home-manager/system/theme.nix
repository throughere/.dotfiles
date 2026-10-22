{pkgs, ...}: {
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["blue"];
    })
  ];
}
