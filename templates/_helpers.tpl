{{/*
Expand the name of the chart.
*/}}
{{- define "psb1-helm-base-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "psb1-helm-base-chart.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "psb1-helm-base-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "psb1-helm-base-chart.labels" -}}
{{- $ := index . 0 -}}
{{- $containerName := index . 1 -}}
helm.sh/chart: {{ include "psb1-helm-base-chart.chart" $ }}
app.kubernetes.io/name: {{ $containerName }}
app.kubernetes.io/instance: {{ $.Release.Name }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
{{- with $.Values.global.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "psb1-helm-base-chart.selectorLabels" -}}
{{- $ := index . 0 -}}
{{- $containerName := index . 1 -}}
app.kubernetes.io/name: {{ $containerName }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "psb1-helm-base-chart.serviceAccountName" -}}
{{- $name := .Release.Name }}
{{- default $name .Values.serviceAccount.name }}
{{- end }}