{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.mangowm.packages.${pkgs.system}.default
    inputs.nixgl.packages.${pkgs.system}.nixGLIntel
  ];

  xdg.configFile."mango/config.conf".text = ''
    # neon-Devuan MangoWM PoC Config
    
    # SceneFX Visuals
    border_radius = 12
    shadows = 1
    blur = 1
    
    # Keybinds
    bind = SUPER, B, spawn, chromium
    bind = SUPER, Return, spawn, kitty
    bind = SUPER, Q, killclient,
    bind = SUPER, M, quit,
    
    # Launch Dank Material Shell (DMS) on startup
    exec-once = dms run
  '';
  
  # Helper script to launch MangoWM with nixGL
  home.file.".local/bin/start-neon".text = ''
    #!/bin/bash
    # Launch MangoWM with hardware acceleration on Devuan
    nixGLIntel mango
  '';
  
  home.file.".local/bin/start-neon".executable = true;
}
