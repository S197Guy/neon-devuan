{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.mangowm.packages.${pkgs.system}.default
    inputs.nixgl.packages.${pkgs.system}.nixGLIntel
    pkgs.wlr-randr
  ];

  xdg.configFile."mango/config.conf".text = ''
    # neon-Devuan MangoWM PoC Config
    
    # SceneFX Visuals
    border_radius = 12
    shadows = 1
    blur = 1
    
    # Misc
    cursor_size = 32
    
    # Keybinds
    bind = SUPER, B, spawn, chromium
    bind = SUPER, Return, spawn, kitty
    bind = SUPER, Q, killclient,
    bind = SUPER, M, quit,
    
    # Launch Dank Material Shell (DMS) on startup
    exec-once = dms run
    
    # Set resolution at startup
    exec-once = wlr-randr --output Virtual-1 --mode 1920x1080@60Hz
  '';
  
  # Helper script to launch MangoWM with nixGL
  home.file.".local/bin/start-neon".text = ''
    #!/bin/bash
    # Fix for inverted cursor on virgl/virtualized environments
    export WLR_NO_HARDWARE_CURSORS=1
    
    # Launch MangoWM with hardware acceleration on Devuan
    # nixGLIntel is used but if virgl is detected it should bridge to host
    nixGLIntel mango
  '';
  
  home.file.".local/bin/start-neon".executable = true;
}
