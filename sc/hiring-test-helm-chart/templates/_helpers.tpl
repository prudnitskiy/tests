{{/*
Expand the name of the chart.
*/}}
{{- define "hiring-test-helm-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hiring-test-helm-chart.fullname" -}}
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
{{- define "hiring-test-helm-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hiring-test-helm-chart.labels" -}}
helm.sh/chart: {{ include "hiring-test-helm-chart.chart" . }}
{{ include "hiring-test-helm-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: "webapp"
app.kubernetes.io/part-of: "hiring-test-app"
app.kubernetes.io/created-by: {{ default "external" .Values.maintainer | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hiring-test-helm-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hiring-test-helm-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hiring-test-helm-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hiring-test-helm-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define shared env vars
*/}}
{{- define "hiring-test-helm-chart.envVars" -}}
- name: DATABASE_NAME
  value: {{ .Values.postgresql.auth.database }}
- name: DATABASE_USER
  value: "{{ .Values.postgresql.auth.username }}"
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.postgresql.auth.existingSecret }}"
      key: "password"
- name: DATABASE_HOST
  value: {{ .Release.Name }}-postgresql
- name: DATABASE_PORT
  value: "5432"
- name: SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "hiring-test-helm-chart.fullname" . }}
      key: secret-key
- name: DEBUG
  value: {{ default "INFO" .Values.application.debug }}
{{- end }}
