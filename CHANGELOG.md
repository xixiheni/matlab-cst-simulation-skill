# Changelog

## v0.1.0

Initial public release target for `matlab-cst-simulation`.

### Added

- Codex/agent skill for MATLAB-driven CST Studio Suite automation.
- Paper-to-model workflow for extracting reproduction targets, parameters, assumptions, missing values, and CST setup steps before building.
- Explicit target-selection question after a paper is supplied when the user has not named the figure, table, model, or result to reproduce.
- Source-traceable parameter extraction template for paper reproduction workflows.
- Missing-parameter question strategy that separates blocking, run-blocking, nonblocking, and cosmetic values.
- MATLAB/CST environment probe script for checking MATLAB startup, CST COM ProgID, NewMWS, SaveAs, and solver-object access.
- Guidance for creating and opening `.cst` projects through COM/ActiveX.
- CST VBA history patterns for units, frequency ranges, boundaries, geometry, excitations, monitors, and solver setup.
- Explicit confirmation rule before launching CST solvers.
- Version-adaptive compatibility guidance for different MATLAB and CST releases.
- Example MATLAB scripts for building a basic CST project and running an existing project.
- PowerShell helpers for checking generated CST project folders and parsing CST solver logs.

### Notes

- The skill does not bundle MATLAB, CST Studio Suite, CST documentation, or third-party MATLAB-CST libraries.
- Exact execution behavior depends on the installed MATLAB version, CST version, solver modules, COM registration, and license features.
