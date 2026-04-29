<#
.SYNOPSIS
Configura el entorno optimizado de Claude Code para el proyecto actual.
#>

Write-Host "Iniciando configuración de Claude Code..." -ForegroundColor Cyan

# 1. Configuración Global (Asegura Sonnet como default)
Write-Host "Ajustando configuración global (Sonnet 3.5)..."
$globalConfigPath = "$env:USERPROFILE\.claude.json"
if (-Not (Test-Path $globalConfigPath)) {
    Set-Content -Path $globalConfigPath -Value "{`n  `"theme`": `"dark`",`n  `"defaultModel`": `"claude-3-5-sonnet-20241022`"`n}"
} else {
    # Forma simple de forzar el modelo global vía CLI para evitar romper JSONs complejos
    claude config set defaultModel claude-3-5-sonnet-20241022 --global > $null 2>&1
}

# 2. Crear carpeta .claude local si no existe
$localClaudeDir = ".\.claude"
if (-Not (Test-Path $localClaudeDir)) {
    New-Item -ItemType Directory -Force -Path $localClaudeDir | Out-Null
}

# 3. Copiar settings.json (Compactación 80% + Hooks)
Write-Host "Aplicando settings.json (Compactación 80% y Hooks)..."
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Copy-Item -Path "$scriptDir\templates\base_settings.json" -Destination "$localClaudeDir\settings.json" -Force

# 4. Configurar CLAUDE.md
Write-Host "Configurando CLAUDE.md (Reglas de tokens)..."
$localClaudeMd = ".\CLAUDE.md"
$baseMdContent = Get-Content -Path "$scriptDir\templates\base_CLAUDE.md" -Raw

if (Test-Path $localClaudeMd) {
    # Si ya existe, lo agrega al principio
    $currentMd = Get-Content -Path $localClaudeMd -Raw
    if (-Not $currentMd.Contains("Output Style & Token Reduction")) {
        $mergedContent = $baseMdContent + "`n`n" + $currentMd
        Set-Content -Path $localClaudeMd -Value $mergedContent
        Write-Host "  -> Reglas inyectadas al principio del CLAUDE.md existente."
    } else {
        Write-Host "  -> Las reglas ya existen en CLAUDE.md. Omitiendo."
    }
} else {
    # Si no existe, lo crea
    Set-Content -Path $localClaudeMd -Value $baseMdContent
    Write-Host "  -> Archivo CLAUDE.md creado desde cero."
}

Write-Host "¡Configuración completada con éxito! Listo para codear." -ForegroundColor Green