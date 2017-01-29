.PHONY: build

AWS_ROLE ?= arn:aws:iam::543279062384:role/admin

build:
	$(if $(and $(AWS_PROFILE),$(AWS_ROLE)),$(call assume_role,$(AWS_ROLE)),)
	@ packer build packer.json

# AWS assume role settings
# Conditionally attempts to assume IAM role using STS
# Syntax: $(call assume_role,<role-arn>)
get_assume_session = aws sts assume-role --role-arn=$(1) --role-session-name=packer
get_assume_credential = jq --null-input '$(1)' | jq .Credentials.$(2) -r
define assume_role
	$(eval AWS_SESSION = $(shell $(call get_assume_session,$(1))))
	$(eval export AWS_ACCESS_KEY_ID = $(shell $(call get_assume_credential,$(AWS_SESSION),AccessKeyId)))
	$(eval export AWS_SECRET_ACCESS_KEY = $(shell $(call get_assume_credential,$(AWS_SESSION),SecretAccessKey)))
	$(eval export AWS_SESSION_TOKEN = $(shell $(call get_assume_credential,$(AWS_SESSION),SessionToken)))
endef