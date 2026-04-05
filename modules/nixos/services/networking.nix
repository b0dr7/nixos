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
        fallbackDns = [
          "45.90.28.0#7c81ed.dns.nextdns.io"
          "45.90.30.0#7c81ed.dns.nextdns.io"
       ];
    };
  };
}
