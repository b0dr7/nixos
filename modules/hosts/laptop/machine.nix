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
    services.displayManager.ly.enable = true;
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
      kernelParams = [
        #"zswap.enabled=0"
      ];
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

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/ab5845dc-2fc5-4331-89be-548e73ec676b";
      fsType = "btrfs";
      options = [
        "subvol=@nixos"
        "compress=zstd:1"
        "noatime"
        "discard=async"
        "autodefrag"
      ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/ab5845dc-2fc5-4331-89be-548e73ec676b";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd:1"
        "noatime"
        "discard=async"
        "autodefrag"
      ];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/ab5845dc-2fc5-4331-89be-548e73ec676b";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress=zstd:1"
        "noatime"
        "discard=async"
      ];
    };

    fileSystems."/mnt/swap" = {
      device = "/dev/disk/by-uuid/ab5845dc-2fc5-4331-89be-548e73ec676b";
      fsType = "btrfs";
      options = [
        "subvol=@swap"
        "noatime"
      ];
    };

    swapDevices = [
      {device = "/mnt/swap/swapfile";}
    ];

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/80E1-F164";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
};
}

services.displayManager.ssdm.enable = true;
services.desktopManager.plasma6.enable = true;
services.displayManager.defaultSession = "plasma";
