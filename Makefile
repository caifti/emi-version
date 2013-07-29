name=emi-version
tag=master
package_version=3.5.0-1

git=https://github.com/caifti/emi-version.git

# needed dirs
source_dir=sources
rpmbuild_dir=$(shell pwd)/rpmbuild

# spec file
spec_src=$(name).spec.in
spec=$(name).spec
dist=$(shell rpm --eval '%dist' | sed 's/%dist/.el5/')

.PHONY: clean rpm

all: rpm

print-info:
	@echo
	@echo
	@echo "Packaging $(name) fetched from $(git) for tag $(tag)."
	@echo

prepare-sources: sanity-checks clean
	mkdir -p $(source_dir)/$(name)
	git clone $(git) $(source_dir)/$(name)
	cd $(source_dir)/$(name) && git checkout $(tag) && git archive --format=tar --prefix=$(name)/ $(tag) > $(name)-$(package_version).tar
	cd $(source_dir) && gzip $(name)/$(name)-$(package_version).tar
	cp $(source_dir)/$(name)/$(name)-$(package_version).tar.gz $(source_dir)/$(name)-$(package_version).tar.gz

prepare-spec: prepare-sources
	sed -e 's#@@PACKAGE_VERSION@@#$(package_version)#g' \
	$(spec_src) > $(spec)

rpm: prepare-spec
	mkdir -p $(rpmbuild_dir)/BUILD \
	$(rpmbuild_dir)/RPMS \
	$(rpmbuild_dir)/SOURCES \
	$(rpmbuild_dir)/SPECS \
	$(rpmbuild_dir)/SRPMS
	echo $(rpm_version); exit
	cp $(source_dir)/$(name)-$(version).tar.gz $(rpmbuild_dir)/SOURCES
	rpmbuild --nodeps -v -ba $(spec) --define "_topdir $(rpmbuild_dir)" --define "dist $(dist)" --define "package_version $(package_version)"

clean:
	rm -rf $(source_dir) $(rpmbuild_dir) $(spec)

sanity-checks:
ifndef package_version
        $(error package_version is undefined)
endif
