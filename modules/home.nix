{ pkgs, ... }:

{
  imports = [
    ./mangowm.nix
    ./openrc.nix
    ./kitty.nix
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
    # kitty is now managed via programs.kitty in kitty.nix
    chromium
    
    # Mango/DMS Dependencies
    matugen
    swaybg
    brightnessctl
    wl-clipboard
    grim
    slurp
    
    # nixGL for hardware acceleration
  ];

  # Enable Dank Material Shell (AvengeMedia version)
  programs.dank-material-shell.enable = true;

  programs.home-manager.enable = true;
}
