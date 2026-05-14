{ pkgs, ... }:

{
  # Global Catppuccin enablement
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.accent = "pink";

  # Custom fonts for that "Beautiful & Minimal" look
  home.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.noto
    noto-fonts
    noto-fonts-color-emoji
  ];

  # GTK Theming (catppuccin.gtk is deprecated)
  gtk.enable = true;

  dconf.enable = false;

  # Cursors
  catppuccin.cursors.enable = true;
  catppuccin.cursors.flavor = "mocha";
  catppuccin.cursors.accent = "pink";

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
