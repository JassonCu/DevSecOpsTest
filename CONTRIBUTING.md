# Contributing

## Objetivo
Este repositorio es parte de una evaluación técnica. Mantén cambios enfocados, pequeños y justificables.

## Convención de commits (sugerida)
- feat: nueva funcionalidad
- fix: corrección
- chore: mantenimiento
- docs: documentación

## Checklist antes de abrir PR
- [ ] El pipeline YAML está claro y modular (templates)
- [ ] Uso de `npm ci` en lugar de `npm install`
- [ ] Cache de dependencias aplicada
- [ ] Publicación de artefactos definida (Pipeline Artifact)
- [ ] Documentación conceptual de Azure Artifacts npm feed
- [ ] Dockerfile con buenas prácticas (no-root, capas)
- [ ] Chart Helm / manifests corregidos
- [ ] Helm lint / helm template agregados al pipeline
- [ ] Documentación mínima (`docs/decisions.md` y `docs/tooling-proposal.md`)
- [ ] (Opcional) gitleaks integrado o documentado
