param(
    [Parameter(Mandatory=$true)]
    [string]$LogFile
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $LogFile)) {
    throw "Log file not found: $LogFile"
}

$text = Get-Content -LiteralPath $LogFile -Raw

function Find-FirstMatch {
    param([string]$Pattern)
    $m = [regex]::Match($text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if ($m.Success) { return $m.Value.Trim() }
    return $null
}

$lines = Get-Content -LiteralPath $LogFile
$warningText = @()
$datePrefix = "^\s*\d{1,2}/[A-Za-z]{3}/\d{4}\s+\d{2}:\d{2}:\d{2}\s+"
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "\*\*\* Warning \*\*\*") {
        $block = @(($lines[$i] -replace $datePrefix, "").Trim())
        for ($j = $i + 1; $j -lt $lines.Count; $j++) {
            $line = $lines[$j]
            if ($line -match "^\s*-{10,}\s*$") { break }
            if ($line -match "^\d{1,2}/[A-Za-z]{3}/\d{4}.*\*\*\* Warning \*\*\*") { break }
            if ($line.Trim().Length -gt 0) {
                $block += (($line -replace $datePrefix, "").Trim())
            }
        }
        $compact = (($block -join " ") -replace "\s+", " ").Trim()
        if ($compact -ne "*** Warning ***") {
            $warningText += $compact
        }
    }
}

$summary = [ordered]@{
    logFile = (Resolve-Path -LiteralPath $LogFile).Path
    solverStarted = $text -match "Solver started at"
    solverFinished = $text -match "Solver finished at"
    steadyStateSuccess = $text -match "Steady state energy criterion met, solver finished successfully"
    module = Find-FirstMatch "Module:\s+.*"
    version = Find-FirstMatch "Version:\s+.*"
    stimulation = Find-FirstMatch "(Plane wave stimulation|Simultaneous excitation|Waveguide port stimulation|Discrete port stimulation)"
    frequencySettings = Find-FirstMatch "Fmin:\s*.*\r?\n\s*Fmax:\s*.*"
    meshCells = Find-FirstMatch "Number of mesh cells:\s*.*"
    totalSolverTime = Find-FirstMatch "Total solver time:\s*.*"
    totalSimulationTime = Find-FirstMatch "Total simulation time:\s*.*"
    warningCount = $warningText.Count
    warnings = $warningText
}

$summary | ConvertTo-Json -Depth 4
