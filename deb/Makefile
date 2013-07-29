name=emi-version
prefix=/

# needed dirs
debbuild_dir=$(shell pwd)/debbuild
rules_src=$(shell pwd)/debian/rules.in
rules=$(shell pwd)/debian/rules

#deb_version=3.0.0
deb_age=1
here=$(shell pwd)

.PHONY: clean build install deb

all: deb

####################################################################
# Install
####################################################################

build:
	@echo building ...
	@echo $(package_version)-$(deb_age) > emi-version

install: build
	@echo installing ...
	@mkdir -p $(prefix)/etc
	@cp -fp emi-version $(prefix)/etc

###########################################################$(DESTDIR)#########
# Build Distribution
####################################################################

DISTFILES=debian

prepare-rules:
	sed -e 's#@@PACKAGE_VERSION@@#$(package_version)#g' $(rules_src) > $(rules)

srcdist: prepare-rules
	mkdir -p $(here)/$(name)-$(package_version)
	@cp -a $(DISTFILES) $(here)/$(name)-$(package_version)
	cd $(here) && tar cvz --exclude='*.github*' -f $(name)_$(package_version).orig.tar.gz $(name)-$(package_version)/*
	@rm -rf $(name)-$(package_version)

prepare-debbuilddir: srcdist
	@mkdir -p $(debbuild_dir)
	@cp $(name)_$(package_version).orig.tar.gz $(debbuild_dir)/$(name)_$(package_version).orig.tar.gz
	@cd $(debbuild_dir) && tar xzvf $(name)_$(package_version).orig.tar.gz
	@echo "done"

deb-src: prepare-debbuilddir
	cd $(debbuild_dir) && dpkg-source -b $(name)-$(package_version)

deb: deb-src
	cd $(debbuild_dir)/$(name)-$(package_version) && debuild -us -uc

clean:
	@rm -rf $(name)_$(package_version).orig.tar.gz $(debbuild_dir)

