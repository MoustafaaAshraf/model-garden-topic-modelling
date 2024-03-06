#!make
-include .env
export

POETRY := poetry

help: ## Display this help
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

pre-commit: ## Run pre-commit
	@ ${POETRY} run pre-commit run --all-files

test: ## Run tests
	@ ${POETRY} run pytest

plan: ## Run terraform plan
	@cd terraform && \
		rm -rf .terraform && \
		terraform init && \
		terraform plan \
			-var-file=project_configuration/variables.auto.tfvars \
			-out=terraform.tfplan

apply: ## Run terraform apply
	@cd terraform && \
		rm -rf .terraform && \
		terraform init && \
		terraform apply terraform.tfplan

destroy: ## Run terraform apply
	@cd terraform && \
		rm -rf .terraform && \
		terraform init && \
		terraform destroy \
			-var-file=project_configuration/variables.auto.tfvars
