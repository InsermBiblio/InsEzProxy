.PHONY: help
.DEFAULT_GOAL := help

help:
	@test -f /usr/bin/xmlstarlet || echo "Needs: sudo apt-get install --yes xmlstarlet"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

cleanup-docker: ## remove all insezproxy docker image
	test -z "$$(docker ps -a | grep insezproxy)" || \
            docker rm --force $$(docker ps -a | grep insezproxy | awk '{ print $$1 }')

run-dev: ## run insezproxy for dev environment
	docker-compose -f docker-compose.dev.yml up

run-prod: ## run insezproxy for production environment
	docker-compose -f docker-compose.prod.yml up -d

save-ws-key: ## save wskey.key from ezproxy docker image to locale folder
	docker cp insezproxy_proxy_1:/usr/local/ezproxy/wskey.key ./proxy.key
	
load-ws-key: ## load wskey.key from locale folder to ezproxy docker image
	docker cp ./proxy.key insezproxy_proxy_1:/usr/local/ezproxy/wskey.key
	
