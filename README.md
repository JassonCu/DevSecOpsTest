# DevSecOps Assessment (Node + Azure Pipelines + Helm)

Este repositorio es un starter para una prueba técnica.

## Ejecutar local
```bash
npm ci
npm test
npm start
```

## Health endpoint
- GET http://localhost:3000/health

## Pipeline
El YAML principal está en `ado/azure-pipelines.yml` y contiene TODOs intencionales.

## Artefacts
La salida del empaquetado conceptual (`npm pack`) debe quedar como `.tgz` en `out/` y publicarse como Pipeline Artifact.

## Kubernetes / Helm
El chart base está en `charts/devsecops-app/` y contiene errores intencionales para corregir.
