# psql-init-container

https://hub.docker.com/r/turbosnail/psql-init-container

you can use this container to initialize your database and user in postgresql server what run in **docker swarm** or **k8s**

you can mount your *.sql files in /root path to run it after initialize database and user

use next environments

```bash
PSQL_HOST
PSQL_PORT - default 5432
PSQL_ROOT_USERNAME - default postgres
PSQL_ROOT_PASSWORD
PSQL_USERNAME
PSQL_PASSWORD
PSQL_DATABASE
```
this is part of deployment.yml for example
```yaml
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: {{ template "trackableappname" . }}
spec:
  template:
    metadata:
      labels:
        service: {{ template "trackableappname" . }}
      annotations:
        git_commit: {{ .Values.commitHash }}
    spec:
      initContainers:
      - name: init-database
        image: turbosnail/psql-init-container
        env:
        - name: PSQL_HOST
          value: {{ .Values.psql.hostname }}
        - name: PSQL_ROOT_PASSWORD
          value: {{ .Values.psql.root_password }}
        - name: PSQL_USERNAME
          value: {{ .Values.psql.username }}
        - name: PSQL_PASSWORD
          value: {{ .Values.psql.password }}
        - name: PSQL_DATABASE
          value: {{ .Values.psql.database }}
```
