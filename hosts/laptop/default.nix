{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  networking.hostName = "salo-laptop";
  networking.interfaces.enp92s0.wakeOnLan.enable = true;

  # Keep the laptop running with the lid shut so remote Sunshine/SSH sessions survive a closed lid
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
