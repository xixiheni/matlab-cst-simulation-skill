param(
    [string]$MatlabCommand = "matlab",
    [string]$OutDir = "",
    [switch]$SkipCstCom
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($OutDir)) {
    $OutDir = Join-Path (Get-Location) "matlab-cst-probe"
}

New-Item -ItemType Directory -Path $OutDir -Force | Out-Null

$probeScript = Join-Path $OutDir "probe_matlab_cst_environment.m"
$jsonPath = Join-Path $OutDir "probe_result.json"
$logPath = Join-Path $OutDir "probe_matlab_output.log"

$skipText = "false";
if ($SkipCstCom) {
    $skipText = "true";
}

$matlabCode = @"
function probe_matlab_cst_environment()
result = struct();
result.timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
result.matlab_version = version;
result.matlab_release = version('-release');
result.platform = computer;
result.is_windows = ispc;
result.cst = struct();
result.cst.skip_com = $skipText;
result.cst.prog_id = '';
result.cst.com_started = false;
result.cst.new_mws = false;
result.cst.save_as = false;
result.cst.solver_object = false;
result.cst.version_text = '';
result.cst.errors = {};

if result.is_windows && ~result.cst.skip_com
    progIds = {'CSTStudio.Application', 'CSTStudio.application'};
    for k = 1:numel(progIds)
        try
            cst = actxserver(progIds{k});
            result.cst.prog_id = progIds{k};
            result.cst.com_started = true;
            break;
        catch ME
            result.cst.errors{end+1} = sprintf('%s: %s', progIds{k}, ME.message);
        end
    end

    if result.cst.com_started
        try
            try
                result.cst.version_text = char(invoke(cst, 'GetVersion'));
            catch
                result.cst.version_text = '';
            end
            mws = invoke(cst, 'NewMWS');
            result.cst.new_mws = true;
            try
                solver = invoke(mws, 'Solver');
                result.cst.solver_object = true;
                release(solver);
            catch ME
                result.cst.errors{end+1} = sprintf('Solver object: %s', ME.message);
            end
            try
                projectPath = fullfile('$($OutDir.Replace('\','\\'))', 'probe_empty_project.cst');
                invoke(mws, 'SaveAs', projectPath, 'True');
                result.cst.save_as = exist(projectPath, 'file') == 2;
            catch ME
                result.cst.errors{end+1} = sprintf('SaveAs: %s', ME.message);
            end
            try
                invoke(mws, 'Quit');
            catch
            end
        catch ME
            result.cst.errors{end+1} = sprintf('NewMWS: %s', ME.message);
        end
    end
end

write_json('$($jsonPath.Replace('\','\\'))', result);
disp(['PROBE_RESULT_JSON=' '$($jsonPath.Replace('\','\\'))']);
end

function write_json(path, value)
try
    txt = jsonencode(value);
catch
    txt = fallback_json(value);
end
fid = fopen(path, 'w');
if fid < 0
    error('Could not open probe result for writing: %s', path);
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s', txt);
end

function txt = fallback_json(value)
fields = fieldnames(value);
parts = cell(numel(fields), 1);
for i = 1:numel(fields)
    key = fields{i};
    val = value.(key);
    if ischar(val)
        parts{i} = sprintf('"%s":"%s"', key, escape_json(val));
    elseif islogical(val)
        if val
            parts{i} = sprintf('"%s":true', key);
        else
            parts{i} = sprintf('"%s":false', key);
        end
    else
        parts{i} = sprintf('"%s":"%s"', key, escape_json(evalc('disp(val)')));
    end
end
txt = ['{' strjoin(parts, ',') '}'];
end

function s = escape_json(s)
s = strrep(s, '\', '\\');
s = strrep(s, '"', '\"');
s = strrep(s, sprintf('\n'), '\n');
end
"@

Set-Content -LiteralPath $probeScript -Value $matlabCode -Encoding UTF8

$batchArgs = @("-batch", "run('$probeScript')")
& $MatlabCommand @batchArgs *> $logPath
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    Write-Warning "MATLAB -batch failed with exit code $exitCode. Trying legacy -r fallback."
    $legacyCommand = "try, run('$probeScript'), catch ME, disp(getReport(ME)), exit(1), end, exit(0)"
    & $MatlabCommand -nosplash -nodesktop -r $legacyCommand *> $logPath
    $exitCode = $LASTEXITCODE
}

if (Test-Path -LiteralPath $jsonPath) {
    Get-Content -LiteralPath $jsonPath -Raw
} else {
    Write-Error "Probe did not produce $jsonPath. See $logPath."
}

exit $exitCode
