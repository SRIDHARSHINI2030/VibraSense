
% VibraSense - Synthetic Vibration Data Generator
% Educational simulation only; not real machine measurements.

clear;
clc;
close all;

%% 1. Signal settings

samplingFrequency = 1000;
duration = 5;
shaftFrequency = 25;

numberOfSamples = samplingFrequency * duration;
time = (0:numberOfSamples-1)' / samplingFrequency;

%% 2. Reproducible random noise

rng(7, "twister");

%% 3. Healthy-like vibration

healthyNoise = 0.04 * randn(numberOfSamples, 1);

healthySignal = healthyNoise ...
    + 0.08 * sin(2 * pi * shaftFrequency * time);

%% 4. Imbalance-like vibration

imbalanceNoise = 0.04 * randn(numberOfSamples, 1);

imbalanceSignal = imbalanceNoise ...
    + 0.45 * sin(2 * pi * shaftFrequency * time) ...
    + 0.10 * sin(2 * pi * 2 * shaftFrequency * time);

%% 5. Impact-like vibration

impactSignal = 0.04 * randn(numberOfSamples, 1);

impactInterval = 0.5;
impactDuration = 0.12;
impactFrequency = 120;

impactTimes = impactInterval:impactInterval:duration;

for k = 1:length(impactTimes)

    localTime = time - impactTimes(k);

    impactMask = localTime >= 0 & localTime < impactDuration;

    impactSignal(impactMask) = impactSignal(impactMask) ...
        + 0.8 ...
        .* exp(-localTime(impactMask) / 0.025) ...
        .* sin(2 * pi * impactFrequency .* localTime(impactMask));

end

%% 6. Locate project folders

scriptFolder = fileparts(mfilename("fullpath"));
projectRoot = fileparts(scriptFolder);

dataFolder = fullfile(projectRoot, "data", "processed");
figureFolder = fullfile(projectRoot, "outputs", "figures");

if ~exist(dataFolder, "dir")
    mkdir(dataFolder);
end

if ~exist(figureFolder, "dir")
    mkdir(figureFolder);
end

%% 7. Save the signals to CSV

outputFile = fullfile(dataFolder, "synthetic_vibration_demo.csv");

fileID = fopen(outputFile, "w");

if fileID == -1
    error("Could not create the CSV file. Check folder permissions.");
end

fprintf(fileID, "time_s,healthy_like,imbalance_like,impact_like\n");

fclose(fileID);

signalData = [time, healthySignal, imbalanceSignal, impactSignal];

dlmwrite(outputFile, signalData, ...
    "-append", "delimiter", ",", "precision", "%.8f");

%% 8. Plot all three signals

figure("Name", "VibraSense Synthetic Vibration Signals");

subplot(3, 1, 1);
plot(time, healthySignal);
title("Healthy-like Signal");
ylabel("Amplitude");
grid on;

subplot(3, 1, 2);
plot(time, imbalanceSignal);
title("Imbalance-like Signal");
ylabel("Amplitude");
grid on;

subplot(3, 1, 3);
plot(time, impactSignal);
title("Impact-like Signal");
xlabel("Time (seconds)");
ylabel("Amplitude");
grid on;

%% 9. Save the plot

figureFile = fullfile(figureFolder, "synthetic_signals.png");

print(gcf, figureFile, "-dpng", "-r150");

%% 10. Display the results

fprintf("\nVibraSense data generation completed.\n");
fprintf("Sampling frequency: %d Hz\n", samplingFrequency);
fprintf("Duration: %d seconds\n", duration);
fprintf("Number of samples: %d\n", numberOfSamples);
fprintf("CSV file: %s\n", outputFile);
fprintf("Plot file: %s\n", figureFile);

