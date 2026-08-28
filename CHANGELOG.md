# Changelog

## v0.1.0

Initial public release target for `matlab-cst-simulation`.

### Added

- Codex/agent skill for MATLAB-driven CST Studio Suite automation.
- Guidance for creating and opening `.cst` projects through COM/ActiveX.
- CST VBA history patterns for units, frequency ranges, boundaries, geometry, excitations, monitors, and solver setup.
- Explicit confirmation rule before launching CST solvers.
- Version-adaptive compatibility guidance for different MATLAB and CST releases.
- Example MATLAB scripts for building a basic CST project and running an existing project.
- PowerShell helpers for checking generated CST project folders and parsing CST solver logs.

### Notes

- The skill does not bundle MATLAB, CST Studio Suite, CST documentation, or third-party MATLAB-CST libraries.
- Exact execution behavior depends on the installed MATLAB version, CST version, solver modules, COM registration, and license features.
