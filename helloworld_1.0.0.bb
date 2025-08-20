SUMMARY = "Hello world sourced from git"
DESCRIPTION = "This is a simple hello world application sourced from git"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=ec16884892013a7cbbd68d2a09fba2e3"

inherit cmake

# Version-specific recipe using GitHub releases
PV = "1.0.0"
SRC_URI = "git://github.com/debalghosh1207/Hello-World.git;tag=v${PV};protocol=https"

# Use specific tag instead of AUTOREV
SRCREV = "${AUTOREV}"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/helloworld ${D}${bindir}/
}
