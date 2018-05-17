run_env:
	docker run \
		-it \
		--rm \
		--name "$$(basename $$PWD)-ruby23" \
		-v `pwd`:/usr/src/app \
		-w /usr/src/app \
		ruby:2.3 \
		"bundle install && npm install -g mjml && bash"
