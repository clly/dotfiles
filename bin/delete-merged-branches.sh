#!/usr/bin/env bash

set -euo pipefail

# Script to delete local branches that have been merged into main
# Handles both regular merges and squash merges

MAIN_BRANCH="main"
DRY_RUN=false
FORCE=false

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Delete local branches that have been merged into main"
    echo ""
    echo "Options:"
    echo "  -d, --dry-run    Show what would be deleted without actually deleting"
    echo "  -f, --force      Skip confirmation prompt"
    echo "  -h, --help       Show this help message"
    echo ""
    echo "This script detects both regular merges and squash merges."
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Make sure we're up to date with remote
echo "Fetching latest changes from remote..."
git fetch --prune

# Get the current branch to avoid deleting it
current_branch=$(git branch --show-current)

# Function to check if a branch has been squash merged
is_squash_merged() {
    local branch="$1"
    # Check if the merge commit exists by looking for commits with the same changes
    # This works by comparing the tree hash of the branch tip with merge commits in main
    local branch_tree=$(git rev-parse "$branch^{tree}")
    git rev-list --merges "$MAIN_BRANCH" | while read merge_commit; do
        if [[ $(git rev-parse "$merge_commit^{tree}") == "$branch_tree" ]]; then
            return 0
        fi
    done
    return 1
}

# Get branches merged via regular merge
echo "Finding branches merged via regular merge..."
merged_branches=$(git branch --merged "$MAIN_BRANCH" | grep -v "^\*" | grep -v "^[[:space:]]*$MAIN_BRANCH$" | sed 's/^[[:space:]]*//' || true)

# Get branches that might be squash merged
echo "Checking for squash merged branches..."
squash_merged_branches=""
all_branches=$(git branch | grep -v "^\*" | grep -v "^[[:space:]]*$MAIN_BRANCH$" | sed 's/^[[:space:]]*//')

for branch in $all_branches; do
    if [[ "$merged_branches" != *"$branch"* ]] && is_squash_merged "$branch"; then
        squash_merged_branches="$squash_merged_branches $branch"
    fi
done

# Combine all branches to delete
all_merged_branches="$merged_branches $squash_merged_branches"
all_merged_branches=$(echo "$all_merged_branches" | tr ' ' '\n' | grep -v '^$' | sort -u || true)

if [[ -z "$all_merged_branches" ]]; then
    echo "No merged branches found to delete."
    exit 0
fi

echo ""
echo "Branches that would be deleted:"
echo "$all_merged_branches" | sed 's/^/  - /'
echo ""

if [[ "$DRY_RUN" == true ]]; then
    echo "DRY RUN: No branches were actually deleted."
    exit 0
fi

# Confirm deletion unless --force is used
if [[ "$FORCE" != true ]]; then
    echo -n "Do you want to delete these branches? [y/N] "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# Delete the branches
echo ""
echo "Deleting merged branches..."
deleted_count=0
failed_count=0

for branch in $all_merged_branches; do
    if [[ "$branch" == "$current_branch" ]]; then
        echo "  Skipping $branch (current branch)"
        continue
    fi
    
    echo -n "  Deleting $branch... "
    if git branch -d "$branch" > /dev/null 2>&1; then
        echo "✓"
        ((deleted_count++))
    else
        echo "✗ (failed)"
        ((failed_count++))
    fi
done

echo ""
echo "Summary:"
echo "  Deleted: $deleted_count branches"
if [[ $failed_count -gt 0 ]]; then
    echo "  Failed:  $failed_count branches"
fi