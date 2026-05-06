{ pkgs, inputs, ... }:

{
  imports = [
    ./theme.nix
    ./mangowm.nix
  ];

  home.username = "neonscar";
  home.homeDirectory = "/home/neonscar";
  home.stateVersion = "23.11";

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
