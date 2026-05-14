{ pkgs, ... }:

{
  # We manually manage the config file to avoid the Home Manager header/comments
  home.packages = [ pkgs.kitty ];

  xdg.configFile."kitty/kitty.conf".text = ''
    font_family      JetBrainsMono Nerd Font
    font_size        11.0
    shell_integration no-rc
    background_opacity 0.66
    include dank-tabs.conf
    include dank-theme.conf
  '';
}
