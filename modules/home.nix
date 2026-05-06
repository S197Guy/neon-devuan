{ pkgs, inputs, ... }:

{
  imports = [
    ./theme.nix
    ./mangowm.nix
    ./openrc.nix
  ];

  home.username = "neonscar";
  home.homeDirectory = "/home/neonscar";
  home.stateVersion = "23.11";

  # Nix on Non-NixOS (Devuan) tweaks
  targets.genericLinux.enable = true;
  
  # Disable systemd services as we are on OpenRC
  systemd.user.enable = false;

  home.packages = with pkgs; [
    # Dev Tools
    git
    vim
    wget
    curl
    
    # Media
    mpv
    imv
    
    # Nix helpers
    nh
    nix-output-monitor
    nvd
  ];

  # Dank Material Shell
  programs.dank-material-shell.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
