{ pkgs, ... }:

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
    # Use nixGLIntel if on the S340's i5-8265U
  ];

  # Enable Dank Material Shell (AvengeMedia version)
  programs.dank-material-shell.enable = true;

  programs.home-manager.enable = true;
}
