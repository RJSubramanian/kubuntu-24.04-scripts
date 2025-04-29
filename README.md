# Kubuntu 24.04 LTS Scripts
Scripts for configuring Kubuntu 24.04 LTS (Plasma 5.27).

## Scripts
### set-oxygen-default.sh
- **Description**: Programmatically applies the Oxygen theme as the default for new users via `/etc/skel/.config/kdeglobals`. Includes legacy configs (e.g., kdedefaults, gtk) to replicate System Settings behavior.
- **Usage**:
  ```bash
  sudo bash scripts/theming/set-oxygen-default.sh

## Compatibility
Tested on Kubuntu 24.04 LTS (X11/Wayland) Minimal/Normal installation. May not work on Kubuntu 24.10 (Plasma 6).
