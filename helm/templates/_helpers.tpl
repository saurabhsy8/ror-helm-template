{{/*
Expand the name of the chart.
*/}}
{{- define "ror-helm-template.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ror-helm-template.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ror-helm-template.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ror-helm-template.labels" -}}
helm.sh/chart: {{ include "ror-helm-template.chart" . }}
{{ include "ror-helm-template.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ror-helm-template.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ror-helm-template.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ror-helm-template.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ror-helm-template.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



{{- define "ror-helm-template.database_url" -}}
{{- with .global.postgresql.auth -}}
{{ printf "postgresql://%s:%s@%s/%s" .username .password $.app.postgres_host .postgresqlDatabase}}
{{- end }}
{{- end }}

{{- define "ror-helm-template.redis_url" -}}
{{ printf "redis://:%s@%s" .global.redis.password .app.redis_host }}
{{- end }}