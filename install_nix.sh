#!/bin/bash
# neon-Devuan Nix Installer

echo "🌸 Installing Nix (Multi-user)..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

echo "✨ Enabling Flakes..."
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

echo "🚀 Nix is ready! Please restart your shell."
