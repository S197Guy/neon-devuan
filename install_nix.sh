#!/bin/bash
# neon-Devuan Nix Installer (OpenRC/Devuan Optimized)

echo "🌸 Installing Nix (Multi-user, no-init mode)..."
# Using --init none to prevent failure on systemd-free Devuan
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none --no-confirm

echo "✨ Enabling Flakes..."
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

echo "🚀 Nix is installed in --init none mode."
echo "   Since you are on Devuan/OpenRC, you may need to start the nix-daemon manually"
echo "   or use the provided openrc script in modules/init.d/nix-daemon"
echo "   Please restart your shell and run 'nix --version' to verify."
