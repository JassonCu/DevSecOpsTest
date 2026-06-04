# Azure Artifacts (conceptual) — npm package publishing

> **Importante:** Esta sección es **solo conceptual**. No se requiere configurar Azure Artifacts ni publicar a un feed real.

## Objetivo
Describir cómo publicar el paquete generado por `npm pack` a un **Azure Artifacts npm feed**, y cómo consumirlo desde otro pipeline/proyecto.

## Publicación (conceptual)
1. Crear un feed npm en Azure Artifacts.
2. Configurar autenticación para el agente (ej. `.npmrc` con token/credential provider).
3. En el stage `Package`, ejecutar:
   - `npm ci`
   - `npm version <semver>` (si aplica)
   - `npm publish` apuntando al registry del feed.

## Consumo (conceptual)
1. Configurar `.npmrc` del proyecto consumidor con el registry del feed.
2. En el pipeline consumidor, ejecutar `npm ci` y el paquete se resuelve desde el feed.

## Consideraciones
- Versionado y promoción (pre-release vs release).
- Permisos del feed (lectura/publicación).
- Auditoría y retención de paquetes.
