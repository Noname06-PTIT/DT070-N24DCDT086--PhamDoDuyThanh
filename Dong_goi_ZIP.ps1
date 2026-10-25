$ErrorActionPreference = 'Stop'
$rootDirName = "N24DCDT086_DT070_PhamDoDuyThanh_MaNguon"
$zipFileName = "$rootDirName.zip"
$sourceDir = $PSScriptRoot
$parentDir = Split-Path $sourceDir -Parent
$stagingDir = Join-Path $parentDir "temp_staging_$rootDirName"
$zipOutputPath = Join-Path $parentDir $zipFileName

Write-Output "=== TIEN HANH DONG GOI MA NGUON CHUAN CLASSROOM ==="
Write-Output "Thu muc nguon: $sourceDir"
Write-Output "Ten file ZIP:  $zipFileName"

if (Test-Path $stagingDir) {
    Remove-Item -Recurse -Force $stagingDir
}
if (Test-Path $zipOutputPath) {
    Remove-Item -Force $zipOutputPath
}

$destFolder = Join-Path $stagingDir $rootDirName
New-Item -ItemType Directory -Path $destFolder -Force | Out-Null

Copy-Item -Recurse -Force (Join-Path $sourceDir "docs") (Join-Path $destFolder "docs")
Copy-Item -Recurse -Force (Join-Path $sourceDir "scripts") (Join-Path $destFolder "scripts")
Copy-Item -Recurse -Force (Join-Path $sourceDir "src") (Join-Path $destFolder "src")
Copy-Item -Recurse -Force (Join-Path $sourceDir "test") (Join-Path $destFolder "test")

Copy-Item -Force (Join-Path $sourceDir "demo.jl") (Join-Path $destFolder "demo.jl")
Copy-Item -Force (Join-Path $sourceDir "README.md") (Join-Path $destFolder "README.md")
Copy-Item -Force (Join-Path $sourceDir "Run_all.ps1") (Join-Path $destFolder "Run_all.ps1")
if (Test-Path (Join-Path $sourceDir ".gitignore")) {
    Copy-Item -Force (Join-Path $sourceDir ".gitignore") (Join-Path $destFolder ".gitignore")
}

Get-ChildItem -Path $destFolder -Recurse -Include ".git*", ".vscode*", "*.tmp", "*.cache" -Force | Remove-Item -Recurse -Force

Compress-Archive -Path (Join-Path $stagingDir "*") -DestinationPath $zipOutputPath -CompressionLevel Optimal
Remove-Item -Recurse -Force $stagingDir

Write-Output "========================================================="
Write-Output "DA TAO THANH CONG TEP ZIP CHUAN NOP BAI:"
Write-Output "  -> $zipOutputPath"
Write-Output "========================================================="
