{ pkgs, ... }: {

  # 1. BOOT & BRIGHTNESS (The Fix)
  boot = {
    # We use "video.use_native_backlight=1" or "acpi_backlight=video" for Asus 2023+ models
    kernelParams = [ "acpi_backlight=video" ]; 
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

  # 2. HARDWARE & GRAPHICS (Asus TUF FX507VV Specifics)
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    offload.enable = true;
    offload.enableOffloadCmd = true;
  };

  services.asusd.enable = true;
  services.tlp.enable = true;

  # 3. FILE SYSTEMS (Windows drive + NixOS partitions)
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/FEAEE3DDAEE38D09";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "umask=000" "nofail" ];
  };

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
    device = "/dev/disk/by-uuid/ab5845dc-2fc5-4331-89be-548e73ec676b";
    fsType = "btrfs";
    options = ["subvol=@nix" "compress=zstd:1" "noatime" "discard=async"];
  };

  fileSystems."/mnt/swap" = {
    device = "/dev/disk/by-uuid/ab5845dc-2fc5-4331-89be-548e73ec676b";
    fsType = "btrfs";
    options = ["subvol=@swap" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/80E1-F164";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [{device = "/mnt/swap/swapfile";}];

  # 4. SERVICES
  services.logind.settings.Login.HandleLidSwitch = "ignore";
  services.linux-enable-ir-emitter.enable = true;
  services.howdy = {
    enable = true;
    control = "sufficient";
    settings.video = { certainty = 2; dark_threshold = 80; };
  };

  services.flatpak.enable = true;
  virtualisation.waydroid.enable = true;
  programs.kdeconnect.enable = true;
  programs.firejail.enable = true;

  # 5. UI (KDE Plasma 6)
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  # 6. SYSTEM INFO
  system.stateVersion = "25.11";
  time.timeZone = "Africa/Cairo";
  i18n.defaultLocale = "en_GB.UTF-8";

  environment.shellAliases = {
    os-rebuild = "nh os switch /home/b0dr/nixos -H laptop";
    os-rebuild-boot = "nh os boot /home/b0dr/nixos -H laptop";
  };
}
