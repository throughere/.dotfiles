{pkgs, ...}: let
  bitwarden = pkgs.unstable.bitwarden-desktop;
in {
  home.packages = [bitwarden];

  systemd.user.services.bitwarden = {
    Unit = {
      Description = "Bitwarden";
      After = ["graphical-session.target" "xdg-desktop-portal.service"];
      Wants = ["xdg-desktop-portal.service"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${bitwarden}/bin/bitwarden";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  xdg.configFile."autostart/bitwarden.desktop" = {
    force = true;
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Bitwarden
      Comment=Superseded by the bitwarden.service user unit
      Exec=${bitwarden}/bin/bitwarden
      Hidden=true
    '';
  };
}
