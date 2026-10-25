
function features = extractFeatures(signal, samplingFrequency)
% VibraSense - Extract basic time and frequency-domain features.
% Input signal must be a finite, real-valued vector.
% Frequency features use a single-sided amplitude spectrum.

    if nargin ~= 2
        error("Provide a signal and its sampling frequency.");
    end

    if ~isvector(signal) || isempty(signal)
        error("Signal must be a non-empty vector.");
    end

    if ~isreal(signal) || any(~isfinite(signal(:)))
        error("Signal must contain finite real values.");
    end

    if ~isscalar(samplingFrequency) || ...
            ~isfinite(samplingFrequency) || samplingFrequency <= 0
        error("Sampling frequency must be a positive finite number.");
    end

    signal = signal(:);
    numberOfSamples = length(signal);

    if numberOfSamples < 2
        error("At least two samples are required.");
    end

    % Time-domain features
    signalMean = mean(signal);
    centeredSignal = signal - signalMean;

    signalRMS = sqrt(mean(signal .^ 2));
    peakAmplitude = max(abs(signal));
    peakToPeak = max(signal) - min(signal);

    if signalRMS > 0
        crestFactor = peakAmplitude / signalRMS;
    else
        crestFactor = 0;
    end

    signalStd = std(signal, 1);
    signalEnergy = sum(signal .^ 2);

    % Calculate skewness and excess kurtosis.
    if signalStd > 0
        standardizedSignal = centeredSignal / signalStd;
        skewnessValue = mean(standardizedSignal .^ 3);
        excessKurtosis = mean(standardizedSignal .^ 4) - 3;
    else
        skewnessValue = 0;
        excessKurtosis = 0;
    end

    % Frequency-domain analysis
    % Remove the mean to reduce the DC component.
    windowedSignal = centeredSignal .* ...
        (0.5 - 0.5 * cos(2 * pi * ...
        (0:numberOfSamples-1)' / (numberOfSamples-1)));

    fftValues = fft(windowedSignal);
    numberOfPositiveBins = floor(numberOfSamples / 2) + 1;

    positiveFFT = fftValues(1:numberOfPositiveBins);
    amplitudeSpectrum = abs(positiveFFT) / sum( ...
    0.5 - 0.5 * cos(2 * pi * ...
    (0:numberOfSamples-1)' / (numberOfSamples-1)));

    % Convert to a single-sided amplitude spectrum.
    if rem(numberOfSamples, 2) == 0
        amplitudeSpectrum(2:end-1) = ...
            2 * amplitudeSpectrum(2:end-1);
    else
        amplitudeSpectrum(2:end) = ...
            2 * amplitudeSpectrum(2:end);
    end

    frequency = (0:numberOfPositiveBins-1)' ...
        * samplingFrequency / numberOfSamples;

    % Ignore the DC bin when finding dominant frequency.
nonDCAmplitude = amplitudeSpectrum(2:end);

if max(nonDCAmplitude) < 1e-10
    dominantFrequency = 0;
else
    [~, dominantIndex] = max(nonDCAmplitude);
    dominantFrequency = frequency(dominantIndex + 1);
end

    spectrumTotal = sum(amplitudeSpectrum);

    if spectrumTotal > 0
        spectralCentroid = ...
            sum(frequency .* amplitudeSpectrum) / spectrumTotal;
    else
        spectralCentroid = 0;
    end

    % Store results
    features.mean = signalMean;
    features.standardDeviation = signalStd;
    features.rms = signalRMS;
    features.peakAmplitude = peakAmplitude;
    features.peakToPeak = peakToPeak;
    features.crestFactor = crestFactor;
    features.skewness = skewnessValue;
    features.excessKurtosis = excessKurtosis;
    features.energy = signalEnergy;
    features.dominantFrequencyHz = dominantFrequency;
    features.dominantAmplitude = max(amplitudeSpectrum(2:end));
    features.spectralCentroidHz = spectralCentroid;
    features.frequencyResolutionHz = ...
        samplingFrequency / numberOfSamples;

end

