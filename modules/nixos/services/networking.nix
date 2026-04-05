{...}: {
  flake.modules.nixos.networking = {
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
     };
      services.resolved = {
        enable = true;
        dnssec = "allow-downgrade";
        dnsovertls = "yes";
        domains = ["~."];
        extraConfig = ''
          DNS=45.90.28.0#7c81ed.dns.nextdns.io
          DNS=2a07:a8c0::#7c81ed.dns.nextdns.io
          DNS=45.90.30.0#7c81ed.dns.nextdns.io
          DNS=2a07:a8c1::#7c81ed.dns.nextdns.io
       '';
    };
  };
}
