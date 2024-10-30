#!/bin/bash

# Script Author: Kelvym Campos
# GitHub: https://github.com/Kelvym115
# Date: 30/10/2024
# License: MIT License

# Configuration
GITHUB_REPO="owner/repo-name"              # repository in the format "owner/repo"
DOWNLOAD_DIR="/path/to/download/dir"        # generic path where the version will be downloaded
GITHUB_TOKEN="YOUR_GITHUB_TOKEN"            # add your personal GitHub access token
GITHUB="https://api.github.com"

# Define the target version we want to search for, such as alpha, beta, or prod for example
# Release tag examples: alpha-v4.0.0, beta-v4.0.0, prod-v4.0.0
TARGET_VERSION="beta"

# Check the current version of the repository (replace as needed for your version checking logic)
CURRENT_VERSION=$(cat "$DOWNLOAD_DIR/current_version.txt")

# Get the latest version available on GitHub with authentication
LATEST_VERSION=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "$GITHUB/repos/$GITHUB_REPO/releases" \
    | grep -E '"tag_name": "('"$TARGET_VERSION"'-v[0-9]+\.[0-9]+\.[0-9]+)' | head -n 1 | cut -d\" -f4)

function gh_curl() {
    curl -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3.raw" \
        "$@"
}

# Check if a new version was found
if [ -z "$LATEST_VERSION" ]; then
    echo "No new version found for $TARGET_VERSION."
    exit 1
fi

# Check if the latest version is different from the current version
if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
    echo "New version found: $LATEST_VERSION"

    # Get the asset ID related to the version
    ASSET_ID=$(gh_curl -s "$GITHUB/repos/$GITHUB_REPO/releases/tags/$LATEST_VERSION" | jq -r '.assets[] | select(.name | test("beta-v.*\\.zip")) | .id')

    if [ "$ASSET_ID" = "null" ]; then
        echo "ERROR: Asset not found for version $LATEST_VERSION."
        exit 1
    fi

    # Download URL of the asset
    DOWNLOAD_URL="$GITHUB/repos/$GITHUB_REPO/releases/assets/$ASSET_ID"

    # Download the zipped file of the new version
    wget -q --header="Authorization: token $GITHUB_TOKEN" --header="Accept:application/octet-stream" "$DOWNLOAD_URL" -O "$DOWNLOAD_DIR/$LATEST_VERSION.zip"
    echo "Download of version $LATEST_VERSION completed."

    # Extract the ZIP file
    unzip -q "$DOWNLOAD_DIR/$LATEST_VERSION.zip" -d "$DOWNLOAD_DIR"

	# Remove ZIP file (optional)
    rm "$DOWNLOAD_DIR/$LATEST_VERSION.zip"
    echo "Extraction of the new version completed."

    # Update the current version record
    echo "$LATEST_VERSION" > "$DOWNLOAD_DIR/current_version.txt"

	# Add here your deploy logic...
else
    echo "No new version found."
fi