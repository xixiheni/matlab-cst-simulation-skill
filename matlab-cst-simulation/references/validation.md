# Validation

## Before Running The Solver

Inspect the generated CST project directory when available:

- `Model/3D/Model.mod`: CST history commands, solver type, units, frequency range, boundaries, excitations, monitors.
- `Model/3D/Model.dsn`: ports, labels, design metadata.
- Project folder name matching the `.cst` file stem.
- Expected generated scripts and exported parameter tables.

Use:

```powershell
scripts/check-cst-project.ps1 -ProjectFile "C:\path\to\project.cst"
```

## Solver Log Checks

Inspect `Result/Model.log` after a run. Required signals:

- Solver started.
- Solver module and CST version.
- Expected stimulation/excitation.
- Units settings.
- Boundary conditions.
- Frequency settings.
- Mesh statistics.
- Solver finished successfully or a clear failure reason.
- Generated requested result files.

Use:

```powershell
scripts/parse-cst-log.ps1 -LogFile "C:\path\to\project\Result\Model.log"
```

## Warning Interpretation

Treat warnings as evidence to report, not noise to hide.

- Boundary warnings may change physical validity.
- Farfield warnings may make farfield plots trend-only.
- Monitor frequency warnings may mean missing or ignored monitors.
- Memory warnings may make runtimes unstable or results incomplete.
- Port-mode warnings can invalidate S-parameters.

## Result Existence

Common successful outputs include:

- `Result/Model.log`
- `Result/Model.res`
- monitor-specific field result files
- Touchstone exports
- ASCII field exports
- farfield exports

Do not claim a monitor result exists based only on script intent. Confirm files or result tree entries.

## Physics Sanity Checks

For electromagnetic structures, add at least one task-specific sanity check:

- S-parameter magnitude and phase in expected frequency range.
- Energy balance or obvious passivity check where applicable.
- Near-field slice at a meaningful plane.
- Farfield main lobe direction only when boundary/setup warnings allow it.
- Mesh cell count and runtime within plausible range for the model size.
- Comparison against a known small model, literature value, or previous run when available.

## Final Reporting

A useful final report includes:

- Generated `.m` scripts and `.cst` project paths.
- MATLAB command actually executed.
- CST solver status.
- Key warnings.
- Exported result paths.
- What was verified and what still requires CST GUI or domain review.
