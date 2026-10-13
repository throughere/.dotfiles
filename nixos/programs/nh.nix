{pkgs, ...}: {
  environment.sessionVariables.NH_FLAKE = "/home/salo/.dotfiles";
  environment.systemPackages = [pkgs.nh];

  programs.nh.clean = {
    enable = true;
    dates = "weekly";
    extraArgs = "--keep 5 --keep-since 30d";
  };
}
