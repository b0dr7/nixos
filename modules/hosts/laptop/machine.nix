{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with self.modules.nixos; [
      # Core
      nix
      core-packages
      laptopHardware
      laptopPackages
      laptopModule
      # User
      user-b0dr
      mime
      # Modules
      theming
      pipewire
      networking
      nvidia
      tlp
      fish
      printing
      direnv

      yazi
      firefox
      gaming
      virt-manager
      emacs
      logisim
    ];
  };

  flake.modules.nixos.laptopModule = {pkgs, ...}: {
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    services.logind.settings.Login.HandleLidSwitch = "ignore";

    # Link NetworkManager to systemd-resolved for system-wide NextDNS
    networking.networkmanager.dns = "systemd-resolved";

    services.resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
      extraConfig = ''
        DNS=45.90.28.0#7c81ed.dns.nextdns.io
        DNS=2a07:a8c0::#7c81ed.dns.nextdns.io
        DNS=45.90.30.0#7c81ed.dns.nextdns.io
        DNS=2a07:a8c1::#7c81ed.dns.nextdns.io
        DNSOverTLS=yes
      '';
    };

    services.linux-enable-ir-emitter.enable = true;
    services.howdy = {
      enable = true;
      control = "sufficient";
      settings = {
        video = {
          certainty = 2;
          dark_threshold = 80;
        };
      };
    };
    programs.firejail.enable = true;

    services.flatpak.enable = true;
    virtualisation.waydroid.enable = true;
    programs.kdeconnect.enable = true;

    environment.shellAliases = {
      os-rebuild = "nh os switch /home/b0dr/nixos -H laptop";
      os-rebuild-boot = "nh os boot /home/b0dr/nixos -H laptop";
      grep = "grep --color=auto";
    };

    # Enable KDE Plasma 6 & SDDM
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.defaultSession = "plasma";
  };

  flake.modules.nixos.laptopHardware = {
    system.stateVersion = "25.11";
    hardware.facter.reportPath = ./facter.json;
    time.timeZone = "Africa/Cairo";
    i18n.defaultLocale = "en_GB.UTF-8";
    users.users.root.initialPassword = "root";

    hardware.nvidia.prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload.enable = true;
      offload.enableOffloadCmd = true;
    };
    services.asusd.enable = true;

    boot = {
      kernelParams = [ "acpi_backlight=native" ]; 
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          useOSProber = true;
          device = "nodev";
          efiSupport = true;
        };
      };
    };

    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.devmon.enable = true;

    # Power Management Configuration
    services.tlp.enable = true;
    services.auto-cpufreq.enable = false; 
    services.power-profiles-daemon.enable = false;

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/ab5845dc-2fc5-4331-89be-548e73ec676b";
      fsType = "btrfs";
      options = ["subvol=@nixos" "compress=zstd:1" "noatime" "discard=async" "autodefrag"];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/ab5845dc-2fc5-4331-89be-548e73ec676b";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd:1" "noatime" "discard=async" "autodefrag"];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/ab5845dc-2fc5-4331-8
