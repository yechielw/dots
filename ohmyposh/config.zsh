{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "final_space": true,
  "version": 3,
  "blocks": [
    {
      "alignment": "left",
      "type": "prompt",
      "segments": [
        {
          "foreground": "p:green",
          "style": "plain",
          "template": "[ ",
          "type": "text"
        },
        {
          "foreground": "#43CCEA",
          "foreground_templates": [
            "{{ if or (.Working.Changed) (.Staging.Changed) }}#FF9248{{ end }}",
            "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#ff4500{{ end }}",
            "{{ if gt .Ahead 0 }}#B388FF{{ end }}",
            "{{ if gt .Behind 0 }}#B388FF{{ end }}"
          ],
          "style": "plain",
          "template": "{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }} ",
          "type": "git",
          "properties": {
            "branch_max_length": 25,
            "fetch_stash_count": true,
            "fetch_status": true,
            "fetch_upstream_icon": true
          }
        },
        {
          "style": "plain",
          "template": "({{ if .Error }}{{ .Error }}{{ else }}{{ if .Venv }}{{ .Venv }}{{ end }}{{ end }}) ",
          "type": "python"
        },
        {
          "foreground": "p:green",
          "style": "plain",
          "template": "{{if .Env.SSH_TTY }}{{.UserName}}@{{.HostName }}{{end}} ",
          "type": "text"
        },
        {
          "foreground": "",
          "style": "plain",
          "template": "{{.PWD}}",
          "type": "text"
        },
        {
          "foreground": "#ff0000",
          "style": "plain",
          "template": "{{if gt .Code 0}} {{.Code}}{{end}}",
          "type": "text"
        },
        {
          "foreground": "#AEA4BF",
          "style": "plain",
          "template": " {{ .FormattedMs }}",
          "type": "executiontime",
          "properties": {
            "threshold": 150
          }
        },
        {
          "foreground": "p:green",
          "style": "plain",
          "template": " ]",
          "type": "text"
        },
        {
          "foreground_templates": [
            "{{if .Root }}#FF0000{{else}}#559955{{end}}"
          ],
          "style": "plain",
          "template": "{{if .Root}}#{{else}}${{end}}",
          "type": "text"
        }
      ]
    }
  ]
}
