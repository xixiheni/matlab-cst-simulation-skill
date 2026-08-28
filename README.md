# MATLAB CST Simulation Skill

A Codex/agent skill for automating CST Studio Suite simulations from MATLAB.

This repository contains a reusable skill that helps coding agents create, run, inspect, and validate MATLAB scripts that control CST Studio Suite through Windows COM/ActiveX and CST VBA history commands.

## What This Skill Helps With

- Create new CST projects from MATLAB.
- Open and modify existing `.cst` projects.
- Define units, frequency ranges, materials, geometry, boundaries, excitations, and monitors.
- Run CST solvers from MATLAB.
- Export S-parameters, farfield data, field slices, images, or other result files.
- Inspect CST-generated project files and solver logs.
- Use `TCSTInterface`-style workflows for existing projects and result extraction.

## Repository Layout

```text
matlab-cst-simulation/
  SKILL.md
  agents/
    openai.yaml
  references/
    environment-and-execution.md
    geometry-vba-patterns.md
    simulation-setup.md
    tcstinterface.md
    validation.md
  scripts/
    check-cst-project.ps1
    parse-cst-log.ps1
  examples/
    build-basic-plane-wave-project.m
    run-existing-project.m
```

## Requirements

- Windows
- MATLAB
- CST Studio Suite
- CST COM/ActiveX automation registered
- A valid CST license

The skill can still help generate scripts on non-Windows systems, but CST COM automation requires Windows.

## Installation

Copy or install the `matlab-cst-simulation/` folder as a skill in your agent environment.

For Codex-style local skills, place the folder under your skills directory, for example:

```text
~/.codex/skills/matlab-cst-simulation/
```

The required entrypoint is:

```text
matlab-cst-simulation/SKILL.md
```

## Example Use

```text
Use $matlab-cst-simulation to create a MATLAB script that builds a CST patch antenna model, adds a waveguide port and E-field monitor, runs the solver, and exports S11.
```

```text
Use $matlab-cst-simulation to inspect this existing CST project, change two parameters, run a sweep, and export Touchstone files.
```

## Notes

This skill does not bundle CST Studio Suite, MATLAB, CST official documentation, or third-party CST-MATLAB interface libraries. If you use external code such as `CSTMWS-Matlab-Interface`, follow its upstream license.

