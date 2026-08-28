# Geometry VBA Patterns

## Recommended Style

Use small MATLAB helper functions for repeated CST geometry primitives. Helpers should either call CST COM objects directly or assemble a VBA history block and call:

```matlab
invoke(mws, 'AddToHistory', 'history label', sCommand);
```

History blocks make the CST project inspectable in `Model/3D/Model.mod` and easier to debug than a long sequence of direct object calls with no CST history entry.

## Units And Frequency

```matlab
function defineUnits(mws, geometryUnit, frequencyUnit, timeUnit, temperatureUnit)
s = sprintf(['With Units\n' ...
    '.Geometry "%s"\n' ...
    '.Frequency "%s"\n' ...
    '.Time "%s"\n' ...
    '.TemperatureUnit "%s"\n' ...
    'End With'], geometryUnit, frequencyUnit, timeUnit, temperatureUnit);
invoke(mws, 'AddToHistory', 'define units', s);
end
```

```matlab
function defineFrequencyRange(mws, fmin, fmax)
s = sprintf('Solver.FrequencyRange "%g", "%g"', fmin, fmax);
invoke(mws, 'AddToHistory', 'define frequency range', s);
end
```

## Brick Helper

```matlab
function addBrick(mws, name, component, material, xrange, yrange, zrange)
s = sprintf(['With Brick\n' ...
    '.Reset\n' ...
    '.Name "%s"\n' ...
    '.Component "%s"\n' ...
    '.Material "%s"\n' ...
    '.Xrange "%g", "%g"\n' ...
    '.Yrange "%g", "%g"\n' ...
    '.Zrange "%g", "%g"\n' ...
    '.Create\n' ...
    'End With'], name, component, material, xrange(1), xrange(2), yrange(1), yrange(2), zrange(1), zrange(2));
invoke(mws, 'AddToHistory', sprintf('define brick: %s:%s', component, name), s);
end
```

## Transform Helper

Rotate around a specified center:

```matlab
function rotateShape(mws, fullName, center, angleDeg)
s = sprintf(['With Transform\n' ...
    '.Reset\n' ...
    '.Name "%s"\n' ...
    '.Origin "Free"\n' ...
    '.Center "%g", "%g", "%g"\n' ...
    '.Angle "%g", "%g", "%g"\n' ...
    '.MultipleObjects "False"\n' ...
    '.Repetitions "1"\n' ...
    '.Transform "Shape", "Rotate"\n' ...
    'End With'], fullName, center(1), center(2), center(3), angleDeg(1), angleDeg(2), angleDeg(3));
invoke(mws, 'AddToHistory', sprintf('rotate shape: %s', fullName), s);
end
```

## Materials

Use CST built-ins such as `PEC` when appropriate. For ordinary dielectric materials, define at least relative permittivity, relative permeability, and conductivity. Keep names descriptive and avoid spaces if scripts will later parse object names.

## Array Generation

For metasurfaces, phased arrays, frequency selective surfaces, and repeated unit cells:

- Store array-driving values in MATLAB arrays, tables, CSV, or spreadsheets.
- Build one clear unit-cell function first.
- Build the array by looping over row/column indices and translating the unit geometry coordinates.
- Use deterministic object names such as `cell_003_014_patch` to make debugging and selection possible.
- Rotate each element around its own center unless the design intentionally rotates around the global origin.
- Generate a companion CSV that records index, center coordinates, dimensions, rotation angle, material, and any phase target.

## Common Geometry Pitfalls

- Zero-thickness metal sheets may be visually convenient but can confuse meshing or exports. Use a small physical thickness when possible.
- Check coordinate conventions before translating paper formulas into CST. Row/column order, x/y sign, and rotation sign are easy to invert.
- CST boolean operations typically keep one input name. Name intermediate solids so later operations do not target stale object names.
- After generating large arrays, zoom to structure and save; then inspect the CST model history and object count before solving.
