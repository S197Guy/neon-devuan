{ pkgs, inputs, ... }:

{
  imports = [
    ./mangowm.nix
    ./openrc.nix
  ];

  home.username = "neonscar";
  home.homeDirectory = "/home/neonscar";
  home.stateVersion = "23.11";

  targets.genericLinux.enable = true;
  systemd.user.enable = false;

  home.packages = with pkgs; [
    # Core Tools
    git
    vim
    kitty
    chromium
    
    # Mango/DMS Dependencies
    matugen
    swaybg
    brightnessctl
    wl-clipboard
    grim
    slurp
    
    # nixGL for hardware acceleration
    inputs.nixgl.packages.${pkgs.system}.nixGLIntel
    
    # The Shell
    inputs.dms-shell.packages.${pkgs.system}.default
  ];

  programs.home-manager.enable = true;
}
