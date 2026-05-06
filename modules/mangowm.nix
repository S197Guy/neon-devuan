{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.mangowm.packages.${pkgs.system}.default
  ];

  xdg.configFile."mango/config.conf".text = ''
    # neon-Devuan MangoWM PoC Config
    
    # Simple Visuals
    corner_radius = 10
    shadows = true
    
    # Keybinds
    bind = Mod, B, spawn, chromium
    bind = Mod, Return, spawn, kitty
    bind = Mod, Q, killactive,
    bind = Mod, M, exit,
    
    # Launch Shell
    exec-once = dms run
  '';
}
