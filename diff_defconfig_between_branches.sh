#!/usr/bin/env bash

set -e

# Save the directory of the script
DIR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${DIR_SCRIPT}/output"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Validate input arguments
if [ "$#" -lt 5 ] || [ "$#" -gt 6 ]; then
    echo "Usage: $0 <git-repo-path> <branch-name-1> <branch-name-2> <defconfiga> <defconfigb> [--update-remote]"
    exit 1
fi

# Assign arguments to variables
GIT_REPO_PATH="$1"
BRANCH_NAME_1="$2"
BRANCH_NAME_2="$3"
DEFCONFIG_A="$4"
DEFCONFIG_B="$5"
UPDATE_REMOTE=false

if [ "$#" -eq 6 ] && [ "$6" == "--update-remote" ]; then
    UPDATE_REMOTE=true
fi

# Ensure the provided path is a valid git repository
if [ ! -d "$GIT_REPO_PATH/.git" ]; then
    echo "Error: The provided path is not a valid git repository: $GIT_REPO_PATH"
    exit 1
fi

# Sanitize branch names for file naming
sanitize_branch_name() {
    echo "$1" | sed 's/[^a-zA-Z0-9._-]/_/g'
}

SANITIZED_BRANCH_1=$(sanitize_branch_name "$BRANCH_NAME_1")
SANITIZED_BRANCH_2=$(sanitize_branch_name "$BRANCH_NAME_2")

# Run the diff_defconfig_on_branch.sh script for both branches
DIFF_FILE_1=""
DIFF_FILE_2=""

run_diff_script() {
    local branch="$1"
    bash "${DIR_SCRIPT}/diff_defconfig_on_branch.sh" "$GIT_REPO_PATH" "$branch" "$DEFCONFIG_A" "$DEFCONFIG_B" ${UPDATE_REMOTE:+--update-remote}
}

# Run the diff script for branch 1 and parse the output
echo "---------------------"
echo "Generating diff for $BRANCH_NAME_1"
DIFF_FILE_1=$(run_diff_script "$BRANCH_NAME_1" | grep "DIFF_FILE_PATH" | cut -d'=' -f2)
echo "$BRANCH_NAME_1 Done"

# Run the diff script for branch 2 and parse the output
echo "---------------------"
echo "Generating diff for $BRANCH_NAME_2"
DIFF_FILE_2=$(run_diff_script "$BRANCH_NAME_2" | grep "DIFF_FILE_PATH" | cut -d'=' -f2)
echo "$BRANCH_NAME_2 Done"

# Ensure both diff files exist
if [ ! -f "$DIFF_FILE_1" ]; then
    echo "Error: Diff file for branch $BRANCH_NAME_1 not found."
    exit 1
fi

if [ ! -f "$DIFF_FILE_2" ]; then
    echo "Error: Diff file for branch $BRANCH_NAME_2 not found."
    exit 1
fi

# Generate a diff of the two diff files without treating differences as an error
COMBINED_DIFF_FILE="${OUTPUT_DIR}/combined_diff_${SANITIZED_BRANCH_1}_vs_${SANITIZED_BRANCH_2}_$(date +"%Y%m%d%H%M%S").txt"
DIFF_MESSAGE=""
if ! diff "$DIFF_FILE_1" "$DIFF_FILE_2" > "$COMBINED_DIFF_FILE"; then
    DIFF_MESSAGE="Differences found and saved to $COMBINED_DIFF_FILE"
else
    DIFF_MESSAGE="No differences found between the files."
fi

# Print the paths of the diff files and the combined diff file
echo "DIFF_FILE_1=$DIFF_FILE_1"
echo "DIFF_FILE_2=$DIFF_FILE_2"
echo "COMBINED_DIFF_FILE=$COMBINED_DIFF_FILE"

# If there are changes, cat the combined diff file to the console
if [ -s "$COMBINED_DIFF_FILE" ]; then
    echo "\nChanges in the combined diff file:"
    cat "$COMBINED_DIFF_FILE"
fi

# Print the final message
echo "$DIFF_MESSAGE"
