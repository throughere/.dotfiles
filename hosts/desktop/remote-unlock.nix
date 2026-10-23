({
  config,
  pkgs,
  ...
}: let
  vpsPubKey = "dX0ROH/3jkR5AtrqSjCLA7GZ4aqJTvvtbxU7Drp0my0=";

  unlockScript = pkgs.writeShellScript "luks-unlock" ''
    echo
    echo "salo-pc -- enter the LUKS passphrase to continue boot:"
    ${config.boot.initrd.systemd.package}/bin/systemd-tty-ask-password-agent --query --watch
  '';
in {
  boot.initrd.availableKernelModules = ["r8169"];
  boot.initrd.kernelModules = ["wireguard"];

  boot.initrd.systemd.network = {
    enable = true;
    networks."10-eno1" = {
      matchConfig.Name = "eno1";
      networkConfig.DHCP = "yes";
    };
    netdevs."20-wgluks" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wgluks";
      };
      wireguardConfig.PrivateKeyFile = "/etc/wgluks-initrd.key";
      wireguardPeers = [
        {
          PublicKey = vpsPubKey;
          Endpoint = "146.59.35.233:51820";
          AllowedIPs = ["10.200.0.0/24"];
          PersistentKeepalive = 25;
        }
      ];
    };
    networks."20-wgluks" = {
      matchConfig.Name = "wgluks";
      address = ["10.200.0.2/24"];
    };
  };

  boot.initrd.secrets."/etc/wgluks-initrd.key" = "/persist/secrets/wgluks-initrd.key";

  boot.initrd.systemd.services.wgluks-key-perms = {
    description = "Make the wgluks key readable by systemd-networkd";
    wantedBy = ["initrd.target"];
    before = ["systemd-networkd.service"];
    after = ["initrd-nixos-copy-secrets.service"];
    requires = ["initrd-nixos-copy-secrets.service"];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/chmod 0644 /etc/wgluks-initrd.key";
    };
  };

  boot.initrd.network.ssh = {
    enable = true;
    port = 2222;
    hostKeys = ["/persist/initrd/ssh_host_ed25519_key"];
    authorizedKeys = config.users.users.salo.openssh.authorizedKeys.keys;
  };

  boot.initrd.systemd.users.root.shell = "${unlockScript}";
  boot.initrd.systemd.storePaths = [unlockScript pkgs.bash];
})
