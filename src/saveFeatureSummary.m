
function saveFeatureSummary(csvFile, outputFile)
% VibraSense - Calculate and save features for all three signals.

    if nargin ~= 2
        error("Provide the input CSV path and output CSV path.");
    end

    result = validateAndPreprocess(csvFile);

    signalNames = {"healthy_like"; "imbalance_like"; "impact_like"};

    numberOfSignals = columns(result.processedSignals);
    featureResults = cell(numberOfSignals, 1);

    for k = 1:numberOfSignals
        featureResults{k} = extractFeatures( ...
            result.processedSignals(:, k), ...
            result.samplingFrequency);
    end

    fileID = fopen(outputFile, "w");

    if fileID == -1
        error("Could not create the feature summary CSV.");
    end

    fprintf(fileID, ...
        ["signal,mean,standard_deviation,rms,peak_amplitude," ...
         "peak_to_peak,crest_factor,skewness,excess_kurtosis," ...
         "energy,dominant_frequency_hz,spectral_centroid_hz," ...
         "frequency_resolution_hz\n"]);

    for k = 1:numberOfSignals
        f = featureResults{k};

        fprintf(fileID, ...
            "%s,%.8f,%.8f,%.8f,%.8f,%.8f,%.8f,%.8f,%.8f,%.8f,%.8f,%.8f,%.8f\n", ...
            signalNames{k}, f.mean, f.standardDeviation, f.rms, ...
            f.peakAmplitude, f.peakToPeak, f.crestFactor, ...
            f.skewness, f.excessKurtosis, f.energy, ...
            f.dominantFrequencyHz, f.spectralCentroidHz, ...
            f.frequencyResolutionHz);
    end

    fclose(fileID);

    fprintf("\nFeature summary saved successfully.\n");
    fprintf("Output file: %s\n", outputFile);

end

