{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      meslo-lgs-nf
      fantasque-sans-mono
      carlito
      dejavu_fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-code-pro
      ttf_bitstream_vera
    ];

    fontconfig.defaultFonts = {
      monospace = [
        "DejaVu Sans Mono"
        "Noto Sans Mono CJK JP"
      ];
      sansSerif = [
        "DejaVu Sans"
        "Noto Sans CJK JP"
      ];
      serif = [
        "DejaVu Serif"
        "Noto Serif CJK JP"
      ];
    };
  };
}
