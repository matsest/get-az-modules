[OutputType([array])]
[CmdletBinding()]
param (
    [Parameter(Mandatory, HelpMessage = 'Path to a Powershell file (.ps1 or .psm1) using Az cmdlets')]
    [ValidateScript( { Test-Path $_ })]
    [string]
    $Path,
    [Parameter(HelpMessage = 'Prefix for the module used. Must match the prefix used in commandlets for the module. Defaults to "Az".')]
    [string]
    $Prefix = 'Az',
    [Parameter(HelpMessage = 'Check installed versions of used modules compared to latest')]
    [Switch]
    $CheckVersions
)

## Input validation
$file = Get-Item $Path
if ($file.Extension -notin '.ps1', '.psm1') {
    Write-Error "$($file.Name) is not a powershell file"
    return $null
}

Write-Host "Looking for $Prefix modules needed for $($file.Name)..."

## Identify all cmdlets used
$content = Get-Content -Path $Path -Raw
$allMatches = $content | Select-String -Pattern "\w+-$Prefix\w+" -AllMatches
$uniqueCmdlets = $allMatches.Matches.Value | Select-Object -Unique
$modules = @()

if ($uniqueCmdlets.Count -eq 0) {
    Write-Host "No $Prefix cmdlets found"
    return $null
}
else {
    Write-Host "Number of unique $Prefix cmdlets found: $($uniqueCmdlets.Count)"
}

## Find all modules used
foreach ($cmdlet in $uniqueCmdlets) {
    $found = Get-Command $cmdlet -ErrorAction:SilentlyContinue
    if (!$found) {
        $remoteCmdlet = Find-Command $cmdlet
        if ($remoteCmdlet) {
            Write-Warning "$cmdlet was not found. Available in module $($remoteCmdlet.ModuleName) [$($remoteCmdlet.Version)] from $($remoteCmdlet.Repository)"
            $module = $remoteCmdlet.ModuleName
        }
        else {
            Write-Warning "$cmdlet was not found in an installed module"
        }
    }
    else {
        $module = (Get-Command $cmdlet).Source
    }
    Write-Verbose "$cmdlet uses $module"
    if ($module -notin $modules) {
        $modules += $module
    }
}

Write-Host "Number of $Prefix modules used: $($modules.Count)"

$modulesWithVersion = @()
## Optional: Check versions of installed modules
if ($CheckVersions) {
    foreach ($module in $modules) {
        $installedVer = (Get-Module $module -ListAvailable).Version
        $latestVer = (Find-Module $module).Version
        if ($installedVer -and ($latestVer -gt $installedVer)) {
            Write-Warning "$($module): latest version [$latestVer] newer than installed version [$installedVer]"
        }
        $modulesWithVersion += [PSCustomObject]@{
            Name = $module
            InstalledVersion = $installedVer
            LatestVersion = $latestVer
        }
    }
    return $modulesWithVersion | Sort-Object -Property Name
}

return $modules | Sort-Object