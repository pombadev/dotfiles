#!/usr/bin/env bash

# icon credits goes to: https://github.com/eonpatapon/gnome-shell-extension-caffeine
# cspell: disable-line
onIcon="PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhLS0gQ3JlYXRlZCB3aXRoIElua3NjYXBlIChodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy8pIC0tPgo8c3ZnIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6Y2M9Imh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL25zIyIgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIiB4bWxuczpzdmc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB4bWxuczpzb2RpcG9kaT0iaHR0cDovL3NvZGlwb2RpLnNvdXJjZWZvcmdlLm5ldC9EVEQvc29kaXBvZGktMC5kdGQiIHhtbG5zOmlua3NjYXBlPSJodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy9uYW1lc3BhY2VzL2lua3NjYXBlIiBzb2RpcG9kaTpkb2NuYW1lPSJjYWZmZWluZS1vbi1zeW1ib2xpYy5zdmciIGhlaWdodD0iMTYiIGlkPSJzdmc3Mzg0IiBpbmtzY2FwZTp2ZXJzaW9uPSIwLjQ4LjMuMSByOTg4NiIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMTYiPgogIDxtZXRhZGF0YSBpZD0ibWV0YWRhdGE5MCI+CiAgICA8cmRmOlJERj4KICAgICAgPGNjOldvcmsgcmRmOmFib3V0PSIiPgogICAgICAgIDxkYzpmb3JtYXQ+aW1hZ2Uvc3ZnK3htbDwvZGM6Zm9ybWF0PgogICAgICAgIDxkYzp0eXBlIHJkZjpyZXNvdXJjZT0iaHR0cDovL3B1cmwub3JnL2RjL2RjbWl0eXBlL1N0aWxsSW1hZ2UiLz4KICAgICAgICA8ZGM6dGl0bGU+R25vbWUgU3ltYm9saWMgSWNvbiBUaGVtZTwvZGM6dGl0bGU+CiAgICAgIDwvY2M6V29yaz4KICAgIDwvcmRmOlJERj4KICA8L21ldGFkYXRhPgogIDxzb2RpcG9kaTpuYW1lZHZpZXcgaW5rc2NhcGU6YmJveC1wYXRocz0iZmFsc2UiIGJvcmRlcmNvbG9yPSIjNjY2NjY2IiBib3JkZXJvcGFjaXR5PSIxIiBpbmtzY2FwZTpjdXJyZW50LWxheWVyPSJsYXllcjExIiBpbmtzY2FwZTpjeD0iNi4wNzYwOTY1IiBpbmtzY2FwZTpjeT0iNi4zMzM0MjciIGdyaWR0b2xlcmFuY2U9IjEwIiBpbmtzY2FwZTpndWlkZS1iYm94PSJ0cnVlIiBndWlkZXRvbGVyYW5jZT0iMTAiIGlkPSJuYW1lZHZpZXc4OCIgaW5rc2NhcGU6b2JqZWN0LW5vZGVzPSJmYWxzZSIgaW5rc2NhcGU6b2JqZWN0LXBhdGhzPSJmYWxzZSIgb2JqZWN0dG9sZXJhbmNlPSIxMCIgcGFnZWNvbG9yPSIjNTU1NzUzIiBpbmtzY2FwZTpwYWdlb3BhY2l0eT0iMSIgaW5rc2NhcGU6cGFnZXNoYWRvdz0iMiIgc2hvd2JvcmRlcj0iZmFsc2UiIHNob3dncmlkPSJ0cnVlIiBzaG93Z3VpZGVzPSJ0cnVlIiBpbmtzY2FwZTpzbmFwLWJib3g9InRydWUiIGlua3NjYXBlOnNuYXAtYmJveC1taWRwb2ludHM9ImZhbHNlIiBpbmtzY2FwZTpzbmFwLWdsb2JhbD0idHJ1ZSIgaW5rc2NhcGU6c25hcC1ncmlkcz0idHJ1ZSIgaW5rc2NhcGU6c25hcC1ub2Rlcz0iZmFsc2UiIGlua3NjYXBlOnNuYXAtb3RoZXJzPSJmYWxzZSIgaW5rc2NhcGU6c25hcC10by1ndWlkZXM9InRydWUiIGlua3NjYXBlOndpbmRvdy1oZWlnaHQ9Ijc0MSIgaW5rc2NhcGU6d2luZG93LW1heGltaXplZD0iMSIgaW5rc2NhcGU6d2luZG93LXdpZHRoPSIxMzY2IiBpbmtzY2FwZTp3aW5kb3cteD0iMCIgaW5rc2NhcGU6d2luZG93LXk9Ii0zIiBpbmtzY2FwZTp6b29tPSIzMiI+CiAgICA8aW5rc2NhcGU6Z3JpZCBlbXBzcGFjaW5nPSIyIiBlbmFibGVkPSJ0cnVlIiBpZD0iZ3JpZDQ4NjYiIG9yaWdpbng9Ii00Mi4wMDAwMDlweCIgb3JpZ2lueT0iNDEycHgiIHNuYXB2aXNpYmxlZ3JpZGxpbmVzb25seT0idHJ1ZSIgc3BhY2luZ3g9IjFweCIgc3BhY2luZ3k9IjFweCIgdHlwZT0ieHlncmlkIiB2aXNpYmxlPSJ0cnVlIi8+CiAgICA8c29kaXBvZGk6Z3VpZGUgb3JpZW50YXRpb249IjAsMSIgcG9zaXRpb249IjMuNDY5MjQyNiw5LjQzNTQ1NjEiIGlkPSJndWlkZTQwMjkiLz4KICA8L3NvZGlwb2RpOm5hbWVkdmlldz4KICA8dGl0bGUgaWQ9InRpdGxlOTE2NyI+R25vbWUgU3ltYm9saWMgSWNvbiBUaGVtZTwvdGl0bGU+CiAgPGRlZnMgaWQ9ImRlZnM3Mzg2Ii8+CiAgPGcgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIgaWQ9ImxheWVyOSIgaW5rc2NhcGU6bGFiZWw9InN0YXR1cyIgc3R5bGU9ImRpc3BsYXk6aW5saW5lIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjgzLjAwMDIxLC02MjkpIi8+CiAgPGcgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIgaWQ9ImxheWVyMTAiIGlua3NjYXBlOmxhYmVsPSJkZXZpY2VzIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjgzLjAwMDIxLC02MjkpIi8+CiAgPGcgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIgaWQ9ImxheWVyMTEiIGlua3NjYXBlOmxhYmVsPSJhcHBzIiBzdHlsZT0iZGlzcGxheTppbmxpbmUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yODMuMDAwMjEsLTYyOSkiPgogICAgPHBhdGggaW5rc2NhcGU6Y29ubmVjdG9yLWN1cnZhdHVyZT0iMCIgZD0ibSAyODMuMTI0NzYsNjM0LjM5NzE1IGMgMC4wOTAxLDIuMzk5ODIgLTIuNWUtNCw0LjkwMDk2IDAuOTA1MzYsNy4xNjI0MiAwLjU2NTYxLDEuNDUxNSAxLjgzMzg1LDIuNTU0MzEgMy4zMDc5NCwyLjkwNTg5IDEuNzM4MTQsMC40MTExNCAzLjY0Mzc2LDAuNDA0MTIgNS4yOTY4OCwtMC4zNDYyMyAxLjYwMzEyLC0wLjcyNjA4IDIuNTc5NTMsLTIuMzk0MzkgMi45ODQwMiwtNC4wOTMxNSAwLjQ4NzY2LC0xLjk3OTE1IDAuNTQ5OTksLTQuMDM4NjIgMC41OTc4NSwtNi4wNjg5NyAtMC4xODAxMSwtMS4xNTUyMyAtMS4yNTg0NCwtMS44NDczMSAtMi4yMDU1NSwtMi4zMDA5IC0yLjMwMDg0LC0xLjAxNzcyIC00LjkxMDM1LC0xLjA5ODUxIC03LjM0MzA5LC0wLjYwOTYxIC0xLjI5OTc0LDAuMzAwOTUgLTIuNzc3ODEsMC44NjE2OSAtMy4zNjY2MSwyLjIwNTMxIC0wLjE0ODUsMC4zNTk1NSAtMC4yMDM1NCwwLjc1NjMxIC0wLjE3NjgsMS4xNDUyNCB6IG0gMTEuNjM3NCwwLjExMTM2IGMgLTAuMDQ0MSwwLjkxMTI2IC0wLjk2NTA1LDEuMzU1NjUgLTEuNjg4NzIsMS42MjY4IC0xLjk5ODQ4LDAuNjYwNzMgLTQuMTc2MTIsMC42ODk3OCAtNi4yMjAyMiwwLjI0MTY4IC0wLjg3NDU2LC0wLjI0MDE4IC0xLjkxMTQsLTAuNTYxODIgLTIuMzIzMzIsLTEuNDc5NDMgLTAuMjkwOTYsLTAuODY4OTcgMC40NjA1MSwtMS42MjIxMiAxLjE4NTc0LC0xLjkxMjI4IDEuNjMyODgsLTAuNjc5MzYgMy40NDc5NCwtMC43MDIyNiA1LjE3OTYzLC0wLjU2NTY1IDEuMTkxMzMsMC4xNTA4MiAyLjQ3Nzg3LDAuMzU1OTggMy40Mjk1NCwxLjE3MzU3IDAuMjQ5NTQsMC4yMzI5NCAwLjQ0MTgsMC41NTg1NCAwLjQzNzM1LDAuOTE1MzEgeiIgaWQ9InBhdGgyNDgzOS03LTAtOCIgc3R5bGU9ImZvbnQtc2l6ZTptZWRpdW07Zm9udC1zdHlsZTpub3JtYWw7Zm9udC12YXJpYW50Om5vcm1hbDtmb250LXdlaWdodDpub3JtYWw7Zm9udC1zdHJldGNoOm5vcm1hbDt0ZXh0LWluZGVudDowO3RleHQtYWxpZ246c3RhcnQ7dGV4dC1kZWNvcmF0aW9uOm5vbmU7bGluZS1oZWlnaHQ6bm9ybWFsO2xldHRlci1zcGFjaW5nOm5vcm1hbDt3b3JkLXNwYWNpbmc6bm9ybWFsO3RleHQtdHJhbnNmb3JtOm5vbmU7ZGlyZWN0aW9uOmx0cjtibG9jay1wcm9ncmVzc2lvbjp0Yjt3cml0aW5nLW1vZGU6bHItdGI7dGV4dC1hbmNob3I6c3RhcnQ7YmFzZWxpbmUtc2hpZnQ6YmFzZWxpbmU7Y29sb3I6IzAwMDAwMDtmaWxsOiNiZWJlYmU7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmU7c3Ryb2tlLXdpZHRoOjIuMTUzNDUzNTk7bWFya2VyOm5vbmU7dmlzaWJpbGl0eTp2aXNpYmxlO2Rpc3BsYXk6aW5saW5lO292ZXJmbG93OnZpc2libGU7ZW5hYmxlLWJhY2tncm91bmQ6bmV3O2ZvbnQtZmFtaWx5OlNhbnM7LWlua3NjYXBlLWZvbnQtc3BlY2lmaWNhdGlvbjpTYW5zIi8+CiAgICA8cGF0aCBzdHlsZT0iZm9udC1zaXplOm1lZGl1bTtmb250LXN0eWxlOm5vcm1hbDtmb250LXZhcmlhbnQ6bm9ybWFsO2ZvbnQtd2VpZ2h0Om5vcm1hbDtmb250LXN0cmV0Y2g6bm9ybWFsO3RleHQtaW5kZW50OjA7dGV4dC1hbGlnbjpzdGFydDt0ZXh0LWRlY29yYXRpb246bm9uZTtsaW5lLWhlaWdodDpub3JtYWw7bGV0dGVyLXNwYWNpbmc6bm9ybWFsO3dvcmQtc3BhY2luZzpub3JtYWw7dGV4dC10cmFuc2Zvcm06bm9uZTtkaXJlY3Rpb246bHRyO2Jsb2NrLXByb2dyZXNzaW9uOnRiO3dyaXRpbmctbW9kZTpsci10Yjt0ZXh0LWFuY2hvcjpzdGFydDtiYXNlbGluZS1zaGlmdDpiYXNlbGluZTtjb2xvcjojMDAwMDAwO2ZpbGw6I2JlYmViZTtmaWxsLW9wYWNpdHk6MTtzdHJva2U6bm9uZTtzdHJva2Utd2lkdGg6MS42NDQ5OTk5ODttYXJrZXI6bm9uZTt2aXNpYmlsaXR5OnZpc2libGU7ZGlzcGxheTppbmxpbmU7b3ZlcmZsb3c6dmlzaWJsZTtlbmFibGUtYmFja2dyb3VuZDphY2N1bXVsYXRlO2ZvbnQtZmFtaWx5OlNhbnM7LWlua3NjYXBlLWZvbnQtc3BlY2lmaWNhdGlvbjpTYW5zIiBkPSJtIDI5Ni4wMTgzMSw2MzQuMjk4NjkgYyAtMC40MjI0NiwwLjEwNTggLTAuODE1NTcsMC4yOTg0MyAtMS4yMDU4MSwwLjQ4NzA2IDAuMjUsMC40ODk1OCAwLjUsMC45NzkxNyAwLjc1LDEuNDY4NzUgMC41Mjk1MywtMC4yNjA3OSAxLjA3OTI1LC0wLjQ4OTQ4IDEuNjU2MjEsLTAuNjIxMzYgMC4xOTU5OCwwLjI5MDM0IDAuMDYxMywwLjY1NTU5IDAuMDk2NSwwLjk4MDAxIC0wLjAyNjUsMC43NjUzNSAtMC4wODkxLDEuNTMzMzIgLTAuMjYxOCwyLjI4MSAtMC4xOTc5NiwwLjI0NjYxIC0wLjUwMzExLDAuMDIxMSAtMC43MTQxMSwtMC4wODY0IC0wLjMwOTMyLC0wLjA3MjEgLTAuNTM3MjksLTAuMzExMTcgLTAuODMwMjQsLTAuNDEyODYgLTAuMTI1MDMsLTAuMDA4IC0wLjE0NDM4LDAuMTU5NTEgLTAuMjE3LDAuMjM3MjcgLTAuMjMyNzgsMC4zNzQxMSAtMC40NjU1NywwLjc0ODIzIC0wLjY5ODM1LDEuMTIyMzUgMC44MTU2NSwwLjQ5ODY2IDEuNzIyMjUsMC45OTM4MSAyLjcwOTg0LDAuOTMwMDUgMC41OTg5NCwtMC4wNjE1IDEuMTQwNzQsLTAuNTE4NjUgMS4yNTkyNiwtMS4xMTYzOSAwLjE4NjcxLC0wLjY2NTcxIDAuMjc2MTUsLTEuMzU0OTUgMC4zNTg5OSwtMi4wMzk4OSAwLjA3MTUsLTAuODIxMjEgMC4wOTgzLC0xLjY3MjE4IC0wLjE0OTEsLTIuNDY3OTIgLTAuMTU5MzIsLTAuNDgzMDkgLTAuNTM5MSwtMC45NTM1IC0xLjA3ODUsLTAuOTk4NzkgLTAuNTcwNiwtMC4wODI0IC0xLjEyNDQ0LDAuMTI5MTggLTEuNjc1ODgsMC4yMzcxNCB6IiBpZD0icGF0aDYwNDciIGlua3NjYXBlOmNvbm5lY3Rvci1jdXJ2YXR1cmU9IjAiLz4KICA8L2c+CiAgPGcgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIgaWQ9ImxheWVyMSIgaW5rc2NhcGU6bGFiZWw9Im9uIiBzdHlsZT0iZGlzcGxheTppbmxpbmUiPgogICAgPHBhdGggaWQ9InBhdGg0MTE0IiBzdHlsZT0iZmlsbDpub25lO3N0cm9rZTojZmZmZmZmO3N0cm9rZS13aWR0aDoxLjI5OTk5OTk1O3N0cm9rZS1saW5lY2FwOmJ1dHQ7c3Ryb2tlLWxpbmVqb2luOm1pdGVyO3N0cm9rZS1taXRlcmxpbWl0OjQ7c3Ryb2tlLW9wYWNpdHk6MTtzdHJva2UtZGFzaGFycmF5Om5vbmU7ZGlzcGxheTppbmxpbmUiIGQ9Im0gNC4yNjI1NTM0LDYuMTc1MDI5MyBjIDAsMCAxLjE0OTE1ODcsLTAuNjI3ODkwMyAxLjE4NjM4OTcsLTEuNjYwNjkxOCBDIDUuNDg2MTMzMSwzLjQ4MjY2MzcgNC40NjAzMDI1LDIuOTc2OTk1IDQuNDY3MjQ4NSwyLjAzMTcyMzUgNC40NzM2NDg1LDEuMTUzOTg2MiA1LjYzMzc2MjQsMC4yODMyOTM4OCA1LjYzMzc2MjQsMC4yODMyOTM4OCIgaW5rc2NhcGU6Y29ubmVjdG9yLWN1cnZhdHVyZT0iMCIgc29kaXBvZGk6bm9kZXR5cGVzPSJjc2NjIi8+CiAgICA8dXNlIHg9IjAiIHk9IjAiIHhsaW5rOmhyZWY9IiNwYXRoNDExNCIgaWQ9InVzZTQxMTgiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDMuMzI1ODI1OSwwKSIgd2lkdGg9IjE2IiBoZWlnaHQ9IjE2Ii8+CiAgPC9nPgogIDxnIGlua3NjYXBlOmdyb3VwbW9kZT0ibGF5ZXIiIGlkPSJsYXllcjIiIGlua3NjYXBlOmxhYmVsPSJvZmYiIHN0eWxlPSJkaXNwbGF5Om5vbmUiPgogICAgPHBhdGggaW5rc2NhcGU6Y29ubmVjdG9yLWN1cnZhdHVyZT0iMCIgZD0ibSA2LjU1NTE3NCwzLjY2ODk2MjEgYyAtMS45Nzg2NSwtMC4wMDQgLTQuNzQ5MTcsMC41OTQ0OCAtNC4zNjg5MywxLjkyOTkgMC4yNzg1MywwLjk3ODIgMi43NDY4LDEuMzcxMTIgNC4yODIyLDEuMzQwNTcgMi4zOTA5MywtMC4wNDc2IDMuOTk1NjQsLTAuMTUxODYgNC40OTkzNiwtMS4xNjU4OSAwLjY2ODQ1LC0xLjM0NTYzIC0yLjMyNDExLC0yLjEwMDc1IC00LjQxMjYzLC0yLjEwNDU4IHoiIGlkPSJwYXRoNjMwOSIgc3R5bGU9ImZvbnQtc2l6ZTptZWRpdW07Zm9udC1zdHlsZTpub3JtYWw7Zm9udC12YXJpYW50Om5vcm1hbDtmb250LXdlaWdodDpub3JtYWw7Zm9udC1zdHJldGNoOm5vcm1hbDt0ZXh0LWluZGVudDowO3RleHQtYWxpZ246c3RhcnQ7dGV4dC1kZWNvcmF0aW9uOm5vbmU7bGluZS1oZWlnaHQ6bm9ybWFsO2xldHRlci1zcGFjaW5nOm5vcm1hbDt3b3JkLXNwYWNpbmc6bm9ybWFsO3RleHQtdHJhbnNmb3JtOm5vbmU7ZGlyZWN0aW9uOmx0cjtibG9jay1wcm9ncmVzc2lvbjp0Yjt3cml0aW5nLW1vZGU6bHItdGI7dGV4dC1hbmNob3I6c3RhcnQ7YmFzZWxpbmUtc2hpZnQ6YmFzZWxpbmU7Y29sb3I6IzAwMDAwMDtmaWxsOiNiZWJlYmU7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmU7c3Ryb2tlLXdpZHRoOjEuNzAwMDAwMDU7bWFya2VyOm5vbmU7dmlzaWJpbGl0eTp2aXNpYmxlO2Rpc3BsYXk6aW5saW5lO292ZXJmbG93OnZpc2libGU7ZW5hYmxlLWJhY2tncm91bmQ6YWNjdW11bGF0ZTtmb250LWZhbWlseTpTYW5zOy1pbmtzY2FwZS1mb250LXNwZWNpZmljYXRpb246U2FucyIgc29kaXBvZGk6bm9kZXR5cGVzPSJzc3NzcyIvPgogIDwvZz4KICA8ZyBpbmtzY2FwZTpncm91cG1vZGU9ImxheWVyIiBpZD0ibGF5ZXIxMyIgaW5rc2NhcGU6bGFiZWw9InBsYWNlcyIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTI4My4wMDAyMSwtNjI5KSIvPgogIDxnIGlua3NjYXBlOmdyb3VwbW9kZT0ibGF5ZXIiIGlkPSJsYXllcjE0IiBpbmtzY2FwZTpsYWJlbD0ibWltZXR5cGVzIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjgzLjAwMDIxLC02MjkpIi8+CiAgPGcgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIgaWQ9ImxheWVyMTUiIGlua3NjYXBlOmxhYmVsPSJlbWJsZW1zIiBzdHlsZT0iZGlzcGxheTppbmxpbmUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yODMuMDAwMjEsLTYyOSkiLz4KICA8ZyBpbmtzY2FwZTpncm91cG1vZGU9ImxheWVyIiBpZD0iZzcxMjkxIiBpbmtzY2FwZTpsYWJlbD0iZW1vdGVzIiBzdHlsZT0iZGlzcGxheTppbmxpbmUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yODMuMDAwMjEsLTYyOSkiLz4KICA8ZyBpbmtzY2FwZTpncm91cG1vZGU9ImxheWVyIiBpZD0iZzQ5NTMiIGlua3NjYXBlOmxhYmVsPSJjYXRlZ29yaWVzIiBzdHlsZT0iZGlzcGxheTppbmxpbmUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yODMuMDAwMjEsLTYyOSkiLz4KICA8ZyBpbmtzY2FwZTpncm91cG1vZGU9ImxheWVyIiBpZD0ibGF5ZXIxMiIgaW5rc2NhcGU6bGFiZWw9ImFjdGlvbnMiIHN0eWxlPSJkaXNwbGF5OmlubGluZSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTI4My4wMDAyMSwtNjI5KSIvPgo8L3N2Zz4="
# cspell: disable-line
offIcon="PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhLS0gQ3JlYXRlZCB3aXRoIElua3NjYXBlIChodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy8pIC0tPgo8c3ZnIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6Y2M9Imh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL25zIyIgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIiB4bWxuczpzdmc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB4bWxuczpzb2RpcG9kaT0iaHR0cDovL3NvZGlwb2RpLnNvdXJjZWZvcmdlLm5ldC9EVEQvc29kaXBvZGktMC5kdGQiIHhtbG5zOmlua3NjYXBlPSJodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy9uYW1lc3BhY2VzL2lua3NjYXBlIiBzb2RpcG9kaTpkb2NuYW1lPSJjYWZmZWluZS1vbi1zeW1ib2xpYy5zdmciIGhlaWdodD0iMTYiIGlkPSJzdmc3Mzg0IiBpbmtzY2FwZTp2ZXJzaW9uPSIwLjQ4LjMuMSByOTg4NiIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMTYiPgogIDxtZXRhZGF0YSBpZD0ibWV0YWRhdGE5MCI+CiAgICA8cmRmOlJERj4KICAgICAgPGNjOldvcmsgcmRmOmFib3V0PSIiPgogICAgICAgIDxkYzpmb3JtYXQ+aW1hZ2Uvc3ZnK3htbDwvZGM6Zm9ybWF0PgogICAgICAgIDxkYzp0eXBlIHJkZjpyZXNvdXJjZT0iaHR0cDovL3B1cmwub3JnL2RjL2RjbWl0eXBlL1N0aWxsSW1hZ2UiLz4KICAgICAgICA8ZGM6dGl0bGU+R25vbWUgU3ltYm9saWMgSWNvbiBUaGVtZTwvZGM6dGl0bGU+CiAgICAgIDwvY2M6V29yaz4KICAgIDwvcmRmOlJERj4KICA8L21ldGFkYXRhPgogIDxzb2RpcG9kaTpuYW1lZHZpZXcgaW5rc2NhcGU6YmJveC1wYXRocz0iZmFsc2UiIGJvcmRlcmNvbG9yPSIjNjY2NjY2IiBib3JkZXJvcGFjaXR5PSIxIiBpbmtzY2FwZTpjdXJyZW50LWxheWVyPSJsYXllcjExIiBpbmtzY2FwZTpjeD0iNi4wNzYwOTY1IiBpbmtzY2FwZTpjeT0iNi4zMzM0MjciIGdyaWR0b2xlcmFuY2U9IjEwIiBpbmtzY2FwZTpndWlkZS1iYm94PSJ0cnVlIiBndWlkZXRvbGVyYW5jZT0iMTAiIGlkPSJuYW1lZHZpZXc4OCIgaW5rc2NhcGU6b2JqZWN0LW5vZGVzPSJmYWxzZSIgaW5rc2NhcGU6b2JqZWN0LXBhdGhzPSJmYWxzZSIgb2JqZWN0dG9sZXJhbmNlPSIxMCIgcGFnZWNvbG9yPSIjNTU1NzUzIiBpbmtzY2FwZTpwYWdlb3BhY2l0eT0iMSIgaW5rc2NhcGU6cGFnZXNoYWRvdz0iMiIgc2hvd2JvcmRlcj0iZmFsc2UiIHNob3dncmlkPSJ0cnVlIiBzaG93Z3VpZGVzPSJ0cnVlIiBpbmtzY2FwZTpzbmFwLWJib3g9InRydWUiIGlua3NjYXBlOnNuYXAtYmJveC1taWRwb2ludHM9ImZhbHNlIiBpbmtzY2FwZTpzbmFwLWdsb2JhbD0idHJ1ZSIgaW5rc2NhcGU6c25hcC1ncmlkcz0idHJ1ZSIgaW5rc2NhcGU6c25hcC1ub2Rlcz0iZmFsc2UiIGlua3NjYXBlOnNuYXAtb3RoZXJzPSJmYWxzZSIgaW5rc2NhcGU6c25hcC10by1ndWlkZXM9InRydWUiIGlua3NjYXBlOndpbmRvdy1oZWlnaHQ9Ijc0MSIgaW5rc2NhcGU6d2luZG93LW1heGltaXplZD0iMSIgaW5rc2NhcGU6d2luZG93LXdpZHRoPSIxMzY2IiBpbmtzY2FwZTp3aW5kb3cteD0iMCIgaW5rc2NhcGU6d2luZG93LXk9Ii0zIiBpbmtzY2FwZTp6b29tPSIzMiI+CiAgICA8aW5rc2NhcGU6Z3JpZCBlbXBzcGFjaW5nPSIyIiBlbmFibGVkPSJ0cnVlIiBpZD0iZ3JpZDQ4NjYiIG9yaWdpbng9Ii00Mi4wMDAwMDlweCIgb3JpZ2lueT0iNDEycHgiIHNuYXB2aXNpYmxlZ3JpZGxpbmVzb25seT0idHJ1ZSIgc3BhY2luZ3g9IjFweCIgc3BhY2luZ3k9IjFweCIgdHlwZT0ieHlncmlkIiB2aXNpYmxlPSJ0cnVlIi8+CiAgICA8c29kaXBvZGk6Z3VpZGUgb3JpZW50YXRpb249IjAsMSIgcG9zaXRpb249IjMuNDY5MjQyNiw5LjQzNTQ1NjEiIGlkPSJndWlkZTQwMjkiLz4KICA8L3NvZGlwb2RpOm5hbWVkdmlldz4KICA8dGl0bGUgaWQ9InRpdGxlOTE2NyI+R25vbWUgU3ltYm9saWMgSWNvbiBUaGVtZTwvdGl0bGU+CiAgPGRlZnMgaWQ9ImRlZnM3Mzg2Ii8+CiAgPGcgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIgaWQ9ImxheWVyOSIgaW5rc2NhcGU6bGFiZWw9InN0YXR1cyIgc3R5bGU9ImRpc3BsYXk6aW5saW5lIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjgzLjAwMDIxLC02MjkpIi8+CiAgPGcgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIgaWQ9ImxheWVyMTAiIGlua3NjYXBlOmxhYmVsPSJkZXZpY2VzIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjgzLjAwMDIxLC02MjkpIi8+CiAgPGcgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIgaWQ9ImxheWVyMTEiIGlua3NjYXBlOmxhYmVsPSJhcHBzIiBzdHlsZT0iZGlzcGxheTppbmxpbmUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yODMuMDAwMjEsLTYyOSkiPgogICAgPHBhdGggaW5rc2NhcGU6Y29ubmVjdG9yLWN1cnZhdHVyZT0iMCIgZD0ibSAyODMuMTI0NzYsNjM0LjM5NzE1IGMgMC4wOTAxLDIuMzk5ODIgLTIuNWUtNCw0LjkwMDk2IDAuOTA1MzYsNy4xNjI0MiAwLjU2NTYxLDEuNDUxNSAxLjgzMzg1LDIuNTU0MzEgMy4zMDc5NCwyLjkwNTg5IDEuNzM4MTQsMC40MTExNCAzLjY0Mzc2LDAuNDA0MTIgNS4yOTY4OCwtMC4zNDYyMyAxLjYwMzEyLC0wLjcyNjA4IDIuNTc5NTMsLTIuMzk0MzkgMi45ODQwMiwtNC4wOTMxNSAwLjQ4NzY2LC0xLjk3OTE1IDAuNTQ5OTksLTQuMDM4NjIgMC41OTc4NSwtNi4wNjg5NyAtMC4xODAxMSwtMS4xNTUyMyAtMS4yNTg0NCwtMS44NDczMSAtMi4yMDU1NSwtMi4zMDA5IC0yLjMwMDg0LC0xLjAxNzcyIC00LjkxMDM1LC0xLjA5ODUxIC03LjM0MzA5LC0wLjYwOTYxIC0xLjI5OTc0LDAuMzAwOTUgLTIuNzc3ODEsMC44NjE2OSAtMy4zNjY2MSwyLjIwNTMxIC0wLjE0ODUsMC4zNTk1NSAtMC4yMDM1NCwwLjc1NjMxIC0wLjE3NjgsMS4xNDUyNCB6IG0gMTEuNjM3NCwwLjExMTM2IGMgLTAuMDQ0MSwwLjkxMTI2IC0wLjk2NTA1LDEuMzU1NjUgLTEuNjg4NzIsMS42MjY4IC0xLjk5ODQ4LDAuNjYwNzMgLTQuMTc2MTIsMC42ODk3OCAtNi4yMjAyMiwwLjI0MTY4IC0wLjg3NDU2LC0wLjI0MDE4IC0xLjkxMTQsLTAuNTYxODIgLTIuMzIzMzIsLTEuNDc5NDMgLTAuMjkwOTYsLTAuODY4OTcgMC40NjA1MSwtMS42MjIxMiAxLjE4NTc0LC0xLjkxMjI4IDEuNjMyODgsLTAuNjc5MzYgMy40NDc5NCwtMC43MDIyNiA1LjE3OTYzLC0wLjU2NTY1IDEuMTkxMzMsMC4xNTA4MiAyLjQ3Nzg3LDAuMzU1OTggMy40Mjk1NCwxLjE3MzU3IDAuMjQ5NTQsMC4yMzI5NCAwLjQ0MTgsMC41NTg1NCAwLjQzNzM1LDAuOTE1MzEgeiIgaWQ9InBhdGgyNDgzOS03LTAtOCIgc3R5bGU9ImZvbnQtc2l6ZTptZWRpdW07Zm9udC1zdHlsZTpub3JtYWw7Zm9udC12YXJpYW50Om5vcm1hbDtmb250LXdlaWdodDpub3JtYWw7Zm9udC1zdHJldGNoOm5vcm1hbDt0ZXh0LWluZGVudDowO3RleHQtYWxpZ246c3RhcnQ7dGV4dC1kZWNvcmF0aW9uOm5vbmU7bGluZS1oZWlnaHQ6bm9ybWFsO2xldHRlci1zcGFjaW5nOm5vcm1hbDt3b3JkLXNwYWNpbmc6bm9ybWFsO3RleHQtdHJhbnNmb3JtOm5vbmU7ZGlyZWN0aW9uOmx0cjtibG9jay1wcm9ncmVzc2lvbjp0Yjt3cml0aW5nLW1vZGU6bHItdGI7dGV4dC1hbmNob3I6c3RhcnQ7YmFzZWxpbmUtc2hpZnQ6YmFzZWxpbmU7Y29sb3I6IzAwMDAwMDtmaWxsOiNiZWJlYmU7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmU7c3Ryb2tlLXdpZHRoOjIuMTUzNDUzNTk7bWFya2VyOm5vbmU7dmlzaWJpbGl0eTp2aXNpYmxlO2Rpc3BsYXk6aW5saW5lO292ZXJmbG93OnZpc2libGU7ZW5hYmxlLWJhY2tncm91bmQ6bmV3O2ZvbnQtZmFtaWx5OlNhbnM7LWlua3NjYXBlLWZvbnQtc3BlY2lmaWNhdGlvbjpTYW5zIi8+CiAgICA8cGF0aCBzdHlsZT0iZm9udC1zaXplOm1lZGl1bTtmb250LXN0eWxlOm5vcm1hbDtmb250LXZhcmlhbnQ6bm9ybWFsO2ZvbnQtd2VpZ2h0Om5vcm1hbDtmb250LXN0cmV0Y2g6bm9ybWFsO3RleHQtaW5kZW50OjA7dGV4dC1hbGlnbjpzdGFydDt0ZXh0LWRlY29yYXRpb246bm9uZTtsaW5lLWhlaWdodDpub3JtYWw7bGV0dGVyLXNwYWNpbmc6bm9ybWFsO3dvcmQtc3BhY2luZzpub3JtYWw7dGV4dC10cmFuc2Zvcm06bm9uZTtkaXJlY3Rpb246bHRyO2Jsb2NrLXByb2dyZXNzaW9uOnRiO3dyaXRpbmctbW9kZTpsci10Yjt0ZXh0LWFuY2hvcjpzdGFydDtiYXNlbGluZS1zaGlmdDpiYXNlbGluZTtjb2xvcjojMDAwMDAwO2ZpbGw6I2JlYmViZTtmaWxsLW9wYWNpdHk6MTtzdHJva2U6bm9uZTtzdHJva2Utd2lkdGg6MS42NDQ5OTk5ODttYXJrZXI6bm9uZTt2aXNpYmlsaXR5OnZpc2libGU7ZGlzcGxheTppbmxpbmU7b3ZlcmZsb3c6dmlzaWJsZTtlbmFibGUtYmFja2dyb3VuZDphY2N1bXVsYXRlO2ZvbnQtZmFtaWx5OlNhbnM7LWlua3NjYXBlLWZvbnQtc3BlY2lmaWNhdGlvbjpTYW5zIiBkPSJtIDI5Ni4wMTgzMSw2MzQuMjk4NjkgYyAtMC40MjI0NiwwLjEwNTggLTAuODE1NTcsMC4yOTg0MyAtMS4yMDU4MSwwLjQ4NzA2IDAuMjUsMC40ODk1OCAwLjUsMC45NzkxNyAwLjc1LDEuNDY4NzUgMC41Mjk1MywtMC4yNjA3OSAxLjA3OTI1LC0wLjQ4OTQ4IDEuNjU2MjEsLTAuNjIxMzYgMC4xOTU5OCwwLjI5MDM0IDAuMDYxMywwLjY1NTU5IDAuMDk2NSwwLjk4MDAxIC0wLjAyNjUsMC43NjUzNSAtMC4wODkxLDEuNTMzMzIgLTAuMjYxOCwyLjI4MSAtMC4xOTc5NiwwLjI0NjYxIC0wLjUwMzExLDAuMDIxMSAtMC43MTQxMSwtMC4wODY0IC0wLjMwOTMyLC0wLjA3MjEgLTAuNTM3MjksLTAuMzExMTcgLTAuODMwMjQsLTAuNDEyODYgLTAuMTI1MDMsLTAuMDA4IC0wLjE0NDM4LDAuMTU5NTEgLTAuMjE3LDAuMjM3MjcgLTAuMjMyNzgsMC4zNzQxMSAtMC40NjU1NywwLjc0ODIzIC0wLjY5ODM1LDEuMTIyMzUgMC44MTU2NSwwLjQ5ODY2IDEuNzIyMjUsMC45OTM4MSAyLjcwOTg0LDAuOTMwMDUgMC41OTg5NCwtMC4wNjE1IDEuMTQwNzQsLTAuNTE4NjUgMS4yNTkyNiwtMS4xMTYzOSAwLjE4NjcxLC0wLjY2NTcxIDAuMjc2MTUsLTEuMzU0OTUgMC4zNTg5OSwtMi4wMzk4OSAwLjA3MTUsLTAuODIxMjEgMC4wOTgzLC0xLjY3MjE4IC0wLjE0OTEsLTIuNDY3OTIgLTAuMTU5MzIsLTAuNDgzMDkgLTAuNTM5MSwtMC45NTM1IC0xLjA3ODUsLTAuOTk4NzkgLTAuNTcwNiwtMC4wODI0IC0xLjEyNDQ0LDAuMTI5MTggLTEuNjc1ODgsMC4yMzcxNCB6IiBpZD0icGF0aDYwNDciIGlua3NjYXBlOmNvbm5lY3Rvci1jdXJ2YXR1cmU9IjAiLz4KICA8L2c+CiAgPGcgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIgaWQ9ImxheWVyMSIgaW5rc2NhcGU6bGFiZWw9Im9uIiBzdHlsZT0iZGlzcGxheTpub25lIj4KICAgIDxwYXRoIGlkPSJwYXRoNDExNCIgc3R5bGU9ImZpbGw6bm9uZTtzdHJva2U6I2ZmZmZmZjtzdHJva2Utd2lkdGg6MS4yOTk5OTk5NTtzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjptaXRlcjtzdHJva2UtbWl0ZXJsaW1pdDo0O3N0cm9rZS1vcGFjaXR5OjE7c3Ryb2tlLWRhc2hhcnJheTpub25lO2Rpc3BsYXk6aW5saW5lIiBkPSJtIDQuMjYyNTUzNCw2LjE3NTAyOTMgYyAwLDAgMS4xNDkxNTg3LC0wLjYyNzg5MDMgMS4xODYzODk3LC0xLjY2MDY5MTggQyA1LjQ4NjEzMzEsMy40ODI2NjM3IDQuNDYwMzAyNSwyLjk3Njk5NSA0LjQ2NzI0ODUsMi4wMzE3MjM1IDQuNDczNjQ4NSwxLjE1Mzk4NjIgNS42MzM3NjI0LDAuMjgzMjkzODggNS42MzM3NjI0LDAuMjgzMjkzODgiIGlua3NjYXBlOmNvbm5lY3Rvci1jdXJ2YXR1cmU9IjAiIHNvZGlwb2RpOm5vZGV0eXBlcz0iY3NjYyIvPgogICAgPHVzZSB4PSIwIiB5PSIwIiB4bGluazpocmVmPSIjcGF0aDQxMTQiIGlkPSJ1c2U0MTE4IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgzLjMyNTgyNTksMCkiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIvPgogIDwvZz4KICA8ZyBpbmtzY2FwZTpncm91cG1vZGU9ImxheWVyIiBpZD0ibGF5ZXIyIiBpbmtzY2FwZTpsYWJlbD0ib2ZmIiBzdHlsZT0iZGlzcGxheTppbmxpbmUiPgogICAgPHBhdGggaW5rc2NhcGU6Y29ubmVjdG9yLWN1cnZhdHVyZT0iMCIgZD0ibSA2LjU1NTE3NCwzLjY2ODk2MjEgYyAtMS45Nzg2NSwtMC4wMDQgLTQuNzQ5MTcsMC41OTQ0OCAtNC4zNjg5MywxLjkyOTkgMC4yNzg1MywwLjk3ODIgMi43NDY4LDEuMzcxMTIgNC4yODIyLDEuMzQwNTcgMi4zOTA5MywtMC4wNDc2IDMuOTk1NjQsLTAuMTUxODYgNC40OTkzNiwtMS4xNjU4OSAwLjY2ODQ1LC0xLjM0NTYzIC0yLjMyNDExLC0yLjEwMDc1IC00LjQxMjYzLC0yLjEwNDU4IHoiIGlkPSJwYXRoNjMwOSIgc3R5bGU9ImZvbnQtc2l6ZTptZWRpdW07Zm9udC1zdHlsZTpub3JtYWw7Zm9udC12YXJpYW50Om5vcm1hbDtmb250LXdlaWdodDpub3JtYWw7Zm9udC1zdHJldGNoOm5vcm1hbDt0ZXh0LWluZGVudDowO3RleHQtYWxpZ246c3RhcnQ7dGV4dC1kZWNvcmF0aW9uOm5vbmU7bGluZS1oZWlnaHQ6bm9ybWFsO2xldHRlci1zcGFjaW5nOm5vcm1hbDt3b3JkLXNwYWNpbmc6bm9ybWFsO3RleHQtdHJhbnNmb3JtOm5vbmU7ZGlyZWN0aW9uOmx0cjtibG9jay1wcm9ncmVzc2lvbjp0Yjt3cml0aW5nLW1vZGU6bHItdGI7dGV4dC1hbmNob3I6c3RhcnQ7YmFzZWxpbmUtc2hpZnQ6YmFzZWxpbmU7Y29sb3I6IzAwMDAwMDtmaWxsOiNiZWJlYmU7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmU7c3Ryb2tlLXdpZHRoOjEuNzAwMDAwMDU7bWFya2VyOm5vbmU7dmlzaWJpbGl0eTp2aXNpYmxlO2Rpc3BsYXk6aW5saW5lO292ZXJmbG93OnZpc2libGU7ZW5hYmxlLWJhY2tncm91bmQ6YWNjdW11bGF0ZTtmb250LWZhbWlseTpTYW5zOy1pbmtzY2FwZS1mb250LXNwZWNpZmljYXRpb246U2FucyIgc29kaXBvZGk6bm9kZXR5cGVzPSJzc3NzcyIvPgogIDwvZz4KICA8ZyBpbmtzY2FwZTpncm91cG1vZGU9ImxheWVyIiBpZD0ibGF5ZXIxMyIgaW5rc2NhcGU6bGFiZWw9InBsYWNlcyIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTI4My4wMDAyMSwtNjI5KSIvPgogIDxnIGlua3NjYXBlOmdyb3VwbW9kZT0ibGF5ZXIiIGlkPSJsYXllcjE0IiBpbmtzY2FwZTpsYWJlbD0ibWltZXR5cGVzIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjgzLjAwMDIxLC02MjkpIi8+CiAgPGcgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIgaWQ9ImxheWVyMTUiIGlua3NjYXBlOmxhYmVsPSJlbWJsZW1zIiBzdHlsZT0iZGlzcGxheTppbmxpbmUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yODMuMDAwMjEsLTYyOSkiLz4KICA8ZyBpbmtzY2FwZTpncm91cG1vZGU9ImxheWVyIiBpZD0iZzcxMjkxIiBpbmtzY2FwZTpsYWJlbD0iZW1vdGVzIiBzdHlsZT0iZGlzcGxheTppbmxpbmUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yODMuMDAwMjEsLTYyOSkiLz4KICA8ZyBpbmtzY2FwZTpncm91cG1vZGU9ImxheWVyIiBpZD0iZzQ5NTMiIGlua3NjYXBlOmxhYmVsPSJjYXRlZ29yaWVzIiBzdHlsZT0iZGlzcGxheTppbmxpbmUiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yODMuMDAwMjEsLTYyOSkiLz4KICA8ZyBpbmtzY2FwZTpncm91cG1vZGU9ImxheWVyIiBpZD0ibGF5ZXIxMiIgaW5rc2NhcGU6bGFiZWw9ImFjdGlvbnMiIHN0eWxlPSJkaXNwbGF5OmlubGluZSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTI4My4wMDAyMSwtNjI5KSIvPgo8L3N2Zz4="

isLockEnabled() {
    local lock
    lock=$(gsettings get org.gnome.desktop.screensaver lock-enabled)

    local lockDelay
    lockDelay=$(gsettings get org.gnome.desktop.screensaver lock-delay)

    local idleDelay
    idleDelay=$(gsettings get org.gnome.desktop.session idle-delay)

    ret=0

    if [[ $lock == false && $lockDelay == "uint32 0" && $idleDelay == "uint32 0" ]]; then
        ret=1
    fi

    return $ret
}

menu() {
    cmd="gsettings set org.gnome.desktop.screensaver lock-enabled $2"
    cmd+="; gsettings set org.gnome.desktop.screensaver lock-delay $3"
    cmd+="; gsettings set org.gnome.desktop.session idle-delay $3"
    cmd+="; ${*:4}"

    echo "$1 | refresh=true terminal=false bash='$cmd'"
}

if isLockEnabled; then
    echo "| image=$offIcon"

    echo "---"

    menu "Enable caffeine" false 0 0
else
    echo "| image=$onIcon "

    echo "---"

    # 5 mins
    delay=$((60 * 5))

    menu "Disable caffeine" true $delay
fi