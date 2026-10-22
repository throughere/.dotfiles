{pkgs, ...}: {
  home.packages = with pkgs; [
    qbittorrent
    telegram-desktop
    whatsapp-electron
    anydesk
    moonlight-qt
  ];
}
