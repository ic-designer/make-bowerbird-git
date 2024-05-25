# Constants
WORKDIR_GITHOOKS := .git/hooks
TARGET_GITHOOKS := .githooks

# Always rebuild the hooks
ifeq ($(filter-out $(TARGET_GITHOOKS), $(MAKECMDGOALS)), $(MAKECMDGOALS))
	__ := $(shell $(MAKE) $(TARGET_GITHOOKS))
endif

# Targets
PHONY: $(TARGET_GITHOOKS)
$(TARGET_GITHOOKS): $(WORKDIR_GITHOOKS)/pre-push
	@echo Building githooks...

# Hooks
define PRE_PUSH
#!/bin/sh

while read local_ref local_sha remote_ref remote_sha
do
    if [ "$$remote_ref" = "refs/heads/main" ]; then
        echo "Pushing to branch \"main\" is forbidden. Please issue a pull request."
        exit 1
    fi
done

exit 0
endef

export PRE_PUSH
.PHONY: $(WORKDIR_GITHOOKS)/pre-push
$(WORKDIR_GITHOOKS)/pre-push: | $(WORKDIR_GITHOOKS)/.
	@echo "$$PRE_PUSH" > $@
	@chmod u+x $@

$(WORKDIR_GITHOOKS)/.:
	@mkdir -p $@
