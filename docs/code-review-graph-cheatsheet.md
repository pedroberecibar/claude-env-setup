# Code Review Graph: ¿Cómo funciona?

El `code-review-graph` es un servidor MCP (Model Context Protocol) que funciona como un "mapa de dependencias" local para proyectos de software. Su objetivo es reducir drásticamente el consumo de tokens evitando que el LLM lea archivos irrelevantes.

## Arquitectura Interna

1. **Parseo (Tree-sitter):** La herramienta escanea el código fuente usando Tree-sitter para generar un Árbol de Sintaxis Abstracta (AST).
2. **Construcción del Grafo:** * Convierte las entidades del AST (funciones, clases, variables) en **Nodos**.
   * Identifica las relaciones (llamadas, importaciones, herencias) y crea **Aristas (Edges)** entre ellos.
3. **Almacenamiento Local:** Toda esta estructura se guarda en una base de datos SQLite ligera dentro de la carpeta oculta `.code-review-graph`.

## Flujo de Actualización Incremental

El grafo no necesita reconstruirse desde cero en cada cambio. 
A través de los *hooks* configurados en `settings.json`, cada vez que se guarda un archivo o se hace un *commit*, la herramienta:
* Hace un diff para detectar los archivos modificados.
* Usa hashes SHA-256 para validar qué dependencias cambiaron realmente.
* Re-parsea **únicamente** el radio afectado (generalmente en menos de 2 segundos).

## Concepto Clave: Blast Radius (Radio de Impacto)

En lugar de usar búsquedas de texto tradicionales (Grep/Glob), el grafo calcula el *Blast Radius*. 
Cuando se modifica la `Función A`, el grafo rastrea automáticamente:
* Qué otras funciones llaman a la `Función A`.
* De qué módulos depende la `Función A`.
* Qué tests están vinculados a ese flujo de ejecución.

El LLM recibe únicamente este subconjunto de archivos, logrando reducciones de hasta **8.2x en el consumo de tokens** frente a una lectura tradicional de contexto.

## 📊 Visualización del Grafo (Manual)

**Importante:** La automatización de este repositorio (vía `settings.json`) actualiza únicamente la base de datos SQLite oculta que usa Claude. **NO genera el mapa visual automáticamente.**

¿Por qué? Porque generar el archivo HTML interactivo en cada *save* o *commit* consumiría recursos innecesarios de tu PC y pondría lento el entorno. Claude no necesita ver el HTML, solo lee los datos estructurados.

**Para generar el mapa visual humano (bajo demanda):**
Ejecutá en tu terminal:

> bash
> code-review-graph visualize

Esto creará un archivo interactivo en tu proyecto para explorar nodos, dependencias y arquitectura desde el navegador.

**Opciones de exportación:**
* `code-review-graph visualize --format svg` (Vectorial estático, ideal para documentos).
* `code-review-graph visualize --format graphml` (Para analizar en software como Gephi).