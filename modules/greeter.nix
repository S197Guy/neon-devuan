{ pkgs, inputs, ... }:

let
  dms-shell = inputs.dms.packages.${pkgs.system}.dms-shell;
  quickshell = inputs.dms.packages.${pkgs.system}.quickshell;
  mango = inputs.mangowm.packages.${pkgs.system}.default;
  nixGL = inputs.nixgl.packages.${pkgs.system}.nixGLIntel;
  
  gpu-link-service = pkgs.writeText "nix-gpu-link" ''
    #!/sbin/openrc-run
    # OpenRC service to ensure Nix GPU driver link exists on boot
    
    description="Nix GPU driver symlink for non-NixOS"
    
    depend() {
        use mountall.sh
        before greetd
    }
    
    start() {
        ebegin "Linking Nix GPU driver to /run/opengl-driver"
        # If it's a real directory, remove it so we can create the symlink
        if [ -d "/run/opengl-driver" ] && [ ! -L "/run/opengl-driver" ]; then
            rmdir "/run/opengl-driver"
        fi
        ln -sfT /nix/store/wdwzqr4z406anyym15qyqf8imk1nvi04-non-nixos-gpu /run/opengl-driver
        eend $?
    }
  '';

  greeter-script = pkgs.writeShellScriptBin "dms-greeter-wrapped" ''
    # Add necessary tools to PATH
    export PATH="${pkgs.lib.makeBinPath [
      quickshell
      mango
      pkgs.glib      # for gdbus
      pkgs.jq        # for session/settings processing
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.util-linux # for mktemp
      pkgs.bash
      nixGL
    ]}:$PATH"
    
    # Force Wayland/EGL for the greeter
    export XDG_SESSION_TYPE=wayland
    export QT_QPA_PLATFORM=wayland
    export EGL_PLATFORM=gbm
    export DMS_RUN_GREETER=1
    
    # Run with nixGL for Intel GPU acceleration on Devuan
    exec nixGLIntel bash "${dms-shell}/share/quickshell/dms/Modules/Greetd/assets/dms-greeter" \
      --cache-dir "/var/cache/dms-greeter" \
      --command "mango" \
      -p "${dms-shell}/share/quickshell/dms" \
      "$@"
  '';
in
{
  home.packages = [ greeter-script ];
  
  # Devuan (OpenRC) Setup Helper
  home.file.".local/bin/setup-dms-greeter".text = ''
    #!/bin/bash
    set -e
    
    echo "🌸 Setting up DMS Greeter on Devuan..."
    
    # 1. Install greetd if missing
    if ! command -v greetd &> /dev/null; then
        echo "📦 Installing greetd via apt..."
        sudo apt update && sudo apt install -y greetd
    fi
    
    # 2. Ensure greeter user and group exist
    if ! getent group greeter > /dev/null; then
        sudo groupadd -r greeter
    fi
    if ! getent passwd greeter > /dev/null; then
        sudo useradd -r -g greeter -d /var/lib/greetd -s /sbin/nologin -c "greetd greeter user" greeter
    fi

    # 3. Add greeter to necessary groups for Wayland/GPU
    echo "👥 Adding greeter to video and input groups..."
    sudo usermod -aG video,input greeter || true
    
    # 4. Create cache directory
    echo "📁 Creating cache directory /var/cache/dms-greeter..."
    sudo mkdir -p /var/cache/dms-greeter
    sudo chown greeter:greeter /var/cache/dms-greeter
    sudo chmod 0750 /var/cache/dms-greeter
    
    # 5. Ensure Wayland Sessions directory exists
    echo "📂 Setting up wayland-sessions directory..."
    sudo mkdir -p /usr/share/wayland-sessions
    
    # 6. Create start-neon.desktop session
    echo "📄 Creating start-neon.desktop session..."
    sudo tee /usr/share/wayland-sessions/start-neon.desktop << EOF
[Desktop Entry]
Name=neon-Devuan (MangoWM)
Comment=Dank Material Shell on MangoWM
Exec=$HOME/.local/bin/start-neon
Type=Application
DesktopNames=mango;wlroots
EOF

    # 7. Configure greetd
    echo "⚙️ Configuring /etc/greetd/config.toml..."
    GREETER_BIN="${greeter-script}/bin/dms-greeter-wrapped"
    sudo tee /etc/greetd/config.toml << EOF
[terminal]
vt = 7

[default_session]
user = "greeter"
command = "$GREETER_BIN"
EOF

    # 8. Initialize greeter cache with user's current settings
    echo "🎨 Initializing greeter cache from current user settings..."
    # We copy the session/settings if they exist
    mkdir -p ~/.local/state/DankMaterialShell
    [ -f ~/.local/state/DankMaterialShell/session.json ] && sudo cp ~/.local/state/DankMaterialShell/session.json /var/cache/dms-greeter/
    [ -f ~/.config/DankMaterialShell/settings.json ] && sudo cp ~/.config/DankMaterialShell/settings.json /var/cache/dms-greeter/
    # Also need a dummy session.json if none exists to avoid UI errors
    if [ ! -f /var/cache/dms-greeter/session.json ]; then
        echo "{}" | sudo tee /var/cache/dms-greeter/session.json
    fi
    sudo chown -R greeter:greeter /var/cache/dms-greeter
    echo "🔌 Installing nix-gpu-link OpenRC service..."
    sudo cp ${gpu-link-service} /etc/init.d/nix-gpu-link
    sudo chmod +x /etc/init.d/nix-gpu-link
    sudo rc-update add nix-gpu-link boot
    sudo rc-service nix-gpu-link start
    
    # 9. Enable greetd
    echo "🚀 Enabling greetd service..."
    sudo rc-update add greetd default
    
    echo "✅ Setup complete! Restart your machine or run: sudo rc-service greetd restart"
  '';
  
  home.file.".local/bin/setup-dms-greeter".executable = true;
}
