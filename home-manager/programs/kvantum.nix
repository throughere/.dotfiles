{pkgs, ...}: let
  base = pkgs.catppuccin-kvantum.override {
    accent = "blue";
    variant = "mocha";
  };
  translucent = pkgs.runCommand "catppuccin-mocha-blue-translucent" {} ''
    src=${base}/share/Kvantum/catppuccin-mocha-blue
    dst=$out/share/Kvantum/CatppuccinMochaBlueT
    mkdir -p "$dst"
    cp "$src/catppuccin-mocha-blue.svg" "$dst/CatppuccinMochaBlueT.svg"
    sed -e 's/^translucent_windows=.*/translucent_windows=true/' \
        -e 's/^blurring=.*/blurring=true/' \
        "$src/catppuccin-mocha-blue.kvconfig" > "$dst/CatppuccinMochaBlueT.kvconfig"
  '';
in {
  home.packages = [
    pkgs.kdePackages.qtstyleplugin-kvantum # Qt6 Kvantum style plugin + manager
    translucent
  ];

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=CatppuccinMochaBlueT
  '';

  xdg.configFile."plasma-workspace/env/kvantum.sh".text = ''
    export QT_PLUGIN_PATH="${pkgs.kdePackages.qtstyleplugin-kvantum}/lib/qt-6/plugins''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"
    export QT_STYLE_OVERRIDE=kvantum
  '';
}
