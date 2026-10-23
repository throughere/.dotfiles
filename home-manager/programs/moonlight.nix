{
  config,
  lib,
  pkgs,
  ...
}: let
  sed = "${pkgs.gnused}/bin/sed";
  grep = "${pkgs.gnugrep}/bin/grep";
  settings = {
    width = "1920";
    height = "1080";
    fps = toString config.my.moonlight.fps;
    windowmode = "0"; # fullscreen
    vsync = "true";
    framepacing = "true";
    videocfg = "2"; # HEVC
    capturesyskeys = "1"; # only in fullscreen
  };
  setLines = lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: ''
    if ${grep} -q '^${k}=' "$conf"; then
      ${sed} -i 's|^${k}=.*|${k}=${v}|' "$conf"
    else
      ${sed} -i '/^\[General\]/a ${k}=${v}' "$conf"
    fi
  '')
  settings);
in {
  options.my.moonlight.fps = lib.mkOption {
    type = lib.types.int;
    default = 60;
    description = "Moonlight streaming framerate for this host.";
  };

  config.home.activation.moonlightSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    dir="$HOME/.config/Moonlight Game Streaming Project"
    conf="$dir/Moonlight.conf"
    run mkdir -p "$dir"
    [ -f "$conf" ] || printf '[General]\n' > "$conf"
    ${grep} -q '^\[General\]' "$conf" || ${sed} -i '1i [General]' "$conf"
    ${setLines}
  '';
}
