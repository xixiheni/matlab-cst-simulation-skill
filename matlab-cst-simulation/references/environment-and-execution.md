# Environment And Execution

## Requirements

- Windows with MATLAB installed.
- CST Studio Suite installed and licensed.
- CST COM/ActiveX automation registered.
- A shell or agent environment allowed to start MATLAB and CST.
- A writable output directory outside original reference data.

## Environment Checks

In MATLAB, verify COM startup:

```matlab
cst = actxserver("CSTStudio.Application");
mws = invoke(cst, "NewMWS");
disp(class(mws));
```

If the ProgID fails, try the installation's documented ProgID casing or check Windows registry / CST repair registration. Agent-generated scripts should keep the ProgID in one variable near the top:

```matlab
cstProgId = "CSTStudio.Application";
cst = actxserver(cstProgId);
```

## Running From Agents

Prefer non-interactive MATLAB execution:

```powershell
& "C:\Program Files\MATLAB\R2026a\bin\matlab.exe" -batch "run('C:\path\to\build_project.m')"
```

For portable instructions, write:

```powershell
matlab -batch "run('C:\path\to\build_project.m')"
```

For scripts that operate on an existing project, pass the project path through an environment variable instead of hard-coding a local path:

```powershell
$env:CST_PROJECT_FILE = "C:\runs\antenna\antenna.cst"
matlab -batch "run('C:\runs\antenna\run_existing_project.m')"
```

If the agent sandbox cannot start MATLAB or CST, ask for permission to run outside the sandbox. Do not infer that the MATLAB/CST script is wrong solely from sandbox startup failure.

## Output Layout

Use a dedicated run directory:

```text
run-name/
  build_project.m
  run_solver.m
  project_name.cst
  project_name/
    Model/
    Result/
  exports/
    sparams.s2p
    efield_slice.txt
    summary.json
```

Keep original examples, PDFs, papers, and downloaded libraries read-only unless the user explicitly asks to edit them.

## Locking And SaveAs

CST commonly locks project files and generated project directories while open. Avoid these failure modes:

- Do not rebuild and `SaveAs` the same `.cst` while that project is open in CST.
- Use unique output filenames for revisions.
- Split project generation and solver execution into separate scripts for long runs.
- If an overwrite is required, close the CST project from CST or use a fresh output directory.

## Version Notes

Record MATLAB version, CST version, solver type, and frequency range in logs or project parameters. CST behavior can change across versions, especially around solver defaults, monitor syntax, meshing, and imported project compatibility.
