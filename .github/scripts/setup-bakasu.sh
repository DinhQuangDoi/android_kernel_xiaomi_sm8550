#!/usr/bin/env bash
set -euo pipefail

BAKASU_REPO="${BAKASU_REPO:-https://github.com/Baka-SU/BakaSU.git}"
BAKASU_REF="${1:-${BAKASU_REF:-5b76b884c75f729a220bb317aa4a4fc78f0e0e9c}}"

KERNEL_DIR="${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
cd "${KERNEL_DIR}"

rm -rf KernelSU KernelSU-Next

# Clone the default branch shallow, then fetch + checkout the pinned commit.
# Do NOT use `git clone --depth 1 --branch <SHA>`: GitHub does not advertise a
# raw commit hash as a branch, and a bounded --depth clone may not reach an
# older pinned commit (fails with "unable to read tree").
if ! git clone --depth 1 "${BAKASU_REPO}" KernelSU; then
    git clone "${BAKASU_REPO}" KernelSU
fi
git -C KernelSU fetch --depth 1 origin "${BAKASU_REF}" || git -C KernelSU fetch origin "${BAKASU_REF}"
git -C KernelSU checkout "${BAKASU_REF}"

# Remove temporary upstream build error on main for SuSFS if present
if [ -f "KernelSU/kernel/tools/susfs_compat.mk" ]; then
    sed -i '/Please wait susfs update/d' KernelSU/kernel/tools/susfs_compat.mk 2>/dev/null || true
fi

rm -f drivers/kernelsu
ln -s ../KernelSU/kernel drivers/kernelsu

echo "BakaSU ready at $(git -C KernelSU rev-parse HEAD)"
