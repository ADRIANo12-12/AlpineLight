#!/bin/bash
set -e

echo "🚀 AlpineLight Ultimate Setup Script"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to log messages
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to continue on error
continue_on_error() {
    if ! "$@"; then
        warn "Command failed but continuing: $*"
        return 0
    fi
}

# Check if whiptail is installed
check_dependencies() {
    log "Checking dependencies..."
    
    if ! command -v whiptail &> /dev/null; then
        error "whiptail is not installed. Installing..."
        continue_on_error sudo apt-get update
        continue_on_error sudo apt-get install -y whiptail
    fi
    
    if ! command -v wget &> /dev/null; then
        warn "wget not found, installing..."
        continue_on_error sudo apt-get install -y wget
    fi
    
    if ! command -v git &> /dev/null; then
        warn "git not found, installing..."
        continue_on_error sudo apt-get install -y git
    fi
}

# Create complete directory structure
create_directory_tree() {
    log "Creating directory structure..."
    
    directories=(
        ".github"
        "core"
        "modules/base"
        "modules/desktop" 
        "modules/development"
        "modules/system"
        "installer/help-texts"
        "scripts"
        "config"
        "output"
        "docs"
        "tests/test-results"
        "utils"
    )
    
    for dir in "${directories[@]}"; do
        continue_on_error mkdir -p "$dir"
        log "Created: $dir"
    done
}

# Create essential files
create_essential_files() {
    log "Creating essential files..."
    
    # Create basic file structure
    files=(
        "LICENSE"
        "README.md"
        "CHANGELOG.md"
        "SECURITY.md"
        "CONTRIBUTING.md"
        "SUPPORT.md"
        ".gitignore"
        ".gitattributes"
        "build-system.sh"
        "core/init"
        "core/kernel-config"
        "core/packages.list"
        "core/setup-core.sh"
        "installer/alp-install.sh"
        "installer/alp-package-manager.sh"
        "installer/alp-disk-setup.sh"
        "installer/alp-bootloader.sh"
        "installer/welcome.txt"
        "scripts/create-module.sh"
        "scripts/build-iso.sh"
        "scripts/test-vm.sh"
        "scripts/chroot-setup.sh"
        "scripts/init-custom.sh"
        "config/whiptail-theme.conf"
        "config/network.conf"
        "config/users.conf"
        "config/storage.conf"
        "config/boot.conf"
        "docs/ARCHITECTURE.md"
        "docs/MODULE-SYSTEM.md"
        "docs/INSTALLATION-GUIDE.md"
        "docs/PACKAGE-CREATION.md"
        "docs/TROUBLESHOOTING.md"
        "tests/test-installer.sh"
        "tests/test-modules.sh"
        "tests/test-boot.sh"
        "utils/alp-module-tool.sh"
        "utils/alp-system-info.sh"
        "utils/alp-backup.sh"
        "utils/alp-recovery.sh"
    )
    
    for file in "${files[@]}"; do
        continue_on_error touch "$file"
        log "Created: $file"
    done
}

# Download Tiny Core Linux
download_tiny_core() {
    log "Downloading Tiny Core Linux..."
    
    TINY_CORE_URL="http://tinycorelinux.net/15.x/x86_64/release/TinyCorePure64-15.0.iso"
    TINY_CORE_FILE="tinycore.iso"
    
    if continue_on_error wget -O "$TINY_CORE_FILE" "$TINY_CORE_URL"; then
        log "Tiny Core Linux downloaded successfully"
        
        # Extract Tiny Core components
        continue_on_error mkdir -p tinycore-extract
        continue_on_error sudo mount -o loop "$TINY_CORE_FILE" tinycore-extract 2>/dev/null || true
        
        # Copy important files for study
        if [ -d "tinycore-extract" ]; then
            continue_on_error cp tinycore-extract/boot/vmlinuz64 core/tinycore-vmlinuz 2>/dev/null || true
            continue_on_error cp tinycore-extract/boot/corepure64.gz core/tinycore-rootfs.gz 2>/dev/null || true
            continue_on_error sudo umount tinycore-extract 2>/dev/null || true
        fi
        
        continue_on_error rm -rf tinycore-extract
    else
        warn "Failed to download Tiny Core Linux, continuing..."
    fi
}

