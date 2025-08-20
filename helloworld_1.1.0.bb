SUMMARY = "Hello world sourced from git"
DESCRIPTION = "This is a simple hello world application sourced from git"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=ec16884892013a7cbbd68d2a09fba2e3"

inherit cmake

# Version 1.1.0 - Added versioning support and Bitbake recipe examples
PV = "1.1.0"
SRC_URI = "git://github.com/debalghosh1207/Hello-World.git;branch=main;protocol=https"

# Use specific commit SHA for reproducible builds
SRCREV = "b91a1e4d40a05f40272bbf5ba58d67523c664c05"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/helloworld ${D}${bindir}/
}
