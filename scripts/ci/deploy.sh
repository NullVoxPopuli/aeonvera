#!/bin/bash

. .env

gem install dpl
dpl --provider=heroku --app=$HEROKU_APP_NAME --api-key=$HEROKU_API_KEY
curl -n -X POST \
  "https://api.heroku.com/apps/$HEROKU_APP_NAME/ps" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${HEROKU_API_KEY}" \
  -d "command=bundle exec rails db:migrate"

