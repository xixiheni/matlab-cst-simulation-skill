clc;
clear;

cstFile = string(getenv("CST_PROJECT_FILE"));
if strlength(cstFile) == 0 || ~isfile(cstFile)
    error("Set CST_PROJECT_FILE to an existing .cst project path.");
end

cst = actxserver("CSTStudio.Application");
invoke(cst, "OpenFile", cstFile);
mws = invoke(cst, "Active3D");
solver = invoke(mws, "Solver");

fprintf("CST_SOLVER_START=%s FILE=%s\n", datestr(now, "yyyy-mm-dd HH:MM:SS"), cstFile);
invoke(solver, "Start");
fprintf("CST_SOLVER_DONE=%s FILE=%s\n", datestr(now, "yyyy-mm-dd HH:MM:SS"), cstFile);

invoke(mws, "Save");
release(solver);