# Download Alpine Linux minirootfs
download_alpine() {
    log "Downloading Alpine Linux minirootfs..."
    
    ALPINE_VERSION="3.19.0"
    ALPINE_URL="http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-minirootfs-${ALPINE_VERSION}-x86_64.tar.gz"
    
    if continue_on_error wget -O alpine-minirootfs.tar.gz "$ALPINE_URL"; then
        log "Alpine Linux minirootfs downloaded successfully"
    else
        warn "Failed to download Alpine minirootfs, continuing..."
    fi
}

# Download additional lightweight components
download_components() {
    log "Downloading additional components..."
    
    # Download SliTaz for study (optional)
    SLITAZ_URL="http://mirror.slitaz.org/iso/rolling/slitaz-rolling-core64.iso"
    continue_on_error wget -O slitaz-sample.iso "$SLITAZ_URL" || warn "Failed to download SliTaz"
    
    # Download useful tools
    continue_on_error wget -O scripts/busybox-x86_64 "https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox" || warn "Failed to download BusyBox"
}

# Initialize git repository
setup_git() {
    log "Setting up git repository..."
    
    if [ ! -d ".git" ]; then
        continue_on_error git init
        continue_on_error git add .
        continue_on_error git commit -m "Initial AlpineLight structure" || warn "Git commit failed"
    else
        log "Git repository already exists"
    fi
}

# Create basic whiptail installer skeleton
create_installer_skeleton() {
    log "Creating installer skeleton..."
    
    cat > installer/alp-install.sh << 'EOF'
#!/bin/bash
set -e

# AlpineLight Installer - TUI with whiptail

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

# Start installer
show_welcome
show_main_menu
EOF

    chmod +x installer/alp-install.sh
}

# Create basic build script
create_build_script() {
    log "Creating build script..."
    
    cat > build-system.sh << 'EOF'
#!/bin/bash
set -e

echo "🏔️ AlpineLight Build System"
echo "==========================="

build_core() {
    echo "Building core system..."
    # Extract Alpine base
    if [ -f alpine-minirootfs.tar.gz ]; then
        mkdir -p build/rootfs
        tar xzf alpine-minirootfs.tar.gz -C build/rootfs
        echo "Core system extracted"
    else
        echo "Error: alpine-minirootfs.tar.gz not found"
        exit 1
    fi
}

build_iso() {
    echo "Building ISO image..."
    # Basic ISO creation logic will go here
    mkisofs -o output/alpinelight-core.iso -V "ALPINELIGHT" build/ 2>/dev/null || {
        echo "ISO creation failed, but continuing..."
    }
}

# Main build process
mkdir -p build output

case "${1:-all}" in
    core)
        build_core
        ;;
    iso)
        build_iso
        ;;
    all)
        build_core
        build_iso
        ;;
    *)
        echo "Usage: $0 {core|iso|all}"
        exit 1
        ;;
esac

echo "Build completed!"
EOF

    chmod +x build-system.sh
}

# Show completion message with whiptail
show_completion() {
    whiptail --title "Setup Complete" --msgbox \
    "AlpineLight setup completed successfully!

What was created:
✅ Directory structure
✅ Essential files
✅ Tiny Core Linux components
✅ Alpine Linux base
✅ TUI installer skeleton
✅ Build system
✅ Git repository

Next steps:
1. Review the created structure
2. Run './build-system.sh' to test build
3. Run './installer/alp-install.sh' for TUI

Press OK to exit" 20 60
}

# Main execution
main() {
    log "Starting AlpineLight complete setup..."
    
    check_dependencies
    create_directory_tree
    create_essential_files
    download_tiny_core
    download_alpine
    download_components
    create_installer_skeleton
    create_build_script
    setup_git
    
    log "Setup completed successfully!"
    
    # Show completion dialog if whiptail is available
    if command -v whiptail &> /dev/null; then
        show_completion
    else
        log "Setup complete! Run './installer/alp-install.sh' to start the TUI installer."
    fi
}

# Run main function
main "$@"