# Bitbake Recipe Upgrade Guide for Hello-World

## Current Recipe Structure

The recipe should be named using the version pattern: `helloworld_<version>.bb`

### Template Recipe (helloworld_X.Y.Z.bb)

```bitbake
SUMMARY = "Hello world sourced from git"
DESCRIPTION = "This is a simple hello world application sourced from git"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=ec16884892013a7cbbd68d2a09fba2e3"

inherit cmake

# Update these values for each release
PV = "X.Y.Z"
SRCREV = "<commit_sha_for_this_version>"

SRC_URI = "git://github.com/debalghosh1207/Hello-World.git;branch=main;protocol=https"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/helloworld ${D}${bindir}/
}
```

## Upgrade Process

### Method 1: Using Git Tags (Recommended for Development)
```bitbake
PV = "1.1.0"
SRC_URI = "git://github.com/debalghosh1207/Hello-World.git;tag=v${PV};protocol=https"
SRCREV = "${AUTOREV}"
```

### Method 2: Using Specific Commit SHA (Recommended for Production)
```bitbake
PV = "1.1.0"
SRC_URI = "git://github.com/debalghosh1207/Hello-World.git;branch=main;protocol=https"
SRCREV = "73f108705eff67567c85f3d9db535d1f7b35cf56"
```

## Automation Scripts

### 1. Check for New Releases
Create a script to check for new GitHub releases:

```bash
#!/bin/bash
# check_updates.sh
REPO="debalghosh1207/Hello-World"
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Latest release: $LATEST_RELEASE"
```

### 2. Update Recipe
When a new release is available:

1. Run `./create_release.sh` to create a new release
2. Copy the existing recipe to a new version: `cp helloworld_1.0.0.bb helloworld_1.1.0.bb`
3. Update PV and SRCREV in the new recipe
4. Test the build
5. Remove the old recipe if needed

## Best Practices

1. **Version Naming**: Use semantic versioning (MAJOR.MINOR.PATCH)
2. **Recipe Naming**: Include version in filename: `helloworld_1.0.0.bb`
3. **Commit SHAs**: Use specific commit SHAs for production recipes
4. **Testing**: Always test recipe upgrades before deploying
5. **Changelog**: Maintain a CHANGELOG.md in your repository
6. **CI/CD**: Consider setting up GitHub Actions for automated releases
