
function comparison = compareSignalFeatures(csvFile)
% VibraSense - Compare features across three synthetic vibration signals.
% The labels describe demonstration signals, not verified machine faults.

    result = validateAndPreprocess(csvFile);

    signalNames = {
        'Healthy-like'
        'Imbalance-like'
        'Impact-like'
    };

    numberOfSignals = size(result.processedSignals, 2);

    if numberOfSignals ~= 3
        error('Expected exactly three synthetic signal columns.');
    end

    % Initialize feature arrays.
    RMS = zeros(numberOfSignals, 1);
    StandardDeviation = zeros(numberOfSignals, 1);
    PeakAmplitude = zeros(numberOfSignals, 1);
    CrestFactor = zeros(numberOfSignals, 1);
    ExcessKurtosis = zeros(numberOfSignals, 1);
    DominantFrequencyHz = zeros(numberOfSignals, 1);
    SpectralCentroidHz = zeros(numberOfSignals, 1);

    % Extract features from each signal.
       for i = 1:numberOfSignals
        features = extractFeatures( ...
            result.processedSignals(:, i), ...
            result.samplingFrequency);


        RMS(i) = features.rms;
        StandardDeviation(i) = features.standardDeviation;
        PeakAmplitude(i) = features.peakAmplitude;
        CrestFactor(i) = features.crestFactor;
        ExcessKurtosis(i) = features.excessKurtosis;
        DominantFrequencyHz(i) = features.dominantFrequencyHz;
        SpectralCentroidHz(i) = features.spectralCentroidHz;
    end

    % Return the comparison as a structure.
    comparison = struct();
    comparison.Signal = signalNames;
    comparison.RMS = RMS;
    comparison.StandardDeviation = StandardDeviation;
    comparison.PeakAmplitude = PeakAmplitude;
    comparison.CrestFactor = CrestFactor;
    comparison.ExcessKurtosis = ExcessKurtosis;
    comparison.DominantFrequencyHz = DominantFrequencyHz;
    comparison.SpectralCentroidHz = SpectralCentroidHz;

    % Save the comparison to CSV.
    outputFile = ...
        'C:\VibraSense\outputs\metrics\signal_feature_comparison.csv';

    fileID = fopen(outputFile, 'w');

    if fileID == -1
        error('Could not create feature comparison CSV file.');
    end

    fprintf(fileID, ...
        'Signal,RMS,StandardDeviation,PeakAmplitude,CrestFactor,ExcessKurtosis,DominantFrequencyHz,SpectralCentroidHz\n');

    for i = 1:numberOfSignals
        fprintf(fileID, '%s,%.6f,%.6f,%.6f,%.6f,%.6f,%.2f,%.2f\n', ...
            signalNames{i}, RMS(i), StandardDeviation(i), ...
            PeakAmplitude(i), CrestFactor(i), ExcessKurtosis(i), ...
            DominantFrequencyHz(i), SpectralCentroidHz(i));
    end

    fclose(fileID);

    fprintf('\nFeature comparison saved successfully.\n');
    fprintf('Output file: %s\n', outputFile);
end

