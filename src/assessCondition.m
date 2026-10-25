
function assessment = assessCondition(features)
% VibraSense - Illustrative vibration condition assessment.
% These demonstration rules are not validated industrial thresholds.

    requiredFields = {
        'rms'
        'crestFactor'
        'excessKurtosis'
        'dominantFrequencyHz'
    };

    for i = 1:length(requiredFields)
        if ~isfield(features, requiredFields{i})
            error('Missing required feature: %s', requiredFields{i});
        end
    end

    if ~isfinite(features.rms) || features.rms < 0
        error('RMS must be finite and non-negative.');
    end

    if ~isfinite(features.crestFactor) || ...
            ~isfinite(features.excessKurtosis) || ...
            ~isfinite(features.dominantFrequencyHz)
        error('Assessment features must be finite.');
    end

    % Default label: no rule-based concern identified.
    assessment.label = 'No rule-based concern identified';
    assessment.reason = ...
        'The illustrative rules did not identify a flagged pattern.';

    % Demonstration rules for synthetic data only.
    if features.crestFactor > 4 && ...
            features.excessKurtosis > 1

        assessment.label = 'Impact-like pattern';
        assessment.reason = ...
            'High crest factor and excess kurtosis suggest impulsive behavior.';

    elseif features.dominantFrequencyHz >= 20 && ...
            features.dominantFrequencyHz <= 30 && ...
            features.rms > 0.2

        assessment.label = 'Strong 20-30 Hz component';
        assessment.reason = ...
            'A strong signal with a dominant component in the 20-30 Hz band was found.';
    end

    assessment.isDemonstrationOnly = true;
end

