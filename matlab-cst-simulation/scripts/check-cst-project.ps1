param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectFile,

    [string[]]$ExpectPattern = @()
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ProjectFile)) {
    throw "CST project not found: $ProjectFile"
}

$projectItem = Get-Item -LiteralPath $ProjectFile
$projectDir = Join-Path $projectItem.DirectoryName $projectItem.BaseName
$modelMod = Join-Path $projectDir "Model\3D\Model.mod"
$modelDsn = Join-Path $projectDir "Model\3D\Model.dsn"
$resultDir = Join-Path $projectDir "Result"
$logFile = Join-Path $resultDir "Model.log"

$modText = ""
if (Test-Path -LiteralPath $modelMod) {
    $modText = Get-Content -LiteralPath $modelMod -Raw
}

$missingPatterns = @()
foreach ($pattern in $ExpectPattern) {
    if ($modText -notmatch $pattern) {
        $missingPatterns += $pattern
    }
}

$resultFiles = @()
if (Test-Path -LiteralPath $resultDir) {
    $resultFiles = Get-ChildItem -LiteralPath $resultDir -File -Force |
        Select-Object Name, Length, LastWriteTime
}

$summary = [ordered]@{
    projectFile = $projectItem.FullName
    projectDirectory = $projectDir
    projectDirectoryExists = Test-Path -LiteralPath $projectDir
    modelModExists = Test-Path -LiteralPath $modelMod
    modelDsnExists = Test-Path -LiteralPath $modelDsn
    resultDirectoryExists = Test-Path -LiteralPath $resultDir
    logFileExists = Test-Path -LiteralPath $logFile
    hasSolverFrequencyRange = $modText -match "FrequencyRange|Solver\.FrequencyRange"
    hasBoundarySetup = $modText -match "With Boundary|\.Xmin|\.Xmax|\.Ymin|\.Ymax|\.Zmin|\.Zmax"
    hasMonitorSetup = $modText -match "With Monitor|FieldType|Efield|Hfield|Farfield"
    hasExcitationSetup = $modText -match "PlaneWave|With Port|DiscretePort|Waveguide|Excitation"
    missingExpectedPatterns = $missingPatterns
    resultFiles = $resultFiles
}

$summary | ConvertTo-Json -Depth 5
