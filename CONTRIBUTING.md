# Contributing

## Ramas
- Trabaja siempre en una rama feature/fix desde `main`.
- Convención: `feature/<descripción>`, `fix/<descripción>`, `chore/<descripción>`.
- Mantén la rama actualizada con `main` antes de abrir el PR.

## Commits
Sigue el estándar [Conventional Commits](https://www.conventionalcommits.org/):

| Prefijo | Uso |
|---|---|
| `feat:` | Nueva funcionalidad |
| `fix:` | Corrección de bug |
| `chore:` | Mantenimiento, dependencias |
| `docs:` | Documentación |
| `ci:` | Cambios en pipeline / CI |
| `refactor:` | Refactoring sin cambio de comportamiento |
| `test:` | Agregar o modificar tests |

Ejemplo: `ci: add npm cache to node-ci-steps template`

## Checklist antes de abrir PR

### Pipeline
- [ ] YAML válido (sin TODOs pendientes)
- [ ] Stages: `BuildAndTest → Package → Kubernetes → Container`
- [ ] Template `node-ci-steps.yml` usado en lugar de pasos inline repetidos
- [ ] `npm ci` en lugar de `npm install`
- [ ] Cache de npm configurada (`Cache@2` con `package-lock.json`)
- [ ] `out/` publicado como Pipeline Artifact (`drop`)
- [ ] Azure Artifacts npm feed documentado conceptualmente

### Helm / Kubernetes
- [ ] `helm lint` pasa sin errores
- [ ] `helm template` renderiza correctamente
- [ ] Manifests renderizados publicados como artifact (`helm-manifests`)
- [ ] Deployment usa puerto 3000 y apunta al endpoint `/health`
- [ ] Probes (liveness/readiness) definidas y razonables
- [ ] Resources (requests/limits) definidos

### Docker
- [ ] Dockerfile usa `npm ci` (no `npm install`)
- [ ] Build multi-stage: solo `src/` y `node_modules` en imagen final
- [ ] Imagen corre como usuario no-root
- [ ] Stage Container: tag con `Build.BuildId` + `docker image inspect`

### Seguridad
- [ ] gitleaks integrado o documentado (con política de fallo)
- [ ] Sin secretos hardcodeados en el código

### Documentación
- [ ] `docs/decisions.md` actualizado con supuestos y cambios relevantes
- [ ] `docs/tooling-proposal.md` completo
- [ ] PR description clara y con contexto para el evaluador

## Proceso de review
- Asigna al menos un reviewer del equipo dueño del path (ver CODEOWNERS).
- Resuelve todos los comentarios antes de mergear.
- Prefiere squash merge para mantener historia limpia en `main`.
