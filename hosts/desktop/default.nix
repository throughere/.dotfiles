{
  imports = [
    ./hardware-configuration.nix
    ../../manual-modules/impermanence
    ./remote-unlock.nix
  ];

  networking.hostName = "salo-pc";
  networking.interfaces.eno1.wakeOnLan.enable = true;

  services.sunshine.settings.csrf_allowed_origins = "https://100.64.0.1:47990,https://192.168.0.195:47990";

  # Fresh install on 26.05 — never change after install.
  system.stateVersion = "26.05";

  # RX 9070 XT — in-kernel amdgpu, no driver packages needed.
  hardware.graphics.enable = true;
  hardware.amdgpu.initrd.enable = true; # early KMS

  systemd.services.amdgpu-pin-mclk = {
    description = "Pin amdgpu VRAM clock to avoid MCLK-switch display artifacts";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for d in /sys/class/drm/card*/device; do
        [ -e "$d/pp_dpm_mclk" ] || continue
        top=$(grep -o '^[0-9]\+' "$d/pp_dpm_mclk" | tail -n1)
        echo manual > "$d/power_dpm_force_performance_level"
        echo "$top" > "$d/pp_dpm_mclk"
      done
    '';
    preStop = ''
      for d in /sys/class/drm/card*/device; do
        [ -e "$d/power_dpm_force_performance_level" ] || continue
        echo auto > "$d/power_dpm_force_performance_level"
      done
    '';
  };

  # Resume resets the level to auto, and an active oneshot will not re-run itself.
  powerManagement.resumeCommands = "systemctl restart amdgpu-pin-mclk.service";
}
