SUMMARY = "Hello world sourced from git"
DESCRIPTION = "This is a simple hello world application sourced from git"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=ec16884892013a7cbbd68d2a09fba2e3"

inherit cmake

# Version 1.2.0 - Added say_hello_world module
PV = "1.2.0"
SRC_URI = "git://github.com/debalghosh1207/Hello-World.git;branch=main;protocol=https"

# Use specific commit SHA for reproducible builds
SRCREV = "381205a5486526f906c9e3b287f0b59cd5d5af85"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/helloworld ${D}${bindir}/
}
