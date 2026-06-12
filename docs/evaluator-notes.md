# Notas para el evaluador

## Validar localmente (sin Azure/cloud)

**1. Tests Node.js**
```bash
npm ci
npm test
```
Esperado: 1 suite, 1 test verde (`GET /health → 200 ok`).

**2. Helm chart**
```bash
helm lint charts/devsecops-app
helm template devsecops-app charts/devsecops-app --namespace default
```
Esperado: `1 chart(s) linted, 0 chart(s) failed`. El template renderiza Deployment (puerto 3000, probes, resources) + Service (targetPort 3000).

**3. Docker**
```bash
docker build -t devsecops-assessment-node:local .
docker image inspect devsecops-assessment-node:local --format "User: {{.Config.User}} | Ports: {{.Config.ExposedPorts}}"
```
Esperado: `User: appuser | Ports: map[3000/tcp:{}]`.

**4. npm pack**
```bash
npm run pack:npm
ls *.tgz
```
Esperado: `devsecops-assessment-node-1.0.0.tgz` generado en el directorio raíz.

## Archivos clave modificados

| Archivo | Qué se hizo |
|---|---|
| `ado/azure-pipelines.yml` | Pipeline completo, todos los TODOs resueltos |
| `ado/templates/node-ci-steps.yml` | Template con cache, npm ci, parámetros |
| `Dockerfile` | Multi-stage, Alpine, no-root |
| `charts/devsecops-app/values.yaml` | Imagen node, puerto 3000, probes, resources |
| `charts/devsecops-app/templates/deployment.yaml` | Puerto 3000, probes, securityContext |
| `charts/devsecops-app/templates/service.yaml` | targetPort 3000 |
| `docs/decisions.md` | Decisiones, supuestos, correcciones |
| `docs/tooling-proposal.md` | Propuesta Trivy (container scan) |
| `CODEOWNERS` | Propietarios por directorio |
| `CONTRIBUTING.md` | Convención de commits, checklist |
| `package-lock.json` | Generado para habilitar `npm ci` |
