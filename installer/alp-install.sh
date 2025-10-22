#!/bin/bash
set -e

# AlpineLight Installer - TUI with whiptail

# Function definitions FIRST
disk_setup() {
    whiptail --title "Disk Setup" --msgbox "Disk setup functionality will be implemented here" 10 40
}

package_management() {
    whiptail --title "Package Management" --msgbox "Package management will be implemented here" 10 40
}

system_config() {
    whiptail --title "System Configuration" --msgbox "System configuration will be implemented here" 10 40
}

create_iso() {
    whiptail --title "Create ISO" --msgbox "ISO creation will be implemented here" 10 40
}

show_welcome() {
    whiptail --title "AlpineLight Installer" --msgbox \
    "Welcome to AlpineLight Installation

This installer will guide you through setting up
AlpineLight on your system.

Features:
• Ultra-lightweight Alpine base
• Modular package system
• TUI-based installation
• Customizable components

Press OK to continue" 16 60
}

show_main_menu() {
    while true; do
        choice=$(whiptail --title "AlpineLight Main Menu" --menu "Choose operation:" 15 60 5 \
            "1" "Install AlpineLight to disk" \
            "2" "Manage packages and modules" \
            "3" "System configuration" \
            "4" "Create custom ISO" \
            "5" "Exit installer" 3>&1 1>&2 2>&3)
        
        case $choice in
            1)
                disk_setup
                ;;
            2)
                package_management
                ;;
            3)
                system_config
                ;;
            4)
                create_iso
                ;;
            5)
                whiptail --title "Exit" --msgbox "Thank you for using AlpineLight!" 8 40
                exit 0
                ;;
            *)
                exit 0
                ;;
        esac
    done
}

# Start installer
show_welcome
show_main_menu
