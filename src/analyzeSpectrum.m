
function analyzeSpectrum(csvFile)
% VibraSense - Plot single-sided amplitude spectra.
% Educational analysis of synthetic vibration signals.

    if nargin ~= 1
        error("Provide the input CSV file path.");
    end

    result = validateAndPreprocess(csvFile);

    signalNames = {
        "Healthy-like"
        "Imbalance-like"
        "Impact-like"
    };

    numberOfSignals = columns(result.processedSignals);
    numberOfSamples = result.numberOfSamples;
    samplingFrequency = result.samplingFrequency;

    figure("Name", "VibraSense Frequency Spectrum");

    for k = 1:numberOfSignals

        signal = result.processedSignals(:, k);
        centeredSignal = signal - mean(signal);

        % Hann window reduces spectral leakage.
        window = 0.5 - 0.5 * cos( ...
            2 * pi * (0:numberOfSamples-1)' / ...
            (numberOfSamples-1));

        windowedSignal = centeredSignal .* window;

        % Correct the amplitude for the window's coherent gain.
        fftValues = fft(windowedSignal);
        numberOfBins = floor(numberOfSamples / 2) + 1;

        amplitudeSpectrum = abs(fftValues(1:numberOfBins)) ...
            / sum(window);

        % Build the single-sided amplitude spectrum.
        if rem(numberOfSamples, 2) == 0
            amplitudeSpectrum(2:end-1) = ...
                2 * amplitudeSpectrum(2:end-1);
        else
            amplitudeSpectrum(2:end) = ...
                2 * amplitudeSpectrum(2:end);
        end

        frequency = (0:numberOfBins-1)' ...
            * samplingFrequency / numberOfSamples;

        subplot(numberOfSignals, 1, k);
        plot(frequency, amplitudeSpectrum);
        title([signalNames{k}, " Frequency Spectrum"]);
        xlabel("Frequency (Hz)");
        ylabel("Amplitude");
        xlim([0, 250]);
        grid on;

    end

    fprintf("\nFrequency-spectrum plots generated.\n");
    fprintf("Frequency resolution: %.3f Hz\n", ...
        samplingFrequency / numberOfSamples);

end

