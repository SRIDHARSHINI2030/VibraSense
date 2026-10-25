
% VibraSense - Main workflow runner
% Uses synthetic demonstration data only.

clear;
clc;
close all;

% Define project folders.
scriptPath = mfilename('fullpath');
projectRoot = fileparts(fileparts(scriptPath));
sourceFolder = fullfile(projectRoot, 'src');
dataFile = fullfile(projectRoot, 'data', 'processed', ...
    'synthetic_vibration_demo.csv');

reportFolder = fullfile(projectRoot, 'outputs', 'reports');
metricsFolder = fullfile(projectRoot, 'outputs', 'metrics');

% Add project functions to the Octave search path.
addpath(sourceFolder);

fprintf('\n====================================\n');
fprintf('       VibraSense Analysis\n');
fprintf('====================================\n');
fprintf('Synthetic demonstration data only.\n\n');

% Step 1: Validate and preprocess the dataset.
fprintf('Step 1: Validating and preprocessing data...\n');
result = validateAndPreprocess(dataFile);

% Step 2: Generate the condition assessment report.
fprintf('\nStep 2: Generating condition assessment report...\n');
assessmentFile = fullfile(reportFolder, ...
    'condition_assessment_report.csv');

report = generateAssessmentReport(dataFile, assessmentFile);

% Step 3: Generate the feature comparison report.
fprintf('\nStep 3: Comparing signal features...\n');
comparison = compareSignalFeatures(dataFile);

% Step 4: Generate comparison plots.
fprintf('\nStep 4: Generating comparison plots...\n');
plotVibrationComparison(dataFile);

% Display a final summary.
fprintf('\n====================================\n');
fprintf('       Analysis Completed\n');
fprintf('====================================\n');
fprintf('Assessment report:\n%s\n', assessmentFile);

fprintf('\nFeature comparison:\n%s\n', ...
    fullfile(metricsFolder, 'signal_feature_comparison.csv'));

fprintf('\nFigures folder:\n%s\n', ...
    fullfile(projectRoot, 'outputs', 'figures'));

fprintf('\nAll results are illustrative, not validated\n');
fprintf('industrial fault diagnoses.\n');

