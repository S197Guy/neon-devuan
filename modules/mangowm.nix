{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.mangowm.packages.${pkgs.system}.default
  ];

  xdg.configFile."mango/config.conf".text = ''
    # neon-Devuan MangoWM PoC Config (DMS Optimized)
    
    # SceneFX Visuals
    corner_radius = 12
    shadows = true
    blur = true
    
    # Keybinds
    bind = Mod, B, spawn, chromium
    bind = Mod, Return, spawn, kitty
    bind = Mod, Q, killactive,
    bind = Mod, M, exit,
    
    # Launch Dank Material Shell (DMS) on startup
    # Note: Using 'dms-shell' from DreamMaoMao
    exec-once = dms-shell
  '';
  
  # Helper script to launch MangoWM with nixGL
  home.file.".local/bin/start-neon".text = ''
    #!/bin/bash
    # Launch MangoWM with hardware acceleration on Devuan
    nixGLIntel mangowm
  '';
  
  home.file.".local/bin/start-neon".executable = true;
}
