---
name: matlab-cst-simulation
description: Automate CST Studio Suite from MATLAB for electromagnetic simulation workflows. Use when creating or editing version-adaptive MATLAB scripts that drive CST through COM/ActiveX or generated VBA history commands, including building CST projects, editing parameters, defining units/materials/boundaries/excitations/monitors, running solvers, exporting S-parameters or fields, checking CST logs, or post-processing CST results. Do not use for pure MATLAB analysis with no CST automation.
---

# MATLAB CST Simulation

## Overview

Use this skill to make MATLAB-driven CST work repeatable across different installations: create or open `.cst` projects, define simulation setup, run solvers, export results, and verify the generated CST artifacts. Prefer scripts over GUI-only steps so the workflow can be rerun by Codex, Claude Code, Copilot agents, or a human from the command line.

## First Choices

- For a new CST model, generate a MATLAB build script that creates the project with `actxserver('CSTStudio.Application')`, `NewMWS`, and CST history commands.
- For an existing CST project, use MATLAB to open the `.cst`, inspect/change parameters, run the solver, and export results.
- For unknown MATLAB or CST versions, generate conservative code that probes capabilities first, uses stable COM/VBA history patterns, and reports any fallback instead of assuming a specific release. Read [references/version-compatibility.md](references/version-compatibility.md).
- For result reading and parameter sweeps, prefer a maintained MATLAB-CST interface class when the project already has results. Read [references/tcstinterface.md](references/tcstinterface.md).
- For geometry construction, use small MATLAB helper functions that wrap CST objects or `AddToHistory` commands. Read [references/geometry-vba-patterns.md](references/geometry-vba-patterns.md).
- For excitation, monitors, solver setup, and export commands, write explicit CST VBA history blocks from MATLAB. Read [references/simulation-setup.md](references/simulation-setup.md).
- Before claiming success, inspect project files and solver logs. Use [scripts/check-cst-project.ps1](scripts/check-cst-project.ps1) and [scripts/parse-cst-log.ps1](scripts/parse-cst-log.ps1), or reproduce their checks manually.

## Core Workflow

1. Establish the environment: confirm Windows, MATLAB, CST Studio Suite, CST COM registration, writable output directory, and expected CST version. When the versions are unknown, include a small diagnostic/probe step before generating version-sensitive commands.
2. Keep sources and outputs separate. Copy templates or examples into a new output/work directory before modifying them.
3. Generate a build script for the `.cst` project. Include units, frequency range, solver type, background, boundaries, materials, geometry, excitation, and monitors.
4. Save the CST project under a new, descriptive filename. Avoid overwriting an open `.cst`.
5. Generate a separate run script for solver execution when the solver may be slow or when `SaveAs` locking is likely.
6. After modeling and simulation setup are complete, pause before starting any CST solver and ask the user once whether they want you to run the simulation now. Include the generated project path, run script or command, and any obvious time/licensing risk. Start the solver only after an affirmative reply, unless the user has already given explicit run permission for this exact project in the current request.
7. Run MATLAB non-interactively where possible, for example `matlab -batch "run('path/to/script.m')"`.
8. Inspect generated CST files before solving: `Model/3D/Model.mod` for history/setup and `Model/3D/Model.dsn` for ports and design metadata.
9. After solving, inspect `Result/Model.log` for solver start, frequency settings, boundaries, warnings, completion, mesh cells, and generated result files.
10. Export data in agent-readable formats when possible: Touchstone, CSV/TXT ASCII field slices, images, or `.mat` files.
11. Summarize uncertainty. CST warnings about boundaries, memory, port modes, monitor frequency, or farfield validity often mean "usable with caveats", not "failed".

## MATLAB COM Skeleton

Use this as the minimal shape for new scripts, adapting names and setup:

