param([ValidateSet("patch","minor","major")][string]$Bump = "patch")
$ErrorActionPreference = "Stop"
$root = Resolve-Path "$PSScriptRoot\.."
$verFile = Join-Path $root "VERSION"
$oldVer = ([System.IO.File]::ReadAllText($verFile)).Trim()
$nums = $oldVer.Split('.')
$maj = [int]$nums.Item(0); $min = [int]$nums.Item(1); $pat = [int]$nums.Item(2)
switch ($Bump) {
    "major" { $maj++; $min = 0; $pat = 0 }
    "minor" { $min++; $pat = 0 }
    "patch" { $pat++ }
}
$newVer = "$maj.$min.$pat"
$notas = Read-Host "Descripcion de v$newVer (Enter para omitir)"
if ([string]::IsNullOrWhiteSpace($notas)) { $notas = "Release v$newVer" }
[System.IO.File]::WriteAllText($verFile, $newVer, (New-Object System.Text.UTF8Encoding $false))
Set-Location $root
git add .
git commit -m "release(v$newVer): $notas"
git tag -a "v$newVer" -m "$notas"
git push origin main --tags
Write-Host "Version v$newVer publicada en GitHub!" -ForegroundColor Green