
{{- define "core-serve-frontend.labels" -}}
app: {{ .Values.app.name }}
type: {{ .Values.app.type }}
{{- end -}}


{{- define "core-serve-frontend.selectorLabels" -}}
app: {{ .Values.app.name }}
type: {{ .Values.app.type }}
{{- end -}}