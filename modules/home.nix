{ pkgs, ... }:

{
  imports = [
    ./mangowm.nix
    ./openrc.nix
  ];

  home.username = "neonscar";
  home.homeDirectory = "/home/neonscar";
  home.stateVersion = "23.11";

  # Nix on Non-NixOS (Devuan) tweaks
  targets.genericLinux.enable = true;
  
  # Ensure no systemd services are attempted
  systemd.user.enable = false;

  home.packages = with pkgs; [
    git
    vim
    kitty
    chromium
    nh
    nix-output-monitor
  ];

  # Note: Dank Material Shell (DMS) might be causing build issues if it tries 
  # to build complex dependencies or create systemd services.
  # We will keep it enabled but be aware it might be the source of 'make-derivation' errors.
  programs.dank-material-shell.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.9";
    };
  };

  programs.home-manager.enable = true;
}
