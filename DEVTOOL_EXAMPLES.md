# Practical devtool Recipe Upgrade Examples

## Example 1: Simple Version Upgrade

Assuming you have a new release v1.2.0, here's how to upgrade:

### In your Yocto build environment:
```bash
# 1. Source your environment
source /path/to/poky/oe-init-build-env

# 2. Upgrade to latest version
devtool upgrade helloworld

# 3. Or upgrade to specific version
devtool upgrade helloworld --version 1.2.0
```

## Example 2: Upgrade with Specific Commit

```bash
# Get the commit SHA for a specific tag from GitHub
git ls-remote https://github.com/debalghosh1207/Hello-World.git refs/tags/v1.2.0

# Use devtool with specific commit
devtool upgrade helloworld --version 1.2.0 --srcrev <commit_sha>
```

## Example 3: Using the Automation Script

```bash
# Make sure you're in your Yocto build environment first
source /path/to/poky/oe-init-build-env

# Run the upgrade script
./upgrade_recipe_devtool.sh helloworld 1.2.0

# Or with specific commit
./upgrade_recipe_devtool.sh helloworld 1.2.0 abc123def456
```

## What devtool upgrade does automatically:

1. **Fetches latest source**: Downloads the latest code from your git repository
2. **Updates SRCREV**: Changes to the latest commit or specified commit
3. **Updates PV**: Changes the package version
4. **Renames recipe**: Changes filename from helloworld_1.1.0.bb to helloworld_1.2.0.bb
5. **Preserves modifications**: Keeps any local patches or modifications
6. **Tests build**: Verifies the recipe still builds correctly

## Manual Verification Commands

After devtool upgrade, you can verify:

```bash
# Check what devtool is managing
devtool status

# Show recipe details
devtool show helloworld

# Build the recipe
devtool build helloworld

# Check the recipe file
find . -name "helloworld*.bb" -exec cat {} \;
```

## Integration with Your Release Process

Combine with your release script for full automation:

```bash
#!/bin/bash
# complete_upgrade_workflow.sh

VERSION=$1
if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

# 1. Create GitHub release
./create_release.sh $VERSION

# 2. Get the commit SHA
COMMIT_SHA=$(git rev-parse HEAD)

# 3. Upgrade recipe using devtool (in Yocto environment)
./upgrade_recipe_devtool.sh helloworld $VERSION $COMMIT_SHA

echo "Complete upgrade workflow finished for version $VERSION"
```

## Troubleshooting Common Issues

### Issue 1: "Recipe not found"
```bash
# Check if recipe is in your layers
bitbake-layers show-layers
bitbake-layers show-recipes helloworld

# Add your layer if missing
bitbake-layers add-layer /path/to/your/layer
```

### Issue 2: "Git fetch failed"
```bash
# Test git connectivity
git ls-remote https://github.com/debalghosh1207/Hello-World.git

# Check proxy settings if behind corporate firewall
export http_proxy=http://proxy:port
export https_proxy=http://proxy:port
```

### Issue 3: "Build fails after upgrade"
```bash
# Check for new dependencies
devtool build helloworld -v

# Reset and try manual approach
devtool reset helloworld
# Then manually update recipe files
```

### Issue 4: "Version detection problems"
```bash
# Use explicit parameters
devtool upgrade helloworld --version 1.2.0 --srcrev abc123 --no-patch
```
