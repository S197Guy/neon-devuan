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
    noto-fonts-emoji
  ];

  # GTK/QT Theming (if possible via HM on Devuan)
  gtk = {
    enable = true;
    catppuccin.enable = true;
    catppuccin.cursor.enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
