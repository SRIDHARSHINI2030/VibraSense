% testConditionAssessment.m
% Tests for VibraSense condition assessment rules.

function testConditionAssessment()

    fprintf('\nRunning condition assessment tests...\n');

    % Test 1: Detect an impact-like pattern.
    features.rms = 0.1;
    features.crestFactor = 6;
    features.excessKurtosis = 5;
    features.dominantFrequencyHz = 120;

    result = assessCondition(features);

    assert(strcmp(result.label, 'Impact-like pattern'));
    fprintf('PASS: Impact-like pattern is identified.\n');

    % Test 2: Detect a strong 20-30 Hz component.
    features.rms = 0.4;
    features.crestFactor = 2;
    features.excessKurtosis = 0;
    features.dominantFrequencyHz = 25;

    result = assessCondition(features);

    assert(strcmp(result.label, ...
        'Strong 20-30 Hz component'));
    fprintf('PASS: Strong 20-30 Hz component is identified.\n');

    % Test 3: No demonstration rule is triggered.
    features.rms = 0.1;
    features.crestFactor = 2;
    features.excessKurtosis = 0;
    features.dominantFrequencyHz = 10;

    result = assessCondition(features);

    assert(strcmp(result.label, ...
        'No rule-based concern identified'));
    fprintf('PASS: Unflagged pattern is handled correctly.\n');

    fprintf('All condition assessment tests passed.\n');

end
