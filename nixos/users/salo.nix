{
  # With mutableUsers = true, hashedPassword below is only applied when the
  # account is first created, so later edits here would never reach
  # /etc/shadow. False makes this file the source of truth on every rebuild,
  # at the cost of `passwd` no longer sticking.
  users.mutableUsers = false;

  # Every user without a hashedPassword here gets locked, root included.
  users.users.root.hashedPassword = "$y$j9T$2YUZ8vGau.Bv9z/1B31nk.$EvxWs77kHy4JP6y/oOEm32kB9dNuqsSxxsX1Sh0uhnC";

  users.users.salo = {
    hashedPassword = "$y$j9T$2YUZ8vGau.Bv9z/1B31nk.$EvxWs77kHy4JP6y/oOEm32kB9dNuqsSxxsX1Sh0uhnC";
    isNormalUser = true;
    # Both hosts' keys, so ssh/scp/sftp works in either direction between them
    # (this file is shared, so each host authorizes the other and itself).
    openssh.authorizedKeys.keys = [
      # salo-laptop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZfIIW2IMUMHb4stmtyxZeBTtk6jjrl62GpP5Gkvjsf"
      # salo-pc
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOx/bOBxbuqXjF9PycNtinO0ex57mQPpY8cq+KQ/8xWn github@salko-ua.de"
    ];
    extraGroups = ["wheel" "docker" "libvirtd" "networkmanager"];
  };
}
