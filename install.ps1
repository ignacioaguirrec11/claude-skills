# Instala las skills de este repo en ~/.claude/skills (Windows)
# Uso: powershell -ExecutionPolicy Bypass -File install.ps1
$ErrorActionPreference = "Stop"
$repo   = $PSScriptRoot
$target = Join-Path $HOME ".claude\skills"
New-Item -ItemType Directory -Force $target | Out-Null

# 1. Skills locales (copiadas en este repo)
Get-ChildItem (Join-Path $repo "skills") -Directory | ForEach-Object {
    $dest = Join-Path $target $_.Name
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse $_.FullName $dest
    Write-Host "OK  $($_.Name)"
}

# 2. Skills que viven en repos externos (se clonan / actualizan)
$external = @{
    "gstack"     = "https://github.com/garrytan/gstack.git"
    "n8n-skills" = "https://github.com/czlonkowski/n8n-skills.git"
}
foreach ($name in $external.Keys) {
    $dest = Join-Path $target $name
    if (Test-Path (Join-Path $dest ".git")) {
        git -C $dest pull --ff-only
    } else {
        git clone --single-branch --depth 1 $external[$name] $dest
    }
    Write-Host "OK  $name (git)"
}

# gstack necesita su setup (requiere Git Bash / bun)
$bash = Get-Command bash -ErrorAction SilentlyContinue
if ($bash) {
    Push-Location (Join-Path $target "gstack"); bash ./setup; Pop-Location
} else {
    Write-Warning "No se encontro bash: corre manualmente 'cd ~/.claude/skills/gstack && ./setup'"
}

Write-Host "`nListo. Reinicia Claude Code para que tome las skills."
