{...}: {
  flake.modules.nixos.nvidia = {
    config,
    lib,
    ...
  }:
    with lib; {
      services.xserver.videoDrivers = ["nvidia"];
      hardware = {
        graphics = {
         enable = true;
         enable32Bit = true;
        };
        nvidia = {
         modesetting.enable = true;
         open = mkDefault true;
         powerManagement.enable = true;
         powerManagement.finegrained = mkDefault true;
         package = mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
        };
      };
    };
}
