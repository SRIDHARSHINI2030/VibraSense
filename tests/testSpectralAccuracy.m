% testSpectralAccuracy.m
% Tests the actual VibraSense feature extraction function.

function testSpectralAccuracy()

    fprintf('\nRunning spectral accuracy test...\n');

    samplingFrequency = 1000;
    numberOfSamples = 1000;
    expectedAmplitude = 1;
    testFrequency = 25;

    time = (0:numberOfSamples-1)' / samplingFrequency;

    signal = expectedAmplitude * ...
        sin(2 * pi * testFrequency * time);

    % Call the actual VibraSense function.
    features = extractFeatures(signal, samplingFrequency);

    measuredFrequency = features.dominantFrequencyHz;
    measuredAmplitude = features.dominantAmplitude;

    fprintf('Expected frequency: %.2f Hz\n', testFrequency);
    fprintf('Measured frequency: %.2f Hz\n', measuredFrequency);

    fprintf('Expected amplitude: %.4f\n', expectedAmplitude);
    fprintf('Measured amplitude: %.4f\n', measuredAmplitude);

    % Verify frequency accuracy.
    assert(abs(measuredFrequency - testFrequency) < 1e-6, ...
        'FAIL: Dominant frequency is incorrect.');

    % Verify amplitude accuracy.
    assert(abs(measuredAmplitude - expectedAmplitude) < 0.01, ...
        'FAIL: Dominant amplitude is inaccurate.');

    fprintf('PASS: Actual feature extraction has accurate frequency and amplitude.\n');

end
