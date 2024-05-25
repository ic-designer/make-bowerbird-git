_PATH := $(dir $(lastword $(MAKEFILE_LIST)))
include $(_PATH)/src/bowerbird-git/bowerbird-githooks.mk
