docker-compose -f docker-compose.ci.yml run --rm web rake db:create db:migrate
docker-compose -f docker-compose.ci.yml run --rm web rspec
