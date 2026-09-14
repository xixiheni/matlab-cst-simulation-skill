# MATLAB CST Simulation Skill

[简体中文](README.md)

[![Skill](https://img.shields.io/badge/Codex%20Skill-matlab--cst--simulation-blue)](matlab-cst-simulation/SKILL.md)
[![MATLAB](https://img.shields.io/badge/MATLAB-CST%20Automation-orange)](matlab-cst-simulation/examples)
[![Platform](https://img.shields.io/badge/platform-Windows%20COM-lightgrey)](matlab-cst-simulation/references/environment-and-execution.md)

A reusable skill for Codex and other coding agents that extracts CST modeling parameters from papers, creates a traceable modeling plan, and automates CST Studio Suite through MATLAB. It can build or modify CST projects, prepare simulation settings, validate generated models, run authorized solver jobs, export results, and compare the requested result with the source paper.

![MATLAB CST Simulation Skill workflow](assets/workflow.svg)

## Capabilities

- Read papers, supplements, figures, and partial modeling specifications.
- Ask which figure, table, model, or result to reproduce when the target is not specified.
- Keep initial, optimized, simulated, fabricated, measured, and parameter-sweep model versions separate.
- Extract geometry, materials, boundaries, excitations, ports, frequencies, monitors, solver settings, and result definitions.
- Record parameter sources and statuses as `confirmed`, `estimated`, `assumed`, or `missing`.
- Produce a detailed modeling plan before generating MATLAB/CST code.
- Control CST through MATLAB COM/ActiveX and durable CST VBA history commands.
- Validate the generated CST project before solver execution.
- Export S-parameters, fields, farfield data, images, logs, and other agent-readable results.
- Compare resonances, bandwidth, trends, beam direction, focus position, or field distributions with the paper.

## Installation

Run the following commands in **Windows PowerShell**, not on the GitHub website:

```powershell
git clone https://github.com/xixiheni/matlab-cst-simulation-skill.git
Copy-Item -Path .\matlab-cst-simulation-skill\matlab-cst-simulation `
  -Destination "$env:USERPROFILE\.codex\skills\matlab-cst-simulation" `
  -Recurse -Force
```

The skill will be installed at:

```text
C:\Users\<your-user-name>\.codex\skills\matlab-cst-simulation
```

## Usage

Paper reproduction:

```text
Use $matlab-cst-simulation to read this paper, reproduce Fig. 6, extract all CST modeling parameters, write a traceable modeling plan, build the CST project, and reproduce the requested result.
```

New model:

```text
Use $matlab-cst-simulation to create a MATLAB script that builds a CST antenna model, configures ports and monitors, validates the project, and prepares a separate solver run script.
```

Existing project:

```text
Use $matlab-cst-simulation to open this CST project, change the specified parameters, run a parameter sweep, and export Touchstone results.
```

## Workflow

1. Identify the requested figure, table, model, or result. Ask only when the target is missing.
2. Probe the MATLAB-CST environment before actual execution.
3. Match the target to the correct paper model version.
4. Extract every result-sensitive parameter with its source and confidence status.
5. Ask only about unresolved values that materially affect the requested result.
6. Finalize a detailed modeling plan.
7. Generate separate MATLAB build and run scripts.
8. Build and validate the CST project.
9. Run the solver when full result reproduction was requested; otherwise ask before launch.
10. Inspect logs, export results, and compare the requested features with the paper.

## Requirements

- Windows for CST COM/ActiveX execution
- MATLAB
- CST Studio Suite
- Registered CST automation interface
- A valid CST license for the requested solver

The skill can still help generate MATLAB/CST scripts on other operating systems, but it must not claim that CST COM automation was executed there.

## Compatibility Strategy

The skill does not claim universal compatibility with every MATLAB and CST release. It probes the installed environment, prefers conservative MATLAB syntax and inspectable CST history commands, preserves the physical meaning of the source model when using fallbacks, and reports detected versions, failed commands, warnings, and remaining assumptions.

Environment probe:

```powershell
powershell -ExecutionPolicy Bypass -File .\matlab-cst-simulation\scripts\probe-matlab-cst.ps1
```

## Repository Layout

```text
assets/
  workflow.svg
  workflow.png
  example.png
matlab-cst-simulation/
  SKILL.md
  agents/
  examples/
  references/
  scripts/
CHANGELOG.md
README.md
README.en.md
```

## Notes

This repository does not include MATLAB, CST Studio Suite, CST documentation, or third-party MATLAB-CST interface libraries. Actual execution depends on the locally installed MATLAB/CST versions, COM registration, solver modules, and license permissions.
