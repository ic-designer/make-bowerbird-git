test-githook-pre-push-gitdir-file-exists:
	test -f $(WORKDIR_GITHOOKS)/pre-push

test-githook-pre-push-gitdir-file-executable:
	test -x $(WORKDIR_GITHOOKS)/pre-push

test-githook-pre-push-gitdir-file-contents: \
			$(WORKDIR_TEST)/test-githook-pre-push-gitdir-file-contents/hooks/pre-push-expected
	diff $(WORKDIR_GITHOOKS)/pre-push $(WORKDIR_TEST)/$@/hooks/pre-push-expected


test-githook-pre-push-testdir-file-exists:
	$(MAKE) $(TARGET_GITHOOKS) WORKDIR_GITHOOKS=$(WORKDIR_TEST)/$@/hooks
	test -f $(WORKDIR_TEST)/$@/hooks/pre-push

test-githook-pre-push-testdir-file-executable:
	$(MAKE) $(TARGET_GITHOOKS) WORKDIR_GITHOOKS=$(WORKDIR_TEST)/$@/hooks
	test -x $(WORKDIR_TEST)/$@/hooks/pre-push

test-githook-pre-push-testdir-file-contents: \
			$(WORKDIR_TEST)/test-githook-pre-push-testdir-file-contents/hooks/pre-push-expected
	$(MAKE) $(TARGET_GITHOOKS) WORKDIR_GITHOOKS=$(WORKDIR_TEST)/$@/hooks
	diff $(WORKDIR_TEST)/$@/hooks/pre-push $(WORKDIR_TEST)/$@/hooks/pre-push-expected


$(WORKDIR_TEST)/%/pre-push-expected: $(MAKEFILE_LIST)
	mkdir -p $(dir $@)
	echo '#!/bin/sh' > $@
	echo '' >> $@
	echo 'while read local_ref local_sha remote_ref remote_sha' >> $@
	echo 'do' >> $@
	echo '    if [ "$$remote_ref" = "refs/heads/main" ]; then' >> $@
	echo '        echo "Pushing to branch \"main\" is forbidden. Please issue a pull request."' >> $@
	echo '        exit 1' >> $@
	echo '    fi' >> $@
	echo 'done' >> $@
	echo '' >> $@
	echo 'exit 0' >> $@
