ENV=dev
CFN_CREATE_DB_TASK_TEMPLATE_PATH=deployments/create_db_task.yml
CFN_ECS_TEMPLATE_PATH=deployments/ecs.yml

.PHONY: help
help: ## help 表示 `make help` でタスクの一覧を確認できます
	@echo "------- タスク一覧 ------"
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36mmake %-20s\033[0m %s\n", $$1, $$2}'


.PHONY: cfn-deploy-create-db-task
cfn-deploy-create-db-task: ## cfn-deploy-create-db-task. [ args: ENV ].　接続情報など必要に応じてtemplateのmappingsを書き換えてください
	aws cloudformation deploy --capabilities CAPABILITY_NAMED_IAM \
	--template $(CFN_CREATE_DB_TASK_TEMPLATE_PATH) \
	--stack-name redash-$(ENV)-create-db-stack \
	--no-fail-on-empty-changeset \
	--parameter-overrides Env=$(ENV) ProjectName=redash-$(ENV) \
	--tags "Name=redash-$(ENV)-create-db" "Group=redash-$(ENV)"

.PHONY: cfn-deploy
cfn-deploy: ## cfn  deploy. [ args: ENV ]
	aws cloudformation deploy --capabilities CAPABILITY_NAMED_IAM \
	--template $(CFN_ECS_TEMPLATE_PATH) \
	--stack-name redash-$(ENV)-stack \
	--no-fail-on-empty-changeset \
	$(CFN_OPTION) \
	--parameter-overrides Env=$(ENV) ProjectName=redash-$(ENV) \
	--tags "Name=redash-$(ENV)-stack" "Group=redash-$(ENV)"


.PHONY: cfn-dev-deploy
cfn-dev-deploy: ## cfn dev deploy.
	make cfn-deploy ENV=dev

.PHONY: cfn-prd-deploy
cfn-prd-deploy: ## cfn prd deploy.
	make cfn-deploy ENV=prd