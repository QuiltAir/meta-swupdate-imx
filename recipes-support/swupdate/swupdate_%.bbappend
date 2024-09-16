FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/swupdate:"

FILES:${PN} += "/www/*"

SRC_URI += "file://swupdate-sysrestart.service \
	file://swupdate.cfg \
	file://swu_public_release.pem \
	file://swu_public_dev.pem \
	file://0001-mongoose-enable-cgi.patch \
	file://sysinfo.cgi  \
"

FILES:${PN} += " \
	${systemd_system_unitdir}/swupdate-sysrestart.service \
"

RDEPENDS:${PN}-www += "bash"

SYSTEMD_SERVICE:${PN} += "swupdate-sysrestart.service"

do_install:append () {
	install -m 644 ${WORKDIR}/swupdate.cfg ${D}/${sysconfdir}
	if ${@bb.utils.contains_any('DISTRO', ['quilt-qsm-release', 'quilt-donut-release'], 'true', 'false', d)}; then
		install -m 644 ${WORKDIR}/swu_public_release.pem ${D}/${sysconfdir}/swu_public.pem
	else
		install -m 644 ${WORKDIR}/swu_public_dev.pem ${D}/${sysconfdir}/swu_public.pem
	fi

	install -m 644 ${WORKDIR}/swupdate-sysrestart.service ${D}${systemd_system_unitdir}
	install -m 0755 ${WORKDIR}/sysinfo.cgi ${D}/www/sysinfo.cgi
}

