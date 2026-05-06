# neon-Devuan 🌸 (PoC Mode)

This is a **Proof of Concept** configuration for Devuan Linux on the Lenovo IdeaPad S340. 

## 🛠️ The PoC Stack
- **Base OS:** Devuan Linux (OpenRC)
- **WM:** [MangoWM](https://github.com/mangowm/mango)
- **Shell:** [dms-shell](https://github.com/DreamMaoMao/dms-shell) (The shell recommended by MangoWM's author)
- **Acceleration:** nixGL (Fixes EGL/OpenGL on non-NixOS)

## 🚀 Quick Start (PoC)

1. **Install Nix**:
   ```bash
   ./install_nix.sh
   ```
2. **Apply PoC Config**:
   ```bash
   nix run .#home-manager -- switch --flake .#neonscar
   ```
3. **Start Session**:
   To fix the "Could not initialize EGL" error, use the provided wrapper script:
   ```bash
   # From a TTY
   start-neon
   ```

## 📁 Repository Structure
- `modules/mangowm.nix`: Configures the WM and the `start-neon` wrapper.
- `modules/home.nix`: Includes `dms-shell` and required system tools.
