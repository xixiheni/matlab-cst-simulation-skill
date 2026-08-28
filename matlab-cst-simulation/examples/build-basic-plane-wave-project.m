clc;
clear;

outputDir = fullfile(pwd, "cst-output");
if ~exist(outputDir, "dir")
    mkdir(outputDir);
end

cst = actxserver("CSTStudio.Application");
mws = invoke(cst, "NewMWS");

defineUnits(mws, "mm", "GHz", "ns", "Kelvin");
defineFrequencyRange(mws, 8, 12);
defineBoundaries(mws, "expanded open", "expanded open", "expanded open", "expanded open", "electric", "expanded open");
invoke(mws, "AddToHistory", "select time domain solver", "ChangeSolverType ""HF Time Domain""");

addBrick(mws, "ground", "component1", "PEC", [-10, 10], [-10, 10], [0, 0.035]);
addBrick(mws, "substrate", "component1", "Vacuum", [-10, 10], [-10, 10], [0.035, 1.6]);
addPlaneWave(mws, [0, 0, -1], [1, 0, 0]);
addFrequencyMonitor(mws, "Efield", 10);
addFrequencyMonitor(mws, "Farfield", 10);

projectFile = fullfile(outputDir, "basic_plane_wave_project.cst");
invoke(mws, "SaveAs", projectFile, "True");
fprintf("CST_PROJECT=%s\n", projectFile);

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

function defineFrequencyRange(mws, fmin, fmax)
s = sprintf("Solver.FrequencyRange ""%g"", ""%g""", fmin, fmax);
invoke(mws, "AddToHistory", "define frequency range", s);
end

function defineBoundaries(mws, xmin, xmax, ymin, ymax, zmin, zmax)
s = "";
s = s + "With Boundary" + newline;
s = s + ".Xmin """ + xmin + """" + newline;
s = s + ".Xmax """ + xmax + """" + newline;
s = s + ".Ymin """ + ymin + """" + newline;
s = s + ".Ymax """ + ymax + """" + newline;
s = s + ".Zmin """ + zmin + """" + newline;
s = s + ".Zmax """ + zmax + """" + newline;
s = s + "End With";
invoke(mws, "AddToHistory", "define boundaries", char(s));
end

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

function addPlaneWave(mws, normalVec, eVec)
s = "";
s = s + "With PlaneWave" + newline;
s = s + ".Reset" + newline;
s = s + sprintf(".Normal ""%g"", ""%g"", ""%g""\n", normalVec(1), normalVec(2), normalVec(3));
s = s + sprintf(".EVector ""%g"", ""%g"", ""%g""\n", eVec(1), eVec(2), eVec(3));
s = s + ".Store" + newline;
s = s + "End With";
invoke(mws, "AddToHistory", "define plane wave", char(s));
end

function addFrequencyMonitor(mws, fieldType, freqGHz)
name = sprintf("%s_%gGHz", fieldType, freqGHz);
s = "";
s = s + "With Monitor" + newline;
s = s + ".Reset" + newline;
s = s + ".Name """ + name + """" + newline;
if fieldType ~= "Farfield"
    s = s + ".Dimension ""Volume""" + newline;
end
s = s + ".Domain ""Frequency""" + newline;
s = s + ".FieldType """ + fieldType + """" + newline;
s = s + sprintf(".Frequency ""%g""\n", freqGHz);
s = s + ".Create" + newline;
s = s + "End With";
invoke(mws, "AddToHistory", "define monitor: " + name, char(s));
end
