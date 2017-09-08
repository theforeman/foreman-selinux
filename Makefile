.PHONY: clean remote-load load reload

INSTPREFIX=
VARIANT=targeted
TYPE=apps
VERSION=99.999
MANCHAPTER=Foreman
TMPDIR=local-tmp-foreman

ifndef DISTRO
$(error *** Set the DISTRO variable e.g. rhel7 or fedora21 ***)
endif

ifneq ("$(wildcard /usr/share/selinux/devel/include/*/docker.if)","")
export M4PARAM += -D has_docker
else ifneq ("$(wildcard /usr/share/selinux/devel/include/*/container.if)","")
export M4PARAM += -D has_container
else ifneq ($(DISTRO),rhel6)
$(error *** Interface container.if or docker.if not present, cannot continue ***)
endif

all: policies all-data

load: \
	foreman.pp.load.tmp \
	foreman-proxy.pp.load.tmp

policies: \
	foreman.pp.bz2 \
	foreman-proxy.pp.bz2

all-data: man-pages scripts

man-pages: \
	foreman-selinux-enable.8 \
	foreman-selinux-disable.8 \
	foreman-selinux-relabel.8 \
	foreman-proxy-selinux-enable.8 \
	foreman-proxy-selinux-disable.8 \
	foreman-proxy-selinux-relabel.8

scripts: \
	foreman-proxy-selinux-enable \
	foreman-proxy-selinux-disable

foreman-selinux-enable.8: common/selinux-enable.pod.in.sh
	bash $< "foreman" "Foreman" | \
		pod2man --name="${@:.8=}" -c "${MANCHAPTER}" --section=8 --release=${VERSION} > $@

foreman-selinux-disable.8: common/selinux-disable.pod.in.sh
	bash $< "foreman" "Foreman" | \
		pod2man --name="${@:.8=}" -c "${MANCHAPTER}" --section=8 --release=${VERSION} > $@

foreman-selinux-relabel.8: common/selinux-relabel.pod.in.sh
	bash $< "foreman" "Foreman" | \
		pod2man --name="${@:.8=}" -c "${MANCHAPTER}" --section=8 --release=${VERSION} > $@

foreman-proxy-selinux-enable.8: common/selinux-enable.pod.in.sh
	bash $< "foreman-proxy" "Foreman Proxy" | \
		pod2man --name="${@:.8=}" -c "${MANCHAPTER}" --section=8 --release=${VERSION} > $@

foreman-proxy-selinux-disable.8: common/selinux-disable.pod.in.sh
	bash $< "foreman-proxy" "Foreman Proxy" | \
		pod2man --name="${@:.8=}" -c "${MANCHAPTER}" --section=8 --release=${VERSION} > $@

foreman-proxy-selinux-relabel.8: common/selinux-relabel.pod.in.sh
	bash $< "foreman-proxy" "Foreman Proxy" | \
		pod2man --name="${@:.8=}" -c "${MANCHAPTER}" --section=8 --release=${VERSION} > $@

foreman-proxy-selinux-enable: common/selinux-enable.sh
	bash $< "foreman-proxy" > $@

foreman-proxy-selinux-disable: common/selinux-disable.sh
	bash $< "foreman-proxy" > $@

%.pp: %.te
	-rm -rf ${TMPDIR} 2>/dev/null
	-mkdir ${TMPDIR} 2>/dev/null
	cp $< ${<:.te=.fc} ${<:.te=.if} ${TMPDIR}/
	sed -i 's/@@VERSION@@/${VERSION}/' ${TMPDIR}/*.te
	$(MAKE) -C ${TMPDIR} -f /usr/share/selinux/devel/Makefile NAME=${VARIANT} DISTRO=$(DISTRO)
	mv ${TMPDIR}/$@ .

%.pp.load.tmp: %.pp
	$(info ************ LOADING MODULE $< ************)
	semodule -i $<
	touch $@

reload: clean load

%.pp.bz2: %.pp
	bzip2 -c9 ${@:.bz2=} > $@

install: install-policies \
	install-data

install-policies: policies consolidate-installation
	install -d ${INSTPREFIX}/usr/share/selinux/${VARIANT}
	install -p -m 644 *.pp.bz2 ${INSTPREFIX}/usr/share/selinux/${VARIANT}/

install-data: man-pages scripts install-interfaces install-scripts install-manpages

install-interfaces:
	install -d ${INSTPREFIX}/usr/share/selinux/devel/include/${TYPE}
	install -p -m 644 *.if ${INSTPREFIX}/usr/share/selinux/devel/include/${TYPE}/

install-scripts:
	install -d ${INSTPREFIX}/usr/sbin
	install -p -m 755 *-enable *-disable *-relabel ${INSTPREFIX}/usr/sbin/

install-manpages:
	install -d -m 0755 ${INSTPREFIX}/usr/share/man/man8
	install -m 0644 *.8 ${INSTPREFIX}/usr/share/man/man8/

consolidate-installation:
	hardlink -c ${INSTPREFIX}/usr/share/selinux/${VARIANT}/

remote-load:
ifdef HOST
	-rsync -qrav . --delete -e ssh --exclude .git ${HOST}:${TMPDIR}/
	ssh ${HOST} 'cd ${TMPDIR} && sed -i s/@@VERSION@@/${VERSION}/ *.te && make reload DISTRO=${DISTRO}'
else
	$(error You need to define your remote ssh hostname as HOST)
endif

clean:
	rm -rf *.pp* *.pp.bz2 tmp/ local-tmp/ *.8 foreman-*-selinux-enable foreman-*-selinux-disable
