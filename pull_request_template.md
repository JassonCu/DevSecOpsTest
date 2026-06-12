## Resumen

Resolución completa de la prueba técnica DevSecOps (Node + Azure Pipelines + Kubernetes/Helm).

Se corrigió y completó el pipeline `ado/azure-pipelines.yml` con los 4 stages requeridos, se refactorizó usando un template reutilizable, se empaquetó la app como `.tgz` y se publicaron artefactos. Se corrigió el chart Helm (puertos, probes, resources). Se mejoró el Dockerfile a multi-stage con usuario no-root. Se integró gitleaks como escaneo de secretos. Se completó la documentación en `docs/`.

## Checklist
- [x] Pipeline YAML actualizado — stages `BuildAndTest → Package → Kubernetes → Container`, triggers PR/main, variables, condiciones
- [x] Template(s) agregado(s) / mejorado(s) — `ado/templates/node-ci-steps.yml` con `Cache@2`, `npm ci`, parámetros `runTests`/`runLint`
- [x] Artefactos configurados — `drop` (npm .tgz), `helm-manifests` (helm template), `gitleaks-report`
- [x] Azure Artifacts (conceptual) documentado — ver `docs/azure-artifacts-concept.md`
- [x] Dockerfile mejorado — multi-stage, `npm ci --only=production`, imagen Alpine, usuario `appuser` no-root
- [x] Chart Helm / deployment corregidos — imagen node, `containerPort: 3000`, `targetPort: 3000`, probes en `/health`, resources requests/limits, securityContext non-root
- [x] Validaciones de Helm agregadas — `helm lint` + `helm template` en stage Kubernetes, manifests publicados como artifact
- [x] Docs actualizadas — `docs/decisions.md`, `docs/tooling-proposal.md` (Trivy)
- [x] (Opcional) gitleaks integrado — stage BuildAndTest, política fail on findings (exit-code 1), reporte publicado siempre

## Notas para el evaluador

### Validar localmente (sin Azure/cloud)

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

### Archivos clave modificados
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
