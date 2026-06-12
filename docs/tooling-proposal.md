# Tooling proposal: Trivy (Container Scanning + SCA)

## Paso del flujo a mejorar
Container scanning y Software Composition Analysis (SCA): el stage `Container` construye la imagen Docker pero no verifica vulnerabilidades en dependencias npm ni en la imagen base. Una imagen con CVEs críticos puede llegar a producción sin ser detectada.

## Herramienta propuesta
- **Nombre:** Trivy (by Aqua Security)
- **Tipo:** OSS (Apache 2.0), con opción Enterprise via Aqua Platform
- **Repositorio:** github.com/aquasecurity/trivy

## Integración en el pipeline
**Stage/Job:** `Container` / `DockerBuild`, inmediatamente después del `docker build`.

```yaml
- script: |
    docker run --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v $(Build.ArtifactStagingDirectory):/output \
      aquasec/trivy:latest image \
      --exit-code 1 \
      --severity HIGH,CRITICAL \
      --format json \
      --output /output/trivy-report.json \
      $(npmPackageName):$(imageTag)
  displayName: 'Container scan (Trivy)'

- task: PublishPipelineArtifact@1
  condition: always()
  inputs:
    targetPath: '$(Build.ArtifactStagingDirectory)/trivy-report.json'
    artifactName: 'trivy-report'
  displayName: 'Publish Trivy report'
```

La política de fallo es `--exit-code 1` para severidades HIGH y CRITICAL: el pipeline se bloquea hasta que se resuelvan. Para los primeros sprints se puede usar `--exit-code 0` con reporte (audit mode) para generar línea base sin romper el flujo.

## Criterios de éxito (qué medimos)
- 0 vulnerabilidades CRITICAL en imágenes que llegan a staging/producción
- 100 % de imágenes construidas en el pipeline escaneadas
- Tiempo de ejecución del scan < 3 minutos por build
- Tendencia decreciente de findings HIGH mes a mes (revisión en sprint review)

## Riesgos / limitaciones
- **Falsos positivos:** pueden generar fricción si el umbral se aplica desde el día 1; mitigar con un período de audit mode inicial.
- **Entornos air-gapped:** la base de datos de CVEs requiere un mirror interno; Trivy soporta `--db-repository` para esto.
- **Imágenes grandes:** el scan puede tomar > 5 minutos en imágenes > 1 GB; usar imagen base Alpine (como en nuestro Dockerfile) reduce significativamente el tiempo.
- **No reemplaza DAST:** Trivy analiza dependencias y configuración estática, no comportamiento en runtime.

## Alternativa B
**Snyk** (snyk.io): extensión nativa en el Azure DevOps Marketplace, análisis de npm + imagen Docker, dashboard web con priorización de vulnerabilidades. Ventaja: mejor UX y gestión de excepciones. Limitación: requiere licencia de pago para equipos > 3 personas y expone el SBOM a un servicio externo.
