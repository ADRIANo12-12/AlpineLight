# AlpineLight Changelog
All notable changes to AlpineLight will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Initial project structure
- Basic build system
- Ultra-minimal Alpine base

## [1.0.0-alpha] - 2024-01-01
### Added
- **Core System**: Alpine Linux 3.19.0 base
- **Kernel**: Custom Linux LTS 6.1.x configuration
- **Init System**: OpenRC with custom services
- **Interactive Shell**: Custom Bash environment with AlpineLight menu
- **Networking**: Dropbear SSH, wget, curl, iproute2
- **Storage**: ext4, FAT32 filesystem support
- **System Tools**: htop, vim-tiny, file, less
- **Security**: Basic iptables, sudo, shadow utils
- **Build System**: Automated ISO creation script

### Technical Specifications
- ISO Size: < 50MB
- Memory Usage: 32-45MB at idle
- Architecture: x86_64 only
- Boot Time: 8-15 seconds

### Known Issues
- Live environment only (no installer)
- Limited hardware support
- Basic network configuration
- No package management in runtime

## Pre-release History

### 2024-01-01
- Initial repository setup
- Proprietary license established
- Basic documentation created
- Build system prototype

---

*This changelog is maintained by Adrian Mateusz Sikora. All rights reserved.*
