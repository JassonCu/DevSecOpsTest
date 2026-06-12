## Resumen
<!-- Describe qué cambiaste y por qué. 2-3 oraciones. -->

## Tipo de cambio
- [ ] feat: nueva funcionalidad
- [ ] fix: corrección de bug
- [ ] ci: cambio en pipeline / templates
- [ ] docs: documentación
- [ ] chore: mantenimiento

## Checklist

### Pipeline & Templates
- [ ] YAML válido, stages en orden (`BuildAndTest → Package → Kubernetes → Container`)
- [ ] Template `node-ci-steps.yml` usado (sin duplicación inline)
- [ ] `npm ci` + cache de npm (`Cache@2`)
- [ ] `out/*.tgz` publicado como artifact `drop`
- [ ] Azure Artifacts npm feed documentado conceptualmente

### Helm / Kubernetes
- [ ] `helm lint` pasa sin errores
- [ ] `helm template` renderiza correctamente
- [ ] Manifests renderizados publicados como artifact `helm-manifests`
- [ ] Puerto 3000, probes y resources definidos

### Docker
- [ ] Multi-stage build, `npm ci`, usuario no-root
- [ ] Tag con `Build.BuildId` + `docker image inspect` en pipeline

### Seguridad
- [ ] gitleaks integrado (o documentado con política de fallo)
- [ ] Sin secretos hardcodeados

### Documentación
- [ ] `docs/decisions.md` actualizado
- [ ] `docs/tooling-proposal.md` completo

## Cómo validar
<!-- Pasos concretos para que el evaluador/reviewer valide el cambio. -->
1.
2.

## Notas para el evaluador
<!-- Contexto adicional, decisiones de diseño, trade-offs, etc. -->
