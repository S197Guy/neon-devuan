{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.mangowm.packages.${pkgs.system}.default
  ];

  xdg.configFile."mango/config.conf".text = ''
    # neon-Devuan MangoWM Config
    # Minimal & Pastel
    
    # Appearance (SceneFX)
    corner_radius = 12
    shadows = true
    blur = true
    
    # Colors (Catppuccin Mocha)
    border_color_active = 0xfff5c2e7
    border_color_inactive = 0xff1e1e2e
    
    # Gaps
    inner_gap = 10
    outer_gap = 15
    
    # Keybinds
    # Mod+B for browser
    bind = Mod, B, spawn, chromium
    bind = Mod, Return, spawn, kitty
    bind = Mod, Q, killactive,
    bind = Mod, M, exit,
    
    # Launch Dank Material Shell on startup
    exec-once = dms run
  '';
}
