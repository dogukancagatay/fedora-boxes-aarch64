PACKER_ON_ERROR := cleanup
PACKER_MAX_PROCS := 2
PACKER_CACHE_DIR := ./packer_cache/
PACKER_LOG := 1
PACKER_LOG_PATH := ./logs/generic-parallels-log-$(shell date +'%Y%m%d.%H.%M.%S').log

ifndef VERSION
	VERSION := 0.0.5
endif

export PACKER_ON_ERROR
export PACKER_MAX_PROCS
export PACKER_CACHE_DIR
export PACKER_LOG
export PACKER_LOG_PATH
export VERSION


.PHONY: all

preflight:
	mkdir -p "$(shell dirname $(PACKER_LOG_PATH))" output

all: preflight
	@echo "Building all"
	packer build \
		-force \
		-on-error=$(PACKER_ON_ERROR) \
		./templates

build-box: preflight
	@echo "Building $@"
	packer build \
		-force \
		-on-error=$(PACKER_ON_ERROR) \
		-only="parallels-iso.generic-$(BOX_TYPE)-aarch64-parallels" \
		./templates

# usage: make import box=fedora37
import:
	$(eval BOX_LABEL := "generic-$(box)-aarch64-parallels")
	vagrant box add --force \
		--name local/$(BOX_LABEL) \
		./output/$(BOX_LABEL)-$(VERSION).box

# usage: make run box=fedora37
run:
	BOX_LABEL=generic-$(box)-aarch64-parallels \
		vagrant up

# usage: make destroy box=fedora37
destroy:
	BOX_LABEL=generic-$(box)-aarch64-parallels \
		vagrant destroy -f

# catchall
%:
	$(MAKE) build-box BOX_TYPE=$@
