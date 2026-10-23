{
  config,
  pkgs,
  ...
}: {
  # Enable NVIDIA
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware = {
    nvidia-container-toolkit.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [intel-media-driver];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };


  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  services.sunshine.settings = {
    encoder = "vaapi";
    adapter_name = "/dev/dri/renderD128";
    # Allow opening the web UI over the mesh / LAN (CSRF guard).
    csrf_allowed_origins = "https://100.64.0.2:47990,https://192.168.0.247:47990";
  };
  systemd.user.services.sunshine.environment = {
    LIBVA_DRIVER_NAME = "iHD";
    LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
  };
}
