Auto Devops Setup: https://docs.gitlab.com/ee/topics/autodevops/quick_start_guide.html


## Setting up the GitLab Runner (custom helm chart)
helm install --namespace gitlab --name gitlab-runner -f gitlab-runner-values.yaml ./gitlab-runner

helm upgrade gitlab-runner \
  -f gitlab-runner-values.yaml \
  --set gitlabUrl=https://gitlab.com/ci/,runnerRegistrationToken=token \
  ./gitlab-runner


helm delete gitlab-runner
