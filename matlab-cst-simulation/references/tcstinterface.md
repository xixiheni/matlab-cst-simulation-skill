# TCSTInterface Workflows

`TCSTInterface` is an open-source MATLAB class pattern for controlling existing CST Microwave Studio projects and reading results through Windows COM. Use it when a project already exists or when you need a richer result API than raw CST VBA calls.

## What It Is Good For

- Opening, closing, and connecting to CST projects.
- Reading, storing, and changing model parameters.
- Running solvers with retry/skip behavior.
- Enumerating result tree items.
- Reading 1D results.
- Reading S-parameters and Z-parameters as MATLAB arrays.
- Exporting Touchstone files.
- Exporting farfield results.
- Enumerating monitors.
- Inspecting object names, materials, colors, volumes, and masses.
- Exporting images or STL geometry.
- Preparing a CST optimizer to call a MATLAB cost function.

## Basic Use

```matlab
addpath("path\to\CSTMWS-Matlab-Interface\Functions");

CST = TCSTInterface("C:\path\to\project.cst");
CST.OpenProject("C:\path\to\project.cst");
CST.ChangeParameter("gap_mm", 0.8, true);
CST.Solve("SkipIfSolutionExists", false, "NumberOfTries", 1);
[S, freq, zref, info] = CST.GetSParams(0);
CST.ExportTouchstone("C:\path\to\exports\project.s2p", 50);
```

Adapt the exact calling syntax to the installed version of the interface.

## When Not To Use It

For programmatic geometry generation from scratch, raw CST VBA history helper functions may be simpler. `TCSTInterface` is strongest for controlling and extracting from an existing model; geometry-heavy model creation still benefits from custom `AddToHistory` helpers.

## Result Tree Strategy

Before reading a result by path:

1. Enumerate the result tree.
2. Confirm the exact tree item string.
3. Check available Run IDs when using parametric sweeps.
4. Query at explicit frequencies only after confirming units and frequency grid.

## MATLAB Cost Function Pattern

When CST optimization calls MATLAB, the MATLAB function should:

- Accept the CST project path/name as supplied by CST.
- Instantiate the interface for that project.
- Read the needed result, such as S11 at a target frequency.
- Return one real, finite scalar `double`.
- Assert scalar, numeric, real, finite, not `NaN`.

Do not bury plotting or file export failures inside the cost value. Keep the scalar objective robust and log side outputs separately.

## Licensing Note

If bundling third-party MATLAB-CST interface code in a public skill repository, preserve its license and copyright notices. When possible, reference the upstream repository instead of copying the whole library into the skill.
