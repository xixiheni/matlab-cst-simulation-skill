# Version Compatibility

Use this reference when the target MATLAB or CST Studio Suite version is unknown, old, or intended to vary across users.

## Compatibility Goal

Aim for version-adaptive automation, not universal guarantees. A good script should identify the local environment, choose conservative MATLAB and CST automation patterns, then report exactly what was tested or assumed.

## Environment Probe

Before relying on version-sensitive behavior, generate or run a small probe that checks:

- Windows host availability for COM/ActiveX.
- MATLAB version from `version` and installed products from `ver`.
- Whether `actxserver('CSTStudio.Application')` works; if not, try `actxserver('CSTStudio.application')`.
- Whether CST can create a new MWS project or open the target `.cst` file.
- Whether the project can be saved to a writable output directory.
- Whether the solver object can be obtained with `invoke(mws, 'Solver')`.

Keep probes read-only or use a disposable output directory unless the user approved changes to a real project.

## MATLAB Compatibility

- Prefer char arrays and `sprintf` in shared examples because they work across more MATLAB releases than string-array-only code.
- Avoid `isfile`, `strlength`, and string concatenation with `+` in broad-compatibility examples; use `exist(path, 'file')`, `isempty`, `strcat`, `sprintf`, or cell/char assembly instead.
- Use `matlab -batch` when available. For older MATLAB versions, provide a fallback command such as `matlab -nosplash -nodesktop -r "try, run(''script.m''), catch ME, disp(getReport(ME)), exit(1), end, exit(0)"`.
- Keep local functions at the end of scripts when targeting releases that support them. If a user reports an older MATLAB release that rejects local script functions, split helpers into separate `.m` function files.

## CST Compatibility

- Prefer CST history/VBA commands through `AddToHistory` for durable model setup. They are easier to inspect and often survive version differences better than direct object method chains.
- Use common command families first: units, frequency range, materials, bricks, transforms, boundary settings, excitations, monitors, solver selection, save/open, and result export.
- Avoid relying on a single result tree path without checking generated files and logs. CST result folder names can differ by solver type, project setup, and release.
- When a CST method or history command fails, report the failing command block and generate an alternate block only if the equivalent CST concept is clear.
- Treat solver type names, boundary names, monitor field names, and export paths as version-sensitive strings. Prefer user-provided known-good names when available.

## Fallback Behavior

If version probing fails, do not claim the simulation was run. Produce:

- The generated MATLAB script.
- The exact command attempted or recommended.
- The failing COM/VBA command or MATLAB error.
- The version assumptions used.
- A short manual check the user can perform in CST.

If the build succeeds but the solver cannot start, preserve the `.cst` project and ask whether to continue debugging the run step.

## Public Skill Examples

For examples intended for GitHub or other users:

- Avoid hardcoding one user's CST install path, MATLAB release, license server, or project directory.
- Use environment variables for user-specific paths such as `CST_PROJECT_FILE`.
- Keep scripts safe to inspect before running solver work.
- Mention that exact behavior depends on MATLAB release, CST release, installed solvers, and available license features.
