SHELL:=/bin/bash

env=prod
region=us-east-2
terraform-backend-region=us-east-2
terraform-backend-bucket=tf-state-$(terraform-backend-region)-$(env)
terraform-backend-key="tf-infra.tfstate"


docker:
	docker-compose -f unix.yml -p "$(shell basename $$PWD)" run --rm unix

gheconfig:
	git config --global url."https://$$GITHUB_PERSONAL_USERNAME:$$GITHUB_PERSONAL_TOKEN@github.com".insteadOf "https://github.com"

init: gheconfig check-env check-region clean
	terraform init -backend-config="bucket=$(terraform-backend-bucket)" -backend-config="region=$(terraform-backend-region)"

clean:
	rm -rf temp/
	rm -rf .terraform
	rm -rf .tfplan

plan: check-env check-region init
	eval "$$(buildenv -e $(env) -d $(region))" && \
	terraform fmt; \
	terraform plan -out=$(env).tfplan -state="$(terraform-backend-key)"

apply: check-env check-region
	eval "$$(buildenv -e $(env) -d $(region))" && \
	terraform apply -state-out="$(terraform-backend-key)" $(env).tfplan 

check-env:
ifndef env
	$(error env is not defined)
endif

check-region:
ifndef region
	$(error region is not defined)
endif
