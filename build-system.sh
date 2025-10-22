#!/bin/bash
set -e

echo "🏔️ AlpineLight Build System"
echo "==========================="

download_alpine() {
    if [ ! -f alpine-minirootfs.tar.gz ]; then
        echo "📥 Downloading Alpine Linux..."
        if ! wget -q http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-minirootfs-3.19.3-x86_64.tar.gz -O alpine-minirootfs.tar.gz; then
            echo "❌ Failed to download Alpine Linux"
            exit 1
        fi
        echo "✅ Alpine Linux downloaded successfully"
    fi
}

verify_alpine() {
    echo "🔍 Verifying Alpine download..."
    if ! file alpine-minirootfs.tar.gz | grep -q "gzip compressed"; then
        echo "❌ alpine-minirootfs.tar.gz is corrupted"
        rm -f alpine-minirootfs.tar.gz
        return 1
    fi
    echo "✅ Alpine file verified"
    return 0
}

build_core() {
    echo "🔨 Building core system..."
    
    download_alpine
    
    if ! verify_alpine; then
        echo "❌ Cannot build without valid Alpine base"
        exit 1
    fi
    
    # Extract Alpine base
    mkdir -p build/rootfs
    echo "📦 Extracting rootfs..."
    if tar xzf alpine-minirootfs.tar.gz -C build/rootfs; then
        echo "✅ Core system extracted successfully"
    else
        echo "❌ Failed to extract rootfs"
        exit 1
    fi
}

build_iso() {
    echo "📀 Building ISO image..."
    if command -v genisoimage >/dev/null 2>&1; then
        if genisoimage -o output/alpinelight-core.iso -V "ALPINELIGHT" build/ 2>/dev/null; then
            echo "✅ ISO created: output/alpinelight-core.iso"
        else
            echo "⚠️ ISO creation failed, but continuing..."
        fi
    else
        echo "⚠️ genisoimage not found, skipping ISO creation"
        echo "💡 Install with: sudo apt-get install genisoimage"
    fi
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

echo "🎉 Build completed successfully!"
