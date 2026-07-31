#!/usr/bin/env bash
set -euo pipefail

KERNEL_DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
BOOT_IMG_URL="${BOOT_IMG_URL:-}"
KSUD_VERSION="${KSUD_VERSION:-v3.3.0}"

DIST_DIR="${KERNEL_DIR}/dist"
mkdir -p "${DIST_DIR}"

cp "${KERNEL_DIR}/out/arch/arm64/boot/Image" "${DIST_DIR}/Image"
cp "${KERNEL_DIR}/out/.config" "${DIST_DIR}/config"

if [ -n "${BOOT_IMG_URL}" ]; then
    curl -sL --fail -o "${DIST_DIR}/stock-boot.img" "${BOOT_IMG_URL}"
    curl -sL --fail -o "${DIST_DIR}/ksud" \
        "https://github.com/KernelSU-Next/KernelSU-Next/releases/download/${KSUD_VERSION}/ksud-x86_64-unknown-linux-musl"
    chmod +x "${DIST_DIR}/ksud"
    "${DIST_DIR}/ksud" boot-patch \
        --boot "${DIST_DIR}/stock-boot.img" \
        --kernel "${DIST_DIR}/Image" \
        --out "${DIST_DIR}" \
        --out-name KernelSU-boot.img
    rm -f "${DIST_DIR}/stock-boot.img" "${DIST_DIR}/ksud"
fi
