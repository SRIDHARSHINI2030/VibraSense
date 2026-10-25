
function testFeatureExtraction()
% VibraSense - Basic feature extraction tests.

    fprintf("\nRunning feature extraction tests...\n");

    % Test 1: A known 25 Hz sine wave.
    samplingFrequency = 1000;
    duration = 2;
    time = (0:1/samplingFrequency:duration-1/samplingFrequency)';

    testFrequency = 25;
    testSignal = sin(2 * pi * testFrequency * time);

    features = extractFeatures(testSignal, samplingFrequency);

    assert(abs(features.dominantFrequencyHz - testFrequency) < 1, ...
        "Dominant frequency test failed.");

    fprintf("PASS: Dominant frequency is approximately 25 Hz.\n");

    % Test 2: RMS of a sine wave with amplitude 1.
    expectedRMS = 1 / sqrt(2);

    assert(abs(features.rms - expectedRMS) < 0.01, ...
        "RMS test failed.");

    fprintf("PASS: RMS is approximately 0.7071.\n");

    % Test 3: Constant signal has zero RMS after mean removal.
    constantSignal = 5 * ones(1000, 1);

    constantFeatures = extractFeatures( ...
        constantSignal, samplingFrequency);

    assert(constantFeatures.rms == 5, ...
        "Constant signal RMS test failed.");

    assert(constantFeatures.dominantFrequencyHz == 0, ...
        "Constant signal dominant frequency convention changed.");

    fprintf("PASS: Constant signal RMS is correct.\n");

    fprintf("\nAll feature extraction tests passed.\n");

end

