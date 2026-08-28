# Geometry VBA Patterns

## Recommended Style

Use small MATLAB helper functions for repeated CST geometry primitives. Helpers should either call CST COM objects directly or assemble a VBA history block and call:

```matlab
invoke(mws, "AddToHistory", "history label", sCommand);
```

History blocks make the CST project inspectable in `Model/3D/Model.mod` and easier to debug than a long sequence of direct object calls with no CST history entry.

## Units And Frequency

```matlab
function defineUnits(mws, geometryUnit, frequencyUnit, timeUnit, temperatureUnit)
s = "";
s = s + "With Units" + newline;
s = s + ".Geometry """ + geometryUnit + """" + newline;
s = s + ".Frequency """ + frequencyUnit + """" + newline;
s = s + ".Time """ + timeUnit + """" + newline;
s = s + ".TemperatureUnit """ + temperatureUnit + """" + newline;
s = s + "End With";
invoke(mws, "AddToHistory", "define units", char(s));
end
```

```matlab
function defineFrequencyRange(mws, fmin, fmax)
s = sprintf("Solver.FrequencyRange ""%g"", ""%g""", fmin, fmax);
invoke(mws, "AddToHistory", "define frequency range", s);
end
```

## Brick Helper

```matlab
function addBrick(mws, name, component, material, xrange, yrange, zrange)
s = "";
s = s + "With Brick" + newline;
s = s + ".Reset" + newline;
s = s + ".Name """ + name + """" + newline;
s = s + ".Component """ + component + """" + newline;
s = s + ".Material """ + material + """" + newline;
s = s + sprintf(".Xrange ""%g"", ""%g""\n", xrange(1), xrange(2));
s = s + sprintf(".Yrange ""%g"", ""%g""\n", yrange(1), yrange(2));
s = s + sprintf(".Zrange ""%g"", ""%g""\n", zrange(1), zrange(2));
s = s + ".Create" + newline;
s = s + "End With";
invoke(mws, "AddToHistory", "define brick: " + component + ":" + name, char(s));
end
```

## Transform Helper

Rotate around a specified center:

```matlab
function rotateShape(mws, fullName, center, angleDeg)
s = "";
s = s + "With Transform" + newline;
s = s + ".Reset" + newline;
s = s + ".Name """ + fullName + """" + newline;
s = s + ".Origin ""Free""" + newline;
s = s + sprintf(".Center ""%g"", ""%g"", ""%g""\n", center(1), center(2), center(3));
s = s + sprintf(".Angle ""%g"", ""%g"", ""%g""\n", angleDeg(1), angleDeg(2), angleDeg(3));
s = s + ".MultipleObjects ""False""" + newline;
s = s + ".Repetitions ""1""" + newline;
s = s + ".Transform ""Shape"", ""Rotate""" + newline;
s = s + "End With";
invoke(mws, "AddToHistory", "rotate shape: " + fullName, char(s));
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
