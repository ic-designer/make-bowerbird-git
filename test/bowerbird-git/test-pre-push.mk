# Constants
override TEST_FILE.MK := $(lastword $(MAKEFILE_LIST))

# Targets
PHONY: test-bash-build-executable
test-bash-build-executable: \
		test-build-bash-executable-no-files \
		test-build-bash-executable-one-file \
		test-build-bash-executable-two-files \


PHONY: test-build-bash-executable-no-files
test-build-bash-executable-no-files:
	@! $(MAKE) -q $(WORKDIR_TEST)/test-build-bash-executable-no-files/executable.sh
	@printf "\e[1;32mPassed: $(TEST_FILE.MK)::$@\e[0m\n"

$(WORKDIR_TEST)/test-build-bash-executable-no-files/executable.sh:
	$(bowerbird::build-bash-executable)


PHONY: test-build-bash-executable-one-file
test-build-bash-executable-one-file: \
		$(WORKDIR_TEST)/test-build-bash-executable-one-file/executable.sh
	@test "alpha" = "$(shell $^)"
	@test "alpha beta" = "$(shell $^ beta)"
	@test "alpha beta gamma" = "$(shell $^ beta gamma)"
	@printf "\e[1;32mPassed: $(TEST_FILE.MK)::$@\e[0m\n"

$(WORKDIR_TEST)/test-build-bash-executable-one-file/executable.sh: \
		$(WORKDIR_TEST)/test-build-bash-executable-one-file/alpha-src.sh
	@$(call bowerbird::build-bash-executable, alpha)


PHONY: test-build-bash-executable-two-files
test-build-bash-executable-two-files: \
		$(WORKDIR_TEST)/test-build-bash-executable-two-files/executable.sh
	@test "alpha beta" = "$(shell $^)"
	@test "alpha gamma beta gamma" = "$(shell $^ gamma)"
	@test "alpha gamma delta beta gamma delta" = "$(shell $^ gamma delta)"
	@printf "\e[1;32mPassed: $(TEST_FILE.MK)::$@\e[0m\n"

$(WORKDIR_TEST)/test-build-bash-executable-two-files/executable.sh: \
		$(WORKDIR_TEST)/test-build-bash-executable-one-file/alpha-src.sh \
		$(WORKDIR_TEST)/test-build-bash-executable-one-file/beta-src.sh
	@$(call bowerbird::build-bash-executable, alpha "$$@" beta)


$(WORKDIR_TEST)/%-src.sh: $(MAKEFILE_LIST)
	@mkdir -p $(dir $@)
	@echo 'function $(notdir $*) () { echo $(notdir $*) "$$@"; }' > $@
