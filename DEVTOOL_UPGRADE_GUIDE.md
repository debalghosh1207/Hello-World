# Devtool Recipe Upgrade Guide for Hello-World

## Overview
devtool provides automated recipe upgrade capabilities that can:
- Automatically detect new versions from git repositories
- Update SRCREV to the latest commit or specific tag
- Handle version bumps and recipe file renaming
- Create patches for any local modifications

## Basic devtool upgrade Commands

### 1. Upgrade to Latest Commit on Branch
```bash
# Upgrade to latest commit on the current branch
devtool upgrade helloworld

# This will:
# - Fetch latest changes from the git repository
# - Update SRCREV to the latest commit
# - Rename recipe file if PV changes
```

### 2. Upgrade to Specific Version/Tag
```bash
# Upgrade to a specific git tag
devtool upgrade helloworld --version 1.2.0

# Or upgrade to a specific git revision
devtool upgrade helloworld --srcrev b91a1e4d40a05f40272bbf5ba58d67523c664c05
```

### 3. Upgrade with Branch Specification
```bash
# Upgrade to latest commit on a specific branch
devtool upgrade helloworld --srcbranch main
```

## Step-by-Step Upgrade Process

### Step 1: Setup devtool workspace
```bash
# Initialize devtool workspace (if not already done)
devtool create-workspace /path/to/workspace

# Or use existing workspace
source /path/to/poky/oe-init-build-env
```

### Step 2: Upgrade the recipe
```bash
# Basic upgrade to latest version
devtool upgrade helloworld

# Or upgrade to specific version
devtool upgrade helloworld --version 1.2.0 --srcrev <new_commit_sha>
```

### Step 3: Test the upgrade
```bash
# Build the upgraded recipe
devtool build helloworld

# Deploy to target for testing (if you have a target)
devtool deploy-target helloworld root@<target_ip>
```

### Step 4: Finish the upgrade
```bash
# Commit the changes back to your layer
devtool finish helloworld /path/to/your/layer
```

## Advanced devtool Options

### Upgrade with Custom Git Repository
```bash
# If you need to change the source repository
devtool upgrade helloworld --srcuri "git://github.com/debalghosh1207/Hello-World.git;branch=main;protocol=https"
```

### Upgrade with Version Override
```bash
# Override the version detection
devtool upgrade helloworld --version 1.2.0 --no-patch
```

### Dry Run Mode
```bash
# See what changes would be made without applying them
devtool upgrade helloworld --dry-run
```

## Example Workflow for Hello-World Project

### Current State
- Recipe: helloworld_1.1.0.bb
- SRCREV: b91a1e4d40a05f40272bbf5ba58d67523c664c05
- PV: 1.1.0

### Upgrade to v1.2.0 (when available)
```bash
# 1. Upgrade recipe to latest tag
devtool upgrade helloworld --version 1.2.0

# 2. Verify the changes
devtool status

# 3. Build and test
devtool build helloworld

# 4. If satisfied, finish the upgrade
devtool finish helloworld meta-custom
```

## Manual Recipe Update Alternative

If devtool doesn't work as expected, you can manually update:

### Method 1: Update Existing Recipe
```bash
# Get latest commit SHA
git ls-remote https://github.com/debalghosh1207/Hello-World.git refs/tags/v1.2.0

# Update recipe manually
# - Change PV = "1.2.0"
# - Change SRCREV = "<new_commit_sha>"
```

### Method 2: Copy and Rename Recipe
```bash
# Copy current recipe to new version
cp helloworld_1.1.0.bb helloworld_1.2.0.bb

# Update the new recipe with new SRCREV and PV
# Remove old recipe if needed
```

## Troubleshooting devtool upgrade

### Common Issues and Solutions

1. **Recipe not found**
   ```bash
   # Ensure recipe is in your layer path
   bitbake-layers show-recipes helloworld
   ```

2. **Git fetch failures**
   ```bash
   # Check git connectivity
   git ls-remote https://github.com/debalghosh1207/Hello-World.git
   ```

3. **Version detection issues**
   ```bash
   # Use explicit version specification
   devtool upgrade helloworld --version 1.2.0 --srcrev <commit_sha>
   ```

4. **Build failures after upgrade**
   ```bash
   # Check for new dependencies or build requirements
   devtool build helloworld -v
   ```

## Best Practices

1. **Always test after upgrade**: Build and test thoroughly
2. **Use specific commits**: Prefer specific SRCREV over AUTOREV
3. **Version your recipes**: Keep version numbers in recipe filenames
4. **Backup before upgrade**: Keep copies of working recipes
5. **Check dependencies**: Ensure all dependencies are still compatible
6. **Document changes**: Update recipe comments with upgrade notes

## Integration with CI/CD

```bash
#!/bin/bash
# automated_upgrade.sh
RECIPE_NAME="helloworld"
NEW_VERSION="1.2.0"
NEW_SRCREV="<commit_sha>"

# Upgrade recipe
devtool upgrade $RECIPE_NAME --version $NEW_VERSION --srcrev $NEW_SRCREV

# Test build
if devtool build $RECIPE_NAME; then
    echo "Build successful, finishing upgrade"
    devtool finish $RECIPE_NAME meta-custom
else
    echo "Build failed, reverting changes"
    devtool reset $RECIPE_NAME
    exit 1
fi
```
