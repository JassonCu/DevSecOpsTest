{{- define "devsecops-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "devsecops-app.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "devsecops-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
