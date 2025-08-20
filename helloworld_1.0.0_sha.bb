SUMMARY = "Hello world sourced from git"
DESCRIPTION = "This is a simple hello world application sourced from git"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=ec16884892013a7cbbd68d2a09fba2e3"

inherit cmake

# Version-specific recipe using specific commit SHA
PV = "1.0.0"
SRC_URI = "git://github.com/debalghosh1207/Hello-World.git;branch=main;protocol=https"

# Use specific commit SHA instead of AUTOREV for reproducible builds
SRCREV = "73f108705eff67567c85f3d9db535d1f7b35cf56"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/helloworld ${D}${bindir}/
}
