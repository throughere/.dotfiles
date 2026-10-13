{pkgs, ...}: {
  home.packages = with pkgs; [
    qbittorrent
    telegram-desktop
    whatsapp-electron
    anydesk
    # bitwarden-desktop lives in ../programs/bitwarden.nix, with its autostart entry
  ];
}
