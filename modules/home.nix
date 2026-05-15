{ pkgs, inputs, ... }:

{
  imports = [
    ./mangowm.nix
    ./openrc.nix
    ./kitty.nix
    ./theme.nix
    ./greeter.nix
  ];

  home.username = "neonscar";
  home.homeDirectory = "/home/neonscar";
  home.stateVersion = "23.11";

  targets.genericLinux.enable = true;
  systemd.user.enable = false;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Core Tools
    git
    vim
    xfce.thunar
    
    # Mango/DMS Dependencies
    matugen
    swaybg
    brightnessctl
    wl-clipboard
    grim
    slurp
    
    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    
    # Audio Control
    wireplumber
    pulseaudio
    pavucontrol
    
    # Networking & Bluetooth Control
    networkmanager
    networkmanagerapplet
    blueman
    
    # nixGL for hardware acceleration
  ];

  # Enable Dank Material Shell (AvengeMedia version)
  programs.dank-material-shell.enable = true;

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--gtk-version=4"
      "--enable-features=WebRTCPipeWireCapturer"
      "--force-dark-mode"
    ];
  };

  programs.home-manager.enable = true;
}
