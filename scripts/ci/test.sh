docker-compose -f docker-compose.ci.yml run --rm web rake parallel:setup
docker-compose -f docker-compose.ci.yml run --rm web rake parallel:spec
