{pkgs, ...}: let
  equibop = pkgs.symlinkJoin {
    name = "equibop-${pkgs.equibop.version}";
    paths = [pkgs.equibop];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/equibop \
        --prefix LD_LIBRARY_PATH : ${pkgs.stdenv.cc.cc.lib}/lib
    '';
  };
in {
  home.packages = [equibop];

  services.arrpc.enable = true;

  xdg.configFile."autostart/equibop.desktop" = {
    force = true;
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Equibop
      Comment=Equibop autostart script
      Exec=${equibop}/bin/equibop
      StartupNotify=false
      Terminal=false
      Icon=equibop
      Hidden=true
    '';
  };
}
