helm install --namespace gitlab --name gitlab-runner -f values.yaml gitlab/gitlab-runner

helm repo add gitlab https://charts.gitlab.io
helm init
helm upgrade gitlab-runner \
  --set DOCKER_HOST=/var/run/docker.sock \
  -f values.yaml
  gitlab/gitlab-runner
