# Simulation Setup

## Solver Type

Set solver type explicitly. Example:

```matlab
invoke(mws, 'AddToHistory', 'select time domain solver', ...
    'ChangeSolverType "HF Time Domain"');
```

Record solver choice in generated output notes. Time-domain, frequency-domain, eigenmode, and integral solvers differ in supported excitations and monitor behavior.

## Boundaries

Define all six boundaries explicitly:

```matlab
function defineBoundaries(mws, xmin, xmax, ymin, ymax, zmin, zmax)
s = sprintf(['With Boundary\n' ...
    '.Xmin "%s"\n' ...
    '.Xmax "%s"\n' ...
    '.Ymin "%s"\n' ...
    '.Ymax "%s"\n' ...
    '.Zmin "%s"\n' ...
    '.Zmax "%s"\n' ...
    'End With'], xmin, xmax, ymin, ymax, zmin, zmax);
invoke(mws, 'AddToHistory', 'define boundaries', s);
end
```

Common values include `"expanded open"`, `"open"`, `"electric"`, `"magnetic"`, `"periodic"`, and `"unit cell"`. Use the target CST version's accepted spelling.

Boundary choices are part of the physics, not boilerplate. Include a short comment explaining why periodic, unit cell, PEC/PMC, or open boundaries are used.

## Plane Wave

```matlab
function addPlaneWave(mws, normalVec, eVec)
s = sprintf(['With PlaneWave\n' ...
    '.Reset\n' ...
    '.Normal "%g", "%g", "%g"\n' ...
    '.EVector "%g", "%g", "%g"\n' ...
    '.Store\n' ...
    'End With'], normalVec(1), normalVec(2), normalVec(3), eVec(1), eVec(2), eVec(3));
invoke(mws, 'AddToHistory', 'define plane wave', s);
end
```

After solving, check the log for the actual stimulation and any decoupling or mirror-plane messages.

## Waveguide Port

For port-driven structures, define port number, modes, orientation, and coordinate ranges explicitly. After building the project, inspect `Model/3D/Model.dsn`; do not rely only on the GUI.

Minimum checks:

- Expected number of ports.
- Expected port labels.
- Orientation matches the intended propagation direction.
- Port ranges touch the intended boundary or face.
- Number of modes matches the analysis plan.

## Field And Farfield Monitors

Frequency-domain field monitor pattern:

```matlab
function addFrequencyMonitor(mws, fieldType, freqGHz)
name = sprintf('%s_%gGHz', fieldType, freqGHz);
s = sprintf(['With Monitor\n' ...
    '.Reset\n' ...
    '.Name "%s"\n'], name);
if ~strcmp(fieldType, 'Farfield')
    s = [s sprintf('.Dimension "Volume"\n')];
end
s = [s sprintf(['.Domain "Frequency"\n' ...
    '.FieldType "%s"\n' ...
    '.Frequency "%g"\n' ...
    '.Create\n' ...
    'End With'], fieldType, freqGHz)];
invoke(mws, 'AddToHistory', sprintf('define monitor: %s', name), s);
end
```

Typical `fieldType` values include `"Efield"`, `"Hfield"`, `"Powerflow"`, `"Current"`, and `"Farfield"`.

Monitor frequencies must lie inside the solver frequency range. If they are outside the range, CST may ignore them or produce misleading partial output.

## Farfield Cautions

Farfield monitors are sensitive to boundaries and problem setup. If CST warns that farfield results may be inaccurate, report the warning and prefer near-field, port, or exported field-slice checks for primary validation. Do not hide farfield caveats.

## Exports

Prefer exports that other tools and agents can inspect:

- Touchstone (`.s1p`, `.s2p`, etc.) for S-parameters.
- ASCII field slices (`.txt`, `.csv`) for near-field checks.
- Farfield text/mat exports when supported.
- PNG/JPEG screenshots only as supplemental evidence.

When exporting a field slice through CST ASCII export, record the selected result tree item, component, coordinate ranges, sampling mode, and output filename.
