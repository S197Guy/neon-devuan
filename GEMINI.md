# 🧠 Project Memory: neon-Devuan

This file serves as a context bridge for Gemini CLI to understand the project history, architecture, and deployment quirks.

## 🎯 System Context
- **Target Machine:** Lenovo IdeaPad S340-15IWL (Intel i5-8265U / UHD 620).
- **Base OS:** Devuan Linux (Systemd-free).
- **Init System:** OpenRC.
- **Goal:** Minimal, beautiful, pastel-themed (Catppuccin) dev environment.

## 🏗️ Architecture (The Nix Way)
- **Configuration:** Managed via Nix Flakes + Home Manager.
- **Window Manager:** MangoWM (dwl-fork with SceneFX).
- **Desktop Shell:** Dank Material Shell (DMS).
- **Acceleration:** Uses nixGL to bridge Nix binaries with host Mesa drivers.

## 🛠️ Critical Fixes & Knowledge
1. **Nix Installation:** Must use the --init none flag on Devuan to bypass systemd detection.
2. **GPU Setup (Devuan):** The `non-nixos-gpu-setup` script fails due to a `systemd-tmpfiles` dependency. Manually create the required symlink: `sudo ln -sfT /nix/store/mz8v1mak8d64vd2gcw5cfv8idyxs0xgx-non-nixos-gpu /run/opengl-driver`.
3. **Nix-Daemon (OpenRC):** A custom init script exists at modules/init.d/nix-daemon. It uses "use net" instead of "need net" to avoid virtual service conflicts.
4. **EGL/OpenGL Fix:** On non-NixOS, MangoWM fails to initialize EGL. Use the start-neon wrapper which runs nixGLIntel mango.
4. **Catppuccin Module:** The Home Manager module name was corrected to catppuccin.homeModules.catppuccin.
5. **Generic Linux:** targets.genericLinux.enable and systemd.user.enable are configured for Devuan compatibility.

## 🚀 Deployment Workflow
1. Run ./install_nix.sh.
2. Setup OpenRC daemon using the script in modules/init.d/.
3. Apply config: nix run .#home-manager -- switch --flake .#neonscar.
4. Launch from TTY: start-neon.

## 🎨 Theme Plan (Pending)
Currently in PoC Mode. Plan is to re-introduce catppuccin/nix for Mocha/Pink pastel styling once core stability is confirmed.
