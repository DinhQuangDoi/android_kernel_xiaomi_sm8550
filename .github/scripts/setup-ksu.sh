#!/usr/bin/env bash
set -euo pipefail

KSU_REPO="https://github.com/KernelSU-Next/KernelSU-Next.git"
KSU_COMMIT="26fded805206ae4542f4745e09cc465412994492"

KERNEL_DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
cd "${KERNEL_DIR}"

rm -rf KernelSU-Next
git clone --quiet "${KSU_REPO}" KernelSU-Next
git -C KernelSU-Next fetch --quiet origin "${KSU_COMMIT}"
git -C KernelSU-Next checkout --quiet "${KSU_COMMIT}"

rm -f drivers/kernelsu
ln -s ../../KernelSU-Next/kernel drivers/kernelsu

echo "KernelSU-Next ready at $(git -C KernelSU-Next rev-parse HEAD)"
