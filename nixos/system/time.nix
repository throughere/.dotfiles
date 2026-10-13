{
  time.timeZone = "Europe/Kyiv";

  services.chrony = {
    enable = true;
    extraConfig = ''
      maxchange 300 1 -1
      minsources 2
    '';
  };
}
