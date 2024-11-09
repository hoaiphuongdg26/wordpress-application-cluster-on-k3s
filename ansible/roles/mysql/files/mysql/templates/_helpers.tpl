{{- define "mysql.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mysql.labels" -}}
app: {{ include "mysql.fullname" . }}
app.kubernetes.io/name: {{ include "mysql.fullname" . }}
{{- end -}}