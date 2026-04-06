{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    programs.appimage.enable = true;
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
       extraPkgs = pkgs: with pkgs; [ bibata-cursors ];
      };
    };
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;
     environment.systemPackages = with pkgs; [
      prismlauncher
      love
      mangohud
      lutris
      umu-launcher
      (winePackages.waylandFull.override {wineBuild = "wine64";})
      winetricks
    ];
  };
}
