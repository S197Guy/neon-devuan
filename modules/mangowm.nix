{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.nixgl.packages.${pkgs.stdenv.hostPlatform.system}.nixGLIntel
    pkgs.wlr-randr
    pkgs.lxqt.lxqt-policykit
    pkgs.xwayland-satellite
    pkgs.xwayland
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
    bind = SUPER, E, spawn, thunar
    bind = SUPER, Return, spawn, kitty
    bind = SUPER, Q, killclient,
    bind = SUPER, M, reload_config
    bind = SUPER+SHIFT, M, quit
    bind = SUPER, Space, spawn, $HOME/.nix-profile/bin/nixGLIntel dms ipc call spotlight toggle
    bind = SUPER, P, spawn, $HOME/.nix-profile/bin/nixGLIntel dms screenshot
    bind = SUPER+SHIFT, P, spawn, $HOME/.nix-profile/bin/nixGLIntel dms screenshot full

    # Authentication Agent
    exec-once = lxqt-policykit-agent
    
    # Audio Stack (Pipewire)
    exec-once = pipewire
    exec-once = pipewire-pulse
    exec-once = wireplumber
    
    # Keyring and Secrets
    exec-once = gnome-keyring-daemon --start --components=secrets,pkcs11,ssh
    
    # Force dark mode preference via gsettings
    exec-once = gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    exec-once = gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    
    # XWayland Support (for X11 app compatibility)
    exec-once = xwayland-satellite
    
    # Network and Bluetooth Applets
    exec-once = nm-applet
    exec-once = blueman-applet
    
    # Launch Dank Material Shell (DMS) on startup (wrapped for GL acceleration)
    exec-once = nixGLIntel dms run
    
    # Set resolution at startup (e.g., eDP-1 for physical laptop displays)
    # exec-once = wlr-randr --output eDP-1 --mode 1920x1080@60Hz

    # Source DMS-generated configurations optionally
    source-optional=~/.config/mango/dms/colors.conf
    source-optional=~/.config/mango/dms/binds.conf
    source-optional=~/.config/mango/dms/cursor.conf
    source-optional=~/.config/mango/dms/layout.conf
    source-optional=~/.config/mango/dms/outputs.conf
  '';
  
  # Helper script to launch MangoWM with nixGL
  home.file.".local/bin/start-neon".text = ''
    #!/bin/bash
    # Fix for inverted cursor on virgl/virtualized environments
    export WLR_NO_HARDWARE_CURSORS=1
    
    # Source Home Manager session variables (crucial for theming)
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    fi

    # Launch MangoWM with hardware acceleration and D-Bus session
    # We use dbus-run-session to ensure apps can find the bus for themes/keyring
    COMMAND="$HOME/.nix-profile/bin/nixGLIntel $HOME/.nix-profile/bin/mango"
    
    if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
        dbus-run-session -- $COMMAND
    else
        $COMMAND
    fi
  '';
  
  home.file.".local/bin/start-neon".executable = true;
}
