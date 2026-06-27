$info = Get-Content "info.json" | ConvertFrom-Json
$name = $info.name
$version = $info.version
$folderName = "${name}_${version}"
$zipName = "${folderName}.zip"

$include = @(
    "info.json",
    "changelog.txt",
    "control.lua",
    "data.lua",
    "settings.lua",
    "speed.lua",
    "damage.lua",
    "constants.lua",
    "gui.lua",
    "locale",
    "graphics",
    "thumbnail.png"
)

$staging = Join-Path $env:TEMP $folderName
if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
New-Item -ItemType Directory -Path $staging | Out-Null

foreach ($item in $include) {
    if (Test-Path $item) {
        Copy-Item $item -Destination $staging -Recurse
    }
}

$distDir = Join-Path (Get-Location) "dist"
if (-not (Test-Path $distDir)) { New-Item -ItemType Directory -Path $distDir | Out-Null }
$zipPath = Join-Path $distDir $zipName
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

Compress-Archive -Path $staging -DestinationPath $zipPath

Remove-Item $staging -Recurse -Force

Write-Host "Created $zipName"
