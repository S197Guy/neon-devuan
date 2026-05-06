{ pkgs, inputs, ... }:

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
  systemd.user.enable = false;

  home.packages = with pkgs; [
    # Core Tools
    git
    vim
    kitty
    chromium
    
    # Nix helpers
    nh
    nix-output-monitor
  ];

  # Dank Material Shell
  programs.dank-material-shell.enable = true;

  # Basic Kitty Config (No Catppuccin)
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.9";
    };
  };

  programs.home-manager.enable = true;
}
