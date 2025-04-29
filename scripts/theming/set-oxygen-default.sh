#!/bin/bash

# oxygen-theme.sh
# Purpose: Programmatically apply Oxygen theme system-wide for new users in Kubuntu 24.04 LTS (Plasma 5.27).
# Compatibility: Tested on Kubuntu 24.04 LTS (X11/Wayland). Not tested on other versions of Kubuntu or Plasma.
# Author: RJ Subramanian
# Date: 2025-04-28
# License: MIT
# Notes: Sets kdeglobals for theme; legacy configs (e.g., kdedefaults/xsettingsd/gtk/etc.) included to fully replicate System Settings behavior.

# Exit if not root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\033[31mError: This script requires root privileges. Run with sudo: sudo ./oxygen-theme.sh\033[0m"
    exit 1
fi

# Install required packages
echo "Installing oxygen-cursor-theme and oxygen-icon-theme..."
apt-get update
apt-get install -y --no-install-recommends oxygen-cursor-theme oxygen-icon-theme
if [ $? -ne 0 ]; then
    echo -e "\033[31mError: Failed to install packages. Check network or apt configuration.\033[0m"
    exit 1
fi

# Create config directory
echo "Configuring /etc/skel/.config/kdeglobals..."
mkdir -p /etc/skel/.config
if [ $? -ne 0 ]; then
    echo -e "\033[31mError: Failed to create /etc/skel/.config directory.\033[0m"
    exit 1
fi

# Set Oxygen theme in kdeglobals
kwriteconfig5 --file /etc/skel/.config/kdeglobals --group KDE --key LookAndFeelPackage "org.kde.oxygen"
if [ $? -ne 0 ]; then
    echo -e "\033[31mError: Failed to set kdeglobals theme.\033[0m"
    exit 1
fi
chmod 644 /etc/skel/.config/kdeglobals

# Legacy configs to replicate System Settings behavior (optional, for compatibility with KDE4/GTK/X11 apps)
echo "Configuring legacy settings for System Settings compatibility..."
mkdir -p /etc/skel/.config/gtk-3.0
kwriteconfig5 --file /etc/skel/.config/gtk-3.0/settings.ini --group Settings --key gtk-cursor-theme-name "Oxygen_Black"
kwriteconfig5 --file /etc/skel/.config/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name "oxygen"

mkdir -p /etc/skel/.config/gtk-4.0
kwriteconfig5 --file /etc/skel/.config/gtk-4.0/settings.ini --group Settings --key gtk-cursor-theme-name "Oxygen_Black"
kwriteconfig5 --file /etc/skel/.config/gtk-4.0/settings.ini --group Settings --key gtk-icon-theme-name "oxygen"

mkdir -p /etc/skel/.config/kdedefaults
echo "org.kde.oxygen" > /etc/skel/.config/kdedefaults/package
if [ $? -ne 0 ]; then
    echo -e "\033[31mError: Failed to write kdedefaults/package.\033[0m"
    exit 1
fi

kwriteconfig5 --file /etc/skel/.config/kdedefaults/ksplashrc --group KSplash --key Theme "org.kde.oxygen"
kwriteconfig5 --file /etc/skel/.config/kdedefaults/kwinrc --group org.kde.kdecoration2 --key library "org.kde.oxygen"
kwriteconfig5 --file /etc/skel/.config/kdedefaults/kdeglobals --group General --key ColorScheme "Oxygen"
kwriteconfig5 --file /etc/skel/.config/kdedefaults/kdeglobals --group Icons --key Theme "oxygen"
kwriteconfig5 --file /etc/skel/.config/kdedefaults/kcminputrc --group Mouse --key cursorTheme "Oxygen_Black"

mkdir -p /etc/skel/.config/xsettingsd
echo 'Gtk/CursorThemeName "Oxygen_Black"' > /etc/skel/.config/xsettingsd/xsettingsd.conf
echo 'Net/IconThemeName "oxygen"' >> /etc/skel/.config/xsettingsd/xsettingsd.conf
if [ $? -ne 0 ]; then
    echo -e "\033[31mError: Failed to write xsettingsd.conf.\033[0m"
    exit 1
fi

echo 'gtk-cursor-theme-name="Oxygen_Black"' > /etc/skel/.gtkrc-2.0
echo 'gtk-icon-theme-name="oxygen"' >> /etc/skel/.gtkrc-2.0
if [ $? -ne 0 ]; then
    echo -e "\033[31mError: Failed to write .gtkrc-2.0.\033[0m"
    exit 1
fi

echo -e "\033[32mSuccess: Oxygen theme configured for new users in /etc/skel/.config/kdeglobals.\033[0m"
echo "Legacy configs (kdedefaults, gtk, xsettingsd) added for System Settings compatibility."
echo "Create a new user and log in to verify the Oxygen theme (Global Theme, Icons, Cursors, Splash Screen, Window Decorations)."
