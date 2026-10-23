{
  pkgs,
  lib,
  ...
}: {
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  my.moonlight.fps = 165;

  # Closing the lid should not suspend/shut down the laptop
  programs.plasma.powerdevil = {
    AC = {
      whenLaptopLidClosed = "doNothing";
      autoSuspend = {
        action = lib.mkForce "nothing";
        idleTimeout = lib.mkForce null;
      };
    };
    battery.whenLaptopLidClosed = "doNothing";
  };

  home.packages = with pkgs; [
    lenovo-legion
    nvidia-container-toolkit
  ];

  # Nvidia hardware acceleration (plugins live in home-manager/programs/obs.nix)
  programs.obs-studio.package = pkgs.obs-studio.override {
    cudaSupport = true;
  };
}
