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
    
    # Fonts
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    
    # nixGL for hardware acceleration
  ];

  # Enable Dank Material Shell (AvengeMedia version)
  programs.dank-material-shell.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 11;
      background_opacity = "0.9";
    };
  };

  programs.home-manager.enable = true;
}
