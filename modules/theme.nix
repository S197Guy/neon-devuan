{ pkgs, lib, ... }:

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
    adw-gtk3
    papirus-icon-theme
  ];

  # GTK Theming (adw-gtk3 is recommended for DMS/Matugen)
  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "adw-gtk3-dark";
      package = lib.mkForce pkgs.adw-gtk3;
    };
    iconTheme = {
      name = lib.mkForce "Papirus-Dark";
      package = lib.mkForce pkgs.papirus-icon-theme;
    };
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  dconf.enable = false;

  home.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
    QT_QPA_PLATFORMTHEME = lib.mkForce "gtk3";
    XCURSOR_THEME = "Papirus-Dark";
  };

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
