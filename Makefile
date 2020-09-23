install:
	bundle install
env-vars:
	cp .env.example .env.staging
	@op get item "Machine Tokens - end-to-end-tests users" | jq -r '.details.sections[1].fields[] | "\(.t),\(.v)"' | \
	while read token ; do \
		key=$$(echo $$token | cut -d ',' -f1); \
		value=$$(echo $$token | cut -d ',' -f2); \
		sed -i '' -e "s/{$${key}}/$${value}/" .env.staging; \
	done
