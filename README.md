# Claude Code Setup 🚀

Repositorio personal para automatizar y estandarizar la configuración de Claude Code en nuevos proyectos. 

## ¿Qué soluciona?
1. **Fuerza el modelo Claude 3.5 Sonnet** globalmente para reducir costos.
2. **Establece la autocompactación al 80%** (vía variable oculta en `settings.json`) para limpiar la memoria sin perder el contexto de flujos complejos.
3. **Inyecta reglas estrictas de output** en `CLAUDE.md` para evitar que la IA genere tokens innecesarios (saludos, palabras de relleno).
4. **Automatiza `code-review-graph`** configurando hooks para que el grafo de dependencias se actualice solo al editar archivos.

## Uso

1. Clonar este repositorio en tu máquina (ej. `C:\tools\claude-env-setup`).
2. Abrir la terminal en la raíz del **nuevo proyecto** que quieras configurar.
3. Ejecutar el script apuntando a donde clonaste este repo:
   ```powershell
   & "C:\tools\claude-env-setup\setup.ps1"