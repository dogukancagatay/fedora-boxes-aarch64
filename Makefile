PACKER_ON_ERROR := cleanup
PACKER_MAX_PROCS := 2
PACKER_CACHE_DIR := ./packer_cache/
PACKER_LOG := 1
PACKER_LOG_PATH := ./logs/generic-parallels-log-$(shell date +'%Y%m%d.%H.%M.%S').log

ifndef VERSION
	VERSION := 0.0.9
endif

export PACKER_ON_ERROR
export PACKER_MAX_PROCS
export PACKER_CACHE_DIR
export PACKER_LOG
export PACKER_LOG_PATH
export VERSION


.PHONY: all init build-box import run destroy vm-info

all: preflight
	@echo "Building all"
	packer build \
		-force \
		-on-error=$(PACKER_ON_ERROR) \
		./templates

preflight:
	mkdir -p "$(shell dirname $(PACKER_LOG_PATH))" output

# usage: make box=fedora37 init
init: preflight
	@echo "Initialize $@"
	packer init -upgrade ./templates

# usage: make build-box box=fedora37
build-box: preflight
	$(eval BOX_LABEL := "generic-$(box)-aarch64-parallels")
	@echo "Building $@ ($(BOX_LABEL))"
	packer build \
		-force \
		-on-error=$(PACKER_ON_ERROR) \
		-only="parallels-iso.$(BOX_LABEL)" \
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

# usage: make box=fedora37 vm-info
vm-info:
	BOX_LABEL=generic-$(box)-aarch64-parallels \
		vagrant ssh -c 'cat /etc/fedora-release; uname -srmv; prltoolsd -V'

# catchall
# %:
# 	$(MAKE) build-box BOX_LABEL=$@
