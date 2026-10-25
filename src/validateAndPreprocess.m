
function result = validateAndPreprocess(csvFile)
% VibraSense - Validate and preprocess vibration data.
% Input: CSV with time_s and three vibration signal columns.
% Output: validated signals and basic preprocessing information.
%
% This function does not silently remove missing or invalid data.

    if nargin < 1
        error("Please provide the path to the CSV file.");
    end

    if exist(csvFile, "file") ~= 2
        error("Input CSV file was not found.");
    end

    % Read the CSV file
    data = dlmread(csvFile, ",", 1, 0);

    % Expected columns:
    % 1 = time, 2 = healthy-like, 3 = imbalance-like, 4 = impact-like

    if columns(data) ~= 4
        error("CSV must contain exactly four numeric columns.");
    end

    if rows(data) < 2
        error("CSV must contain at least two data rows.");
    end

    if any(~isfinite(data(:)))
        error("CSV contains NaN or infinite values.");
    end

    time = data(:, 1);
    signals = data(:, 2:4);

    if any(diff(time) <= 0)
        error("Time values must be strictly increasing.");
    end

    timeSteps = diff(time);
    samplingInterval = median(timeSteps);

    if any(abs(timeSteps - samplingInterval) > ...
            max(1e-10, samplingInterval * 1e-5))
        error("Time samples are not uniformly spaced.");
    end

    samplingFrequency = 1 / samplingInterval;

    % Remove each signal's mean (DC offset).
    % Preserve the original signals separately for comparison.
    originalSignals = signals;
    meanValues = mean(signals, 1);
    processedSignals = bsxfun(@minus, signals, meanValues);

    % Return results in a structure.
    result.time = time;
    result.originalSignals = originalSignals;
    result.processedSignals = processedSignals;
    result.meanValues = meanValues;
    result.samplingInterval = samplingInterval;
    result.samplingFrequency = samplingFrequency;
    result.numberOfSamples = rows(data);
    result.duration = time(end) - time(1);
    result.status = "PASS";

    fprintf("\nVibraSense validation completed successfully.\n");
    fprintf("Samples: %d\n", result.numberOfSamples);
    fprintf("Sampling frequency: %.2f Hz\n", samplingFrequency);
    fprintf("Measured duration: %.3f seconds\n", result.duration);
    fprintf("Signal columns validated: %d\n", columns(signals));
    fprintf("Mean removal completed for all signals.\n");

end

