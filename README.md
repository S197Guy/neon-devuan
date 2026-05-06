# neon-Devuan 🌸

A beautiful, minimal, and pastel-themed Devuan Linux configuration managed the **Nix way**.

## 🎨 Aesthetic
- **Theme:** Catppuccin (Pastels)
- **Window Manager:** [MangoWM](https://github.com/mangowm/mango) (dwl-based with scenefx animations)
- **Desktop Shell:** [Dank Material Shell (DMS)](https://github.com/AvengeMedia/DankMaterialShell)

## 🛠️ Infrastructure
- **Base OS:** Devuan Linux (Systemd-free)
- **Configuration:** Nix Flakes + Home Manager
- **Target Hardware:** Lenovo IdeaPad S340-15IWL

## 🚀 Quick Start

Follow these steps to get your environment up and running on a fresh Devuan install.

### 1. Install Nix & Enable Flakes
We've provided a helper script to install Nix (multi-user) and enable the necessary experimental features:

```bash
git clone https://github.com/S197Guy/neon-devuan.git
cd neon-devuan
./install_nix.sh
```
*Note: You will need to restart your shell after this step.*

### 2. Apply the Configuration
Once Nix is installed, you can apply the Home Manager configuration directly from the flake:

```bash
nix run .#home-manager -- switch --flake .#neonscar
```

### 3. Launching the Environment
After applying the configuration, you can start MangoWM (which will automatically launch the Dank Material Shell):

```bash
# From a TTY
mangowm
```

## ⌨️ Keybindings
- **Mod + B**: Launch Browser (Chromium)
- **Mod + Return**: Open Terminal (Kitty)
- **Mod + J / K**: Focus Workspace Up/Down
- **Alt + J / K**: Focus Window Up/Down (within a column)
- **Mod + Q**: Close Window
- **Mod + M**: Exit MangoWM

## 📁 Repository Structure
- `flake.nix`: Entry point and dependency management.
- `modules/home.nix`: Core user configuration.
- `modules/theme.nix`: Centralized Catppuccin Mocha styling.
- `modules/mangowm.nix`: Window manager and keybinding definitions.