```matlab
clc;
clear;

outputDir = fullfile(pwd, 'cst-output');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

cst = actxserver('CSTStudio.Application');
mws = invoke(cst, 'NewMWS');

invoke(mws, 'AddToHistory', 'select solver', 'ChangeSolverType "HF Time Domain"');

% Add project setup and geometry here.
% Prefer helper functions for repeated geometry, and raw VBA history blocks
% for setup commands that are not covered by helpers.

projectFile = fullfile(outputDir, 'example_project.cst');
invoke(mws, 'SaveAs', projectFile, 'True');
fprintf('CST_PROJECT=%s\n', projectFile);
```

Run an existing project separately. Pass the target project through an environment variable so agents can reuse the script without editing it:

```matlab
clc;
clear;

cstFile = getenv('CST_PROJECT_FILE');
if isempty(cstFile) || exist(cstFile, 'file') ~= 2
    error('Set CST_PROJECT_FILE to an existing .cst project path.');
end

cst = actxserver('CSTStudio.Application');
invoke(cst, 'OpenFile', cstFile);
mws = invoke(cst, 'Active3D');
solver = invoke(mws, 'Solver');

fprintf('CST_SOLVER_START=%s\n', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
invoke(solver, 'Start');
fprintf('CST_SOLVER_DONE=%s\n', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
invoke(mws, 'Save');
release(solver);
```

## Practical Rules

- Use Windows for CST COM automation. On non-Windows systems, generate scripts but do not claim they were executed through CST COM.
- Use the exact COM ProgID that works in the target installation. Common variants are `CSTStudio.Application` and `CSTStudio.application`.
- Optimize for broad version compatibility unless the user names a target release. Prefer MATLAB char arrays and `sprintf` over newer string-only idioms in shared examples, and probe command availability before relying on release-specific CST methods.
- Do not claim a workflow supports all MATLAB/CST versions. Say which version was tested, which commands are conservative, and where a fallback may be needed.
- Keep build and run scripts separate for long simulations. This prevents accidentally rebuilding and overwriting a project that CST still has open.
- Prefer `AddToHistory` for durable CST state. Direct object `invoke` calls can be useful, but history commands make generated projects easier to inspect and replay.
- Use quotes carefully in VBA strings. MATLAB string assembly bugs are common around CST enum values such as `"expanded open"`, `"unit cell"`, `"Efield"`, and `"Farfield"`.
- Do not treat farfield plots as authoritative when CST reports invalid farfield monitor conditions or periodic-boundary material mismatch. Report the warning and use near-field/port data where appropriate.
- Store a short parameter note in the project history for generated projects: purpose, frequency band, units, solver, excitation, and script name.
- Treat CST solver execution as an explicit user-approved action. When only project generation or setup was requested, finish by asking whether to run the prepared simulation instead of launching it silently.
- When CST or MATLAB fails under a sandboxed agent, rerun with the user's approval in a normal desktop/host environment rather than rewriting the workflow around the sandbox.

## Reference Routing

- Read [references/environment-and-execution.md](references/environment-and-execution.md) when setting up a machine, debugging COM startup, or deciding how to run MATLAB from an agent.
- Read [references/version-compatibility.md](references/version-compatibility.md) when the user's MATLAB/CST versions are unknown, old, mixed across machines, or when generating a skill/example intended for public reuse.
- Read [references/geometry-vba-patterns.md](references/geometry-vba-patterns.md) when creating materials, bricks, rotations, translations, arrays, or CST history helper functions.
- Read [references/simulation-setup.md](references/simulation-setup.md) when defining boundaries, solver type, excitations, ports, monitors, or exports.
- Read [references/tcstinterface.md](references/tcstinterface.md) when using the open-source `TCSTInterface` style workflow for existing CST projects, S/Z parameters, Touchstone, farfield, images, STL, or optimization cost functions.
- Read [references/validation.md](references/validation.md) before finalizing generated projects or solver results.

## Final Response Expectations

Report the generated files, detected or assumed MATLAB/CST versions, the command used or prepared for MATLAB, whether the user approved solver execution, whether CST actually solved, the key warnings from `Result/Model.log`, and what data was exported. If solver execution was not run, say exactly which scripts/project files are ready to run and ask whether the user wants you to run the simulation now.
