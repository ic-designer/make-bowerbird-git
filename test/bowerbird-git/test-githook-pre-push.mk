# Constants
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)
override TEST_FILE.MK := $(lastword $(MAKEFILE_LIST))

#Targets
PHONY: test-githook-pre-push
test-githook-pre-push: $(WORKDIR_TEST)/test-githook-pre-push/hooks/pre-push-expected
	$(MAKE) $(TARGET_GITHOOKS) WORKDIR_GITHOOKS=$(WORKDIR_TEST)/$@/hooks
	@test -f $(WORKDIR_TEST)/$@/hooks/pre-push
	@test -x $(WORKDIR_TEST)/$@/hooks/pre-push
	@diff  $(WORKDIR_TEST)/$@/hooks/pre-push $(WORKDIR_TEST)/$@/hooks/pre-push-expected
	@printf "\e[1;32mPassed: $(TEST_FILE.MK)::$@\e[0m\n"


$(WORKDIR_TEST)/%/pre-push-expected: $(MAKEFILE_LIST)
	@mkdir -p $(dir $@)
	@echo '#!/bin/sh' > $@
	@echo '' >> $@
	@echo 'while read local_ref local_sha remote_ref remote_sha' >> $@
	@echo 'do' >> $@
	@echo '    if [ "$$remote_ref" = "refs/heads/main" ]; then' >> $@
	@echo '        echo "Pushing to branch \"main\" is forbidden. Please issue a pull request."' >> $@
	@echo '        exit 1' >> $@
	@echo '    fi' >> $@
	@echo 'done' >> $@
	@echo '' >> $@
	@echo 'exit 0' >> $@
