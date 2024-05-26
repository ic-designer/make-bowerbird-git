# Constants
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)
override TEST_FILE.MK := $(lastword $(MAKEFILE_LIST))

#Targets
PHONY: test-githook-pre-push
test-githook-pre-push: \
		test-githook-pre-push-gitdir-file-exists \
		test-githook-pre-push-gitdir-file-executable \
		test-githook-pre-push-gitdir-file-contents \
		test-githook-pre-push-testdir-file-exists \
		test-githook-pre-push-testdir-file-executable \
		test-githook-pre-push-testdir-file-contents \


PHONY: test-githook-pre-push-gitdir-file-exists
test-githook-pre-push-gitdir-file-exists:
	@test -f  $(WORKDIR_GITHOOKS)/pre-push
	@printf "\e[1;32mPassed: $(TEST_FILE.MK)::$@\e[0m\n"

PHONY: test-githook-pre-push-gitdir-file-executable
test-githook-pre-push-gitdir-file-executable:
	@test -x  $(WORKDIR_GITHOOKS)/pre-push
	@printf "\e[1;32mPassed: $(TEST_FILE.MK)::$@\e[0m\n"

PHONY: test-githook-pre-push-gitdir-file-contents
test-githook-pre-push-gitdir-file-contents: \
			$(WORKDIR_TEST)/test-githook-pre-push-gitdir-file-contents/hooks/pre-push-expected
	@diff $(WORKDIR_GITHOOKS)/pre-push $(WORKDIR_TEST)/$@/hooks/pre-push-expected
	@printf "\e[1;32mPassed: $(TEST_FILE.MK)::$@\e[0m\n"


PHONY: test-githook-pre-push-testdir-file-exists
test-githook-pre-push-testdir-file-exists:
	@$(MAKE) $(TARGET_GITHOOKS) WORKDIR_GITHOOKS=$(WORKDIR_TEST)/$@/hooks
	@test -f $(WORKDIR_TEST)/$@/hooks/pre-push
	@printf "\e[1;32mPassed: $(TEST_FILE.MK)::$@\e[0m\n"

PHONY: test-githook-pre-push-testdir-file-executable
test-githook-pre-push-testdir-file-executable:
	@$(MAKE) $(TARGET_GITHOOKS) WORKDIR_GITHOOKS=$(WORKDIR_TEST)/$@/hooks
	@test -x $(WORKDIR_TEST)/$@/hooks/pre-push
	@printf "\e[1;32mPassed: $(TEST_FILE.MK)::$@\e[0m\n"

PHONY: test-githook-pre-push-testdir-file-contents
test-githook-pre-push-testdir-file-contents: \
			$(WORKDIR_TEST)/test-githook-pre-push-testdir-file-contents/hooks/pre-push-expected
	@$(MAKE) $(TARGET_GITHOOKS) WORKDIR_GITHOOKS=$(WORKDIR_TEST)/$@/hooks
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
