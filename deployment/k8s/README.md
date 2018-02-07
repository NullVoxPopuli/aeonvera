Auto Devops Setup: https://docs.gitlab.com/ee/topics/autodevops/quick_start_guide.html


## Setting up the GitLab Runner (custom helm chart)
helm install --namespace gitlab --name gitlab-runner -f gitlab-runner-values.yaml ./gitlab-runner

helm upgrade gitlab-runner \
  -f gitlab-runner-values.yaml \
  --set gitlabUrl=https://gitlab.com/ci/,runnerRegistrationToken=token \
  ./gitlab-runner


helm delete gitlab-runner

## Creating a new environment within the cluster

#### nginx ingress controller
```bash
helm install stable/nginx-ingress --namespace default
```

#### The App
```bash
helm install ./app-chart --values ci-values.yaml
```

#### For Cluster Auto-Scaling,
https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#which-version-on-cluster-autoscaler-should-i-use-in-my-cluster

Also: https://github.com/kubernetes/autoscaler

#### SSL via Let's Encrypt
```bash
helm install stable/kube-lego
```

see https://github.com/kubernetes/charts/tree/master/stable/kube-lego for config details


## Updating

### Helm overall

List Releases:
```bash
helm list
```

Update:
```bash
helm upgrade "release-name" ./app-chart/  --values ci-values.yaml
```
