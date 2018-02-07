# gem install dpl
# dpl --provider=heroku --app=$HEROKU_APP_NAME --api-key=$HEROKU_API_KEY
# curl -n -X POST \
#   "https://api.heroku.com/apps/$HEROKU_APP_NAME/ps" \
#   -H "Accept: application/json" \
#   -H "Authorization: Bearer ${HEROKU_API_KEY}" \
#   -d "command=bundle exec rake db:migrate"
#
gcloud config set project $GCLOUD_PROJECT_NAME
gcloud container clusters get-credentials $CLUSTER_NAME \
  --zone us-central1-b --project $GCLOUD_PROJECT_NAME

branch="$(git rev-parse --abbrev-ref HEAD)"
sha="$(git rev-parse HEAD)"
iso8601="$(date --iso-8601=seconds)"
date="${d//:/-}"

# with registry url
BRANCH_TAG="$REGISTRY_URL:$branch"
SHA_TAG="$REGISTRY_URL:$sha"
DATE_TAG="$REGISTRY:$date"

docker build -t $SHA_TAG
docker tag $SHA_TAG $BRANCH_TAG
docker tag $SHA_TAG $DATE_TAG

gcloud docker -- push $SHA_TAG
gcloud docker -- push $BRANCH_TAG
gcloud docker -- push $DATE_TAG

kubectl set image deployment web web=$SHA_TAG --record
kubectl rollout status deployment web
