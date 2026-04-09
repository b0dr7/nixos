flake.modules.nixos.networking = {
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved"; # Add this line
  networking.firewall.enable = true;
};
