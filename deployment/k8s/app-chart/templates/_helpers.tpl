{{/* vim: set filetype=mustache: */}}

{{/*
The name of the redis deployment
*/}}
{{- define "redis.name" -}}
{{ printf "redis" }}
{{- end -}}

{{/*
The name of the secrets
*/}}
{{- define "secrets.name" -}}
{{ printf "%s-secrets" .Values.namespace }}
{{- end -}}

{{/*
The name of the web service
*/}}
{{- define "web.name" -}}
{{ printf "web"}}
{{- end -}}

{{/*
The docker image to use
*/}}
{{- define "docker.app.image" -}}
{{ .Values.registry }}:{{ .Values.tag }}
{{- end -}}

{{/*
  The ingress name
*/}}
{{- define "nginx-ingress.name" -}}
{{ printf "%s-nginx-ingress" .Values.namespace }}
{{- end -}}
