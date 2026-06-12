# Decisions

## Supuestos
- El agente Azure Pipelines es `ubuntu-latest` con Docker disponible (requerido para el stage Container).
- No se requiere acceso real a Azure ni a un cluster Kubernetes; el ejercicio es "cloudless".
- El paquete npm tiene `"private": true` en package.json; `npm pack` genera el `.tgz` sin publicar a ningún registry.
- La imagen Docker es solo para demostración local; no se hace push a ningún registry.
- Helm está disponible via la tarea `HelmInstaller@1` en el agente ubuntu.

## Enfoque del pipeline
Los 4 stages siguen un orden lógico de fail-fast: `BuildAndTest → Package → Kubernetes → Container`.

- **BuildAndTest** ejecuta CI completo (tests + lint + gitleaks) primero para detectar problemas temprano y no desperdiciar recursos en stages posteriores.
- **Package** reutiliza el template `node-ci-steps.yml` (sin tests/lint, solo install) para no repetir código y generar el artefacto `.tgz`.
- **Kubernetes** valida el chart Helm con `helm lint` + `helm template` sin necesitar un cluster real.
- **Container** construye la imagen con tag de `Build.BuildId` para trazabilidad y genera evidencia con `docker inspect`.

El template `node-ci-steps.yml` centraliza Node setup + npm cache + npm ci con parámetros para habilitar/deshabilitar tests y lint, eliminando la duplicación entre stages.

## Artefactos publicados
| Artifact | Contenido | Motivo |
|---|---|---|
| `drop` | `out/*.tgz` (npm pack) | Trazabilidad del paquete por build |
| `helm-manifests` | Salida de `helm template` | Auditoría, GitOps, revisión de PR |
| `gitleaks-report` | JSON de findings de secretos | Análisis post-ejecución, siempre publicado |

**Azure Artifacts npm feed (conceptual):** ver `docs/azure-artifacts-concept.md`. El flujo sería: configurar `.npmrc` con la URL del feed → autenticar el agente con `npm-auth-provider` de Azure → ejecutar `npm version <semver>` + `npm publish`.

## Kubernetes / Helm — correcciones aplicadas
| Archivo | Error original | Corrección |
|---|---|---|
| `values.yaml` | `image.repository: nginx`, `port: 80`, `probes.enabled: false`, `resources: {}` | Imagen del app Node, puerto 3000, probes habilitadas, resources definidos |
| `deployment.yaml` | `containerPort: 8080`, sin probes, sin resources | Puerto 3000, liveness/readiness hacia `/health`, resources y securityContext no-root |
| `service.yaml` | `targetPort: 3001` | `targetPort: 3000` para alinear con el contenedor |

`helm lint` detecta errores de sintaxis y estructura; `helm template` verifica que el chart renderiza correctamente con los values dados, sin necesitar un cluster.

## Seguridad
- **gitleaks** en `BuildAndTest` con política de fallo (exit-code 1); reporte publicado siempre via `condition: always()`.
- **Dockerfile** corre como usuario no-root (`appuser:appgroup`) y usa imagen base Alpine para reducir superficie de ataque y tamaño de imagen.
- Build multi-stage: la stage `deps` instala dependencias; la stage `production` solo copia `node_modules` y `src/`, sin incluir herramientas de build ni archivos de configuración.

## Riesgos / mejoras futuras
- Agregar firma de imagen Docker con Cosign (supply chain security, SLSA nivel 2+).
- Integrar Trivy en el stage Container para scanning de CVEs (ver `docs/tooling-proposal.md`).
- Versionar semánticamente el paquete npm con `npm version` antes de empaquetar.
- Agregar `helm test` una vez exista un cluster de staging disponible.
- Configurar branch protection rules con required status checks y CODEOWNERS reviews en GitHub.
- Separar el stage Container en un pipeline de CD (release) diferenciado del CI.
