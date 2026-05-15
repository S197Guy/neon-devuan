#!/bin/bash
# neon-Devuan Bootstrap Script 🌸
# Designed for a fresh Devuan (OpenRC) install.

set -e

echo "🌸 Starting neon-Devuan Bootstrap..."

# 1. Install System Dependencies
echo "📦 Installing base system dependencies..."
sudo apt update
sudo apt install -y build-essential cmake meson pkg-config libegl1 mesa-vulkan-drivers libgl1-mesa-dri elogind libpam-elogind git curl xz-utils unzip fontconfig alsa-utils pipewire pipewire-audio-client-libraries wireplumber network-manager network-manager-gnome network-manager-openvpn network-manager-vpnc network-manager-openconnect bluez blueman pavucontrol rfkill libspa-0.2-bluetooth

# 2. Install Nix (OpenRC Optimized)
if ! command -v nix &> /dev/null; then
    echo "❄️ Installing Nix (Multi-user, --init none)..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none --no-confirm
fi

# 3. Setup Nix-Daemon Service
echo "⚙️ Configuring nix-daemon OpenRC service..."
sudo cp modules/init.d/nix-daemon /etc/init.d/nix-daemon
sudo chmod +x /etc/init.d/nix-daemon
sudo rc-update add nix-daemon default
sudo rc-service nix-daemon restart || echo "⚠️ Service failed to start"

# 4. Configure Nix Experimental Features
echo "🧪 Enabling Nix Flakes..."
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
echo "sandbox = false" | sudo tee -a /etc/nix/nix.conf

# 5. Environment Variables
echo "🌐 Configuring environment variables..."
cat << 'VARS' >> "$HOME/.profile"

# neon-Devuan Environment
export NIX_REMOTE=daemon
export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
VARS

# 6. Install JetBrainsMono Nerd Font
echo "🎨 Installing JetBrainsMono Nerd Font..."
mkdir -p ~/.local/share/fonts
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o /tmp/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts
rm /tmp/JetBrainsMono.zip
fc-cache -fv

echo "🚀 Bootstrap complete! Please RESTART your machine."
