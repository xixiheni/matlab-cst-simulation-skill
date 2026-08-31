# Parameter Extraction Template

Use this template when extracting CST modeling information from a paper, supplement, figure, screenshot, or partial specification.

Keep the table source-traceable. Do not hide guessed or inferred values in code.

## Parameter Table

```markdown
| Parameter ID | Value | Unit | Source | Confidence | Used in CST | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| freq_center | 12 | GHz | paper caption | high | Solver.FrequencyRange, monitors | Example only |
| substrate_eps_r | TBD | 1 | missing | blocking | Material definition | Ask user before build |
```

Recommended `Source` values:

```text
paper
supplement
caption
equation
table
figure-estimated
inferred
user-provided
assumed
missing
```

Recommended `Confidence` values:

```text
high
medium
low
blocking
```

Use stable parameter IDs that can become MATLAB variable names:

```text
freq_min_ghz
freq_max_ghz
substrate_eps_r
substrate_thickness_mm
metal_thickness_mm
period_x_mm
period_y_mm
array_count_x
array_count_y
boundary_xmin
excitation_type
monitor_field_component
```

## Missing-Parameter Question Table

```markdown
| Question ID | Missing item | Why it matters | Proposed fallback | Blocks build? | User answer |
| --- | --- | --- | --- | --- | --- |
| q001 | substrate permittivity | Changes resonance and wave velocity | Use eps_r = 2.2 only for a rough geometry test | yes |  |
```

## Source Evidence Table

```markdown
| Evidence ID | Location in source | Extracted fact | Interpretation | Confidence |
| --- | --- | --- | --- | --- |
| e001 | Fig. 2 caption | Unit cell period is 4.8 mm | Use p = 4.8 mm along x | high |
```

## CST Mapping Table

```markdown
| Parameter ID | CST object/command | MATLAB variable | Validation check |
| --- | --- | --- | --- |
| substrate_thickness_mm | Brick.Zrange | substrateThicknessMm | Model.mod contains expected Zrange |
| freq_min_ghz | Solver.FrequencyRange | freqMinGhz | Model.log reports frequency range |
```

## Extraction Rules

- Preserve units from the source and add converted values only in separate rows or notes.
- If a value is estimated from a plot or image, say how it was estimated.
- If a formula generates a parameter table, save that derived table as CSV and reference it from the modeling plan.
- Distinguish first-pass approximations from final reproduction values.
- Use `TBD` only for values that must be answered before build or solver execution.
