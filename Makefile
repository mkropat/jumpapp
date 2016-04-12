PREFIX = /usr/local

BIN	= $(DESTDIR)/$(PREFIX)/bin
MAN	= $(DESTDIR)/$(PREFIX)/share/man

VERSION			= 0.7
PACKAGE_DIR		= jumpapp-$(VERSION)
PACKAGE_FILE		= jumpapp_$(VERSION).tar.bz2
PACKAGE_ORIG_FILE	= jumpapp_$(VERSION).orig.tar.bz2

AUTHOR	= Michael Kropat <mail@michael.kropat.name>
DATE	= Feb 26, 2015
FILES	= t README.md LICENSE.txt Makefile jumpapp jumpappify-desktop-entry

.PHONY: all
all: jumpapp.1

jumpapp.1: README.man.md
	@hash pandoc 2>/dev/null || { echo "ERROR: can't find pandoc. Have you installed it?" >&2; exit 1; }
	pandoc --from=markdown --standalone --output="$@" "$<"

README.man.md: README.md
	echo '% JUMPAPP(1) jumpapp | $(VERSION)' >"$@"
	echo '% $(AUTHOR)' >>"$@"
	echo '% $(DATE)' >>"$@"
	perl -ne 's/^##/#/; print if ! (/^# Installation/ ... /^# /) || /^# (?!Installation)/' "$<" >>"$@"

.PHONY: check test
check: test
test:
	-shellcheck --exclude=SC2016,SC2034 jumpapp jumpappify-desktop-entry
	-checkbashisms jumpappify-desktop-entry
	t/test_jumpapp

.PHONY: install
install:
	mkdir -p "$(BIN)"
	cp jumpapp jumpappify-desktop-entry "$(BIN)"

	mkdir -p "$(MAN)/man1"
	cp jumpapp.1 "$(MAN)/man1/"

.PHONY: uninstall
uninstall:
	-rm -f "$(BIN)/jumpapp" "$(BIN)/jumpappify-desktop-entry"
	-rm -f "$(MAN)/man1/jumpapp.1"

.PHONY: clean
clean:
	-rm -f README.man.md
	-rm -f jumpapp*.tar.bz2 jumpapp*.deb jumpapp*.rpm
	-rm -f jumpapp.1


##### make dist #####

.PHONY: dist
dist: $(PACKAGE_FILE)

$(PACKAGE_FILE): $(FILES)
	tar --transform 's,^,$(PACKAGE_DIR)/,S' -cjf "$@" $^


### make deb deb-src deb-clean ###

.PHONY: deb
deb: jumpapp_$(VERSION)-1_all.deb

jumpapp_$(VERSION)-1_all.deb: $(PACKAGE_FILE) debian/copyright
	@hash dpkg-buildpackage 2>/dev/null || { \
		echo "ERROR: can't find dpkg-buildpackage. Did you run \`sudo apt-get install debhelper devscripts\`?" >&2; exit 1; \
	}
	dpkg-buildpackage -b -tc -uc -us
	mv "../$@" .
	mv ../jumpapp_$(VERSION)-1_*.changes .

.PHONY: deb-src
deb-src: jumpapp_$(VERSION)-1_source.changes

jumpapp_$(VERSION)-1_source.changes: $(PACKAGE_FILE) $(PACKAGE_ORIG_FILE) debian/copyright
	@hash dpkg-buildpackage 2>/dev/null || { echo "ERROR: can't find debuild. Did you run \`sudo apt-get install debhelper devscripts\`?" >&2; exit 1; }
	tar xf "$<"
	cp -r debian "$(PACKAGE_DIR)"
	(cd "$(PACKAGE_DIR)"; debuild -S)

$(PACKAGE_ORIG_FILE): $(PACKAGE_FILE)
	cp "$<" "$@"

debian/copyright: LICENSE.txt
	cp "$<" "$@"

.PHONY: deb-clean
deb-clean:
	-debian/rules clean
	-rm -f *.build *.changes *.dsc *.debian.tar.gz *.orig.tar.bz2
	-rm -rf $(PACKAGE_DIR)
	-rm -f debian/copyright

.PHONY: deb-deploy
deb-deploy: jumpapp_$(VERSION)-1_source.changes
	dput ppa:mkropat/ppa "$<"

ubuntu-%:
	vagrant up ubuntu
	vagrant ssh -c 'cd /vagrant; make $*' ubuntu


### make rpm ###

.PHONY: rpm
rpm: $(PACKAGE_FILE)
	@hash rpmbuild 2>/dev/null || { echo "ERROR: can't find rpmbuild. Did you run \`yum install @development-tools\`?" >&2; exit 1; }
	@test -d "$$HOME/rpmbuild" || { echo "ERROR: ~/rpmbuild does not exist. Did you run \`rpmdev-setuptree\`?" >&2; exit 1; }
	cp "$<" ~/rpmbuild/SOURCES/
	sed s/%{VERSION}/$(VERSION)/ jumpapp.spec >~/rpmbuild/SPECS/jumpapp.spec
	rpmbuild -ba ~/rpmbuild/SPECS/jumpapp.spec
	mv ~/rpmbuild/RPMS/noarch/jumpapp-$(VERSION)-1.*.noarch.rpm .
	mv ~/rpmbuild/SRPMS/jumpapp-$(VERSION)-1.*.src.rpm .

fedora-%:
	vagrant up fedora
	vagrant ssh -c 'cd /vagrant; make $*' fedora
