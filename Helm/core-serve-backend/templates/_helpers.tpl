
{{- define "core-serve-backend.labels" -}}
app: {{ .Values.app.name }}
type: {{ .Values.app.type }}
{{- end -}}


{{- define "core-serve-backend.selectorLabels" -}}
app: {{ .Values.app.name }}
type: {{ .Values.app.type }}
{{- end -}}