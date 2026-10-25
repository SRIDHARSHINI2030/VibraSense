
function plotVibrationComparison(csvFile)
% VibraSense - Compare three synthetic vibration signals.
% All signals are synthetic demonstrations, not real machine measurements.

    result = validateAndPreprocess(csvFile);

    signalNames = {
        'Healthy-like'
        'Imbalance-like'
        'Impact-like'
    };

    if size(result.processedSignals, 2) ~= 3
        error('Expected exactly three signal columns.');
    end

    time = result.time;
    signals = result.processedSignals;

    % Figure 1: Time-domain comparison.
figure('Name', 'VibraSense - Time Domain Comparison', ...
       'Position', [100, 100, 1000, 800]);

    for i = 1:3
        subplot(3, 1, i);
        plot(time, signals(:, i));
        title([signalNames{i}, ' Signal']);
        xlabel('Time (seconds)');
        ylabel('Amplitude');
set(gca, 'FontSize', 10);
        grid on;
    end

    % Figure 2: Frequency-domain comparison.
figure('Name', 'VibraSense - Frequency Spectrum Comparison', ...
       'Position', [150, 100, 1000, 800]);

    samplingFrequency = result.samplingFrequency;
    numberOfSamples = size(signals, 1);

    window = 0.5 - 0.5 * cos( ...
        2 * pi * (0:numberOfSamples-1)' / (numberOfSamples-1));

    frequency = (0:floor(numberOfSamples/2))' ...
        * samplingFrequency / numberOfSamples;

    for i = 1:3
        centeredSignal = signals(:, i);
        windowedSignal = centeredSignal .* window;

        spectrum = abs(fft(windowedSignal)) / sum(window);
        spectrum = spectrum(1:floor(numberOfSamples/2)+1);

        if length(spectrum) > 2
            spectrum(2:end-1) = 2 * spectrum(2:end-1);
        end

        subplot(3, 1, i);
        plot(frequency, spectrum);
        title([signalNames{i}, ' Frequency Spectrum']);
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');
        xlim([0, 200]);
        grid on;
    end

    % Save the figures.
    figure(1);
    print('C:\VibraSense\outputs\figures\time_domain_comparison.png', ...
        '-dpng', '-r150');

    figure(2);
    print('C:\VibraSense\outputs\figures\frequency_comparison.png', ...
        '-dpng', '-r150');

    fprintf('\nComparison figures saved successfully.\n');
    fprintf('All plots use synthetic demonstration data.\n');
end

