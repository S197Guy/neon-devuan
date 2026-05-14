{ pkgs, inputs, ... }:

let
  dms-shell = inputs.dms.packages.${pkgs.system}.dms-shell;
  quickshell = inputs.dms.packages.${pkgs.system}.quickshell;
  mango = inputs.mangowm.packages.${pkgs.system}.default;
  
  nixGL = inputs.nixgl.packages.${pkgs.system}.nixGLIntel;
  
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
    # setup-dms-greeter for Devuan (OpenRC)
    
    set -e
    
    echo "🌸 Setting up DMS Greeter on Devuan..."
    
    # 1. Install greetd if missing
    if ! command -v greetd &> /dev/null; then
        echo "📦 Installing greetd via apt..."
        sudo apt update && sudo apt install -y greetd
    fi
    
    # 2. Ensure greeter user and group exist (usually handled by apt, but let's be sure)
    if ! getent group greeter > /dev/null; then
        echo "👥 Creating greeter group..."
        sudo groupadd -r greeter
    fi
    if ! getent passwd greeter > /dev/null; then
        echo "👤 Creating greeter user..."
        sudo useradd -r -g greeter -d /var/lib/greetd -s /sbin/nologin -c "greetd greeter user" greeter
    fi

    # 3. Create cache directory
    echo "📁 Creating cache directory /var/cache/dms-greeter..."
    sudo mkdir -p /var/cache/dms-greeter
    sudo chown greeter:greeter /var/cache/dms-greeter
    sudo chmod 0750 /var/cache/dms-greeter
    
    # 3. Configure greetd
    echo "⚙️ Configuring /etc/greetd/config.toml..."
    GREETER_BIN="${greeter-script}/bin/dms-greeter-wrapped"
    
    sudo tee /etc/greetd/config.toml << EOF
[default_session]
user = "greeter"
command = "$GREETER_BIN"
EOF

    # 4. Enable and start service
    echo "🚀 Enabling greetd service..."
    sudo rc-update add greetd default
    
    # Note: We don't restart here to avoid kicking the user out of their current session
    echo "✅ Setup complete!"
    echo "To activate the greeter, run: sudo rc-service greetd restart"
    echo "Make sure you are in a TTY (Ctrl+Alt+F1) if you do this."
  '';
  
  home.file.".local/bin/setup-dms-greeter".executable = true;
}
