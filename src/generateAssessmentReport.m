
function reportTable = generateAssessmentReport(csvFile, outputFile)
% VibraSense - Generate a CSV condition assessment report.
% Results are illustrative and use synthetic demonstration data.

    % Load and validate the vibration dataset.
    result = validateAndPreprocess(csvFile);

    signalNames = {
        'Healthy-like'
        'Imbalance-like'
        'Impact-like'
    };

    numberOfSignals = size(result.processedSignals, 2);

    if numberOfSignals ~= length(signalNames)
        error('Expected exactly three signals in the demonstration dataset.');
    end

    % Prepare report columns.
    Signal = cell(numberOfSignals, 1);
    RMS = zeros(numberOfSignals, 1);
    CrestFactor = zeros(numberOfSignals, 1);
    ExcessKurtosis = zeros(numberOfSignals, 1);
    DominantFrequencyHz = zeros(numberOfSignals, 1);
    Assessment = cell(numberOfSignals, 1);
    Reason = cell(numberOfSignals, 1);

    % Analyze each signal.
    for i = 1:numberOfSignals
        features = extractFeatures( ...
            result.processedSignals(:, i), ...
            result.samplingFrequency);

        condition = assessCondition(features);

        Signal{i} = signalNames{i};
        RMS(i) = features.rms;
        CrestFactor(i) = features.crestFactor;
        ExcessKurtosis(i) = features.excessKurtosis;
        DominantFrequencyHz(i) = features.dominantFrequencyHz;
        Assessment{i} = condition.label;
        Reason{i} = condition.reason;
    end

    % Create a table-like structure for the report.
    reportTable = struct();
    reportTable.Signal = Signal;
    reportTable.RMS = RMS;
    reportTable.CrestFactor = CrestFactor;
    reportTable.ExcessKurtosis = ExcessKurtosis;
    reportTable.DominantFrequencyHz = DominantFrequencyHz;
    reportTable.Assessment = Assessment;
    reportTable.Reason = Reason;

    % Write the report to a CSV file.
    fileID = fopen(outputFile, 'w');

    if fileID == -1
        error('Could not open report output file: %s', outputFile);
    end

    fprintf(fileID, ...
        'Signal,RMS,CrestFactor,ExcessKurtosis,DominantFrequencyHz,Assessment,Reason\n');

    for i = 1:numberOfSignals
        fprintf(fileID, '%s,%.6f,%.6f,%.6f,%.2f,"%s","%s"\n', ...
            Signal{i}, RMS(i), CrestFactor(i), ...
            ExcessKurtosis(i), DominantFrequencyHz(i), ...
            Assessment{i}, Reason{i});
    end
1111111111111111111
    fclose(fileID);

    fprintf('\nVibraSense assessment report saved successfully.\n');
    fprintf('Output file: %s\n', outputFile);
    fprintf('Note: These are illustrative synthetic-data results.\n');
end

