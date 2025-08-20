#!/bin/bash

# Release management script for Hello-World project
# Usage: ./create_release.sh <version> [release_notes]

set -e

VERSION=$1
RELEASE_NOTES=${2:-"Release version $VERSION"}

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version> [release_notes]"
    echo "Example: $0 1.1.0 'Added new features'"
    exit 1
fi

# Validate version format (semantic versioning)
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must follow semantic versioning (e.g., 1.0.0)"
    exit 1
fi

echo "Creating release for version $VERSION..."

# Ensure we're on the main branch and up to date
git checkout main
git pull origin main

# Check if working directory is clean
if ! git diff-index --quiet HEAD --; then
    echo "Error: Working directory is not clean. Please commit or stash changes."
    exit 1
fi

# Create and push tag
TAG="v$VERSION"
git tag -a "$TAG" -m "Release $TAG: $RELEASE_NOTES"
git push origin "$TAG"

# Get the commit SHA for the tag
COMMIT_SHA=$(git rev-parse HEAD)

echo "Tag $TAG created and pushed successfully!"
echo "Commit SHA: $COMMIT_SHA"
echo ""
echo "Next steps:"
echo "1. Go to GitHub and create a release from tag $TAG"
echo "2. Update your Bitbake recipe:"
echo "   - Change PV to \"$VERSION\""
echo "   - Change SRCREV to \"$COMMIT_SHA\""
echo ""
echo "Updated recipe values:"
echo "PV = \"$VERSION\""
echo "SRCREV = \"$COMMIT_SHA\""
