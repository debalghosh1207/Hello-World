#!/bin/bash

# Automated recipe upgrade script using devtool
# Usage: ./upgrade_recipe_devtool.sh <recipe_name> <new_version> [new_srcrev]

set -e

RECIPE_NAME=${1:-"helloworld"}
NEW_VERSION=$2
NEW_SRCREV=$3
LAYER_PATH=${LAYER_PATH:-"meta-custom"}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

if [ -z "$NEW_VERSION" ]; then
    echo "Usage: $0 <recipe_name> <new_version> [new_srcrev]"
    echo "Example: $0 helloworld 1.2.0"
    echo "Example: $0 helloworld 1.2.0 abc123def456"
    exit 1
fi

print_status "Starting recipe upgrade for $RECIPE_NAME to version $NEW_VERSION"

# Check if devtool is available
if ! command -v devtool &> /dev/null; then
    print_error "devtool not found. Please source your Yocto environment first:"
    echo "  source /path/to/poky/oe-init-build-env"
    exit 1
fi

# Check if recipe exists
if ! bitbake-layers show-recipes $RECIPE_NAME &> /dev/null; then
    print_error "Recipe $RECIPE_NAME not found in any layer"
    print_warning "Available recipes:"
    bitbake-layers show-recipes | grep -i hello || true
    exit 1
fi

print_status "Current recipe status:"
bitbake-layers show-recipes $RECIPE_NAME

# Backup current recipe
CURRENT_RECIPE=$(bitbake-layers show-recipes $RECIPE_NAME 2>/dev/null | grep "\.bb" | awk '{print $1}' | head -1)
if [ -n "$CURRENT_RECIPE" ]; then
    print_status "Backing up current recipe: $CURRENT_RECIPE"
    RECIPE_PATH=$(bitbake-layers show-recipes $RECIPE_NAME -f 2>/dev/null | grep "\.bb:" | awk -F: '{print $1}' | head -1)
    if [ -n "$RECIPE_PATH" ]; then
        cp "$RECIPE_PATH" "${RECIPE_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Backup created: ${RECIPE_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
fi

# Perform the upgrade
print_status "Upgrading recipe using devtool..."

if [ -n "$NEW_SRCREV" ]; then
    print_status "Upgrading to version $NEW_VERSION with specific SRCREV $NEW_SRCREV"
    devtool upgrade $RECIPE_NAME --version $NEW_VERSION --srcrev $NEW_SRCREV
else
    print_status "Upgrading to version $NEW_VERSION (auto-detecting SRCREV)"
    devtool upgrade $RECIPE_NAME --version $NEW_VERSION
fi

# Check devtool status
print_status "Current devtool status:"
devtool status

# Build the upgraded recipe
print_status "Testing build of upgraded recipe..."
if devtool build $RECIPE_NAME; then
    print_status "Build successful!"
else
    print_error "Build failed! Check the logs above."
    print_warning "You can reset the upgrade with: devtool reset $RECIPE_NAME"
    exit 1
fi

# Option to deploy to target (if available)
read -p "Do you want to deploy to a target device? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter target IP address: " TARGET_IP
    if [ -n "$TARGET_IP" ]; then
        print_status "Deploying to target $TARGET_IP..."
        devtool deploy-target $RECIPE_NAME root@$TARGET_IP || print_warning "Deploy failed, but upgrade was successful"
    fi
fi

# Finish the upgrade
read -p "Do you want to finish the upgrade and commit changes? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Finishing upgrade and committing to layer $LAYER_PATH..."
    devtool finish $RECIPE_NAME $LAYER_PATH
    print_status "Upgrade completed successfully!"
    print_status "Recipe has been updated in $LAYER_PATH"
else
    print_warning "Upgrade not committed. Recipe is still in devtool workspace."
    print_warning "You can:"
    print_warning "  - Finish later with: devtool finish $RECIPE_NAME $LAYER_PATH"
    print_warning "  - Reset/cancel with: devtool reset $RECIPE_NAME"
fi

print_status "Recipe upgrade process completed!"
echo
echo "Summary:"
echo "  Recipe: $RECIPE_NAME"
echo "  New Version: $NEW_VERSION"
echo "  SRCREV: $NEW_SRCREV"
echo "  Status: $(devtool status | grep $RECIPE_NAME || echo 'Not in devtool workspace')"
