{{/*
Expand the name of the chart.
*/}}
{{- define "skupper-rabbitmq-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "skupper-rabbitmq-chart.fullname" -}}
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
{{- define "skupper-rabbitmq-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "skupper-rabbitmq-chart.labels" -}}
helm.sh/chart: {{ include "skupper-rabbitmq-chart.chart" . }}
{{ include "skupper-rabbitmq-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "skupper-rabbitmq-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "skupper-rabbitmq-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "skupper-rabbitmq-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "skupper-rabbitmq-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Cluster name selection
*/}}
{{- define "skupper-rabbitmq-cluster.name" -}}
{{- $cluster1svc := printf "%s-%s-%s" "skupper-rabbit" .Values.site1 "0" -}}
{{- $clustersvc := lookup "v1" "Service" .Release.Namespace $cluster1svc -}}
{{- if $clustersvc }}
{{- .Values.site2 -}}
{{- else -}}
{{- .Values.site1 -}}
{{- end }}
{{- end }}