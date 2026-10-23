{pkgs, ...}: {
  environment.systemPackages = with pkgs; [ethtool wakeonlan];
}
