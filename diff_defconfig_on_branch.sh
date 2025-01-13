#!/usr/bin/env bash

set -e

# Save the directory of the script
DIR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${DIR_SCRIPT}/output"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Validate input arguments
if [ "$#" -lt 4 ] || [ "$#" -gt 5 ]; then
    echo "Usage: $0 <git-repo-path> <branch-name> <defconfiga> <defconfigb> [--update-remote]"
    exit 1
fi

# Assign arguments to variables
GIT_REPO_PATH="$1"
BRANCH_NAME="$2"
DEFCONFIG_A="$3"
DEFCONFIG_B="$4"
UPDATE_REMOTE=false

if [ "$#" -eq 5 ] && [ "$5" == "--update-remote" ]; then
    UPDATE_REMOTE=true
fi

# Ensure the provided path is a valid git repository
if [ ! -d "$GIT_REPO_PATH/.git" ]; then
    echo "Error: The provided path is not a valid git repository: $GIT_REPO_PATH"
    exit 1
fi

# Change directory to the git repository
cd "$GIT_REPO_PATH" || exit

# Optionally update remote
if [ "$UPDATE_REMOTE" == true ]; then
    git remote update
fi

# Stash local changes and switch to the specified branch
git stash
if ! git checkout "$BRANCH_NAME"; then
    echo "Error: Failed to checkout branch $BRANCH_NAME"
    exit 1
fi

# Locate defconfig paths
DEFCONFIG_A_PATH=$(find . -name "$DEFCONFIG_A" -type f | head -n 1)
DEFCONFIG_B_PATH=$(find . -name "$DEFCONFIG_B" -type f | head -n 1)

if [ -z "$DEFCONFIG_A_PATH" ]; then
    echo "Error: $DEFCONFIG_A not found in the repository"
    exit 1
fi

if [ -z "$DEFCONFIG_B_PATH" ]; then
    echo "Error: $DEFCONFIG_B not found in the repository"
    exit 1
fi

# Function to save minimal defconfig
save_minimal_defconfig() {
    local defconfig_path="$1"
    make mrproper
    make $(basename "$defconfig_path")
    make savedefconfig
    mv defconfig "$defconfig_path"
}

# Build and save minimal defconfigs
save_minimal_defconfig "$DEFCONFIG_A_PATH"
save_minimal_defconfig "$DEFCONFIG_B_PATH"

# Generate a diff using a Python script and save to a timestamped file
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
DIFF_FILE="${OUTPUT_DIR}/defconfig_diff_${TIMESTAMP}.txt"
python3 "${DIR_SCRIPT}/diff_defconfig.py" $(realpath "$DEFCONFIG_A_PATH") $(realpath "$DEFCONFIG_B_PATH") > "$DIFF_FILE"

# Print the location of the saved diff
echo "DIFF_FILE_PATH=$DIFF_FILE"

echo "Defconfigs updated successfully."
