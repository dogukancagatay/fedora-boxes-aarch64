PACKER_ON_ERROR := cleanup
PACKER_MAX_PROCS := 2
PACKER_CACHE_DIR := ./packer_cache/
PACKER_LOG := 1
PACKER_LOG_PATH := ./logs/generic-parallels-log-$(shell date +'%Y%m%d.%H.%M.%S').log

ifndef VERSION
	VERSION := 0.0.4
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

%:
	$(MAKE) build-box BOX_TYPE=$@
