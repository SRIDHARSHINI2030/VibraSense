% testDataValidation.m
% Tests for VibraSense data validation.

function testDataValidation()

    fprintf('\nRunning data validation tests...\n');

    % Test 1: A valid dataset should pass.
    validFile = [tempname(), '.csv'];

    fileID = fopen(validFile, 'w');

    fprintf(fileID, 'time_s,healthy,imbalance,impact\n');
    fprintf(fileID, '0,1,2,3\n');
    fprintf(fileID, '0.1,2,3,4\n');
    fprintf(fileID, '0.2,3,4,5\n');

    fclose(fileID);

    result = validateAndPreprocess(validFile);

    assert(result.numberOfSamples == 3);
    assert(abs(result.samplingFrequency - 10) < 1e-6);

    fprintf('PASS: Valid dataset is accepted.\n');

    % Test 2: A missing file should be rejected.
    missingFile = [tempname(), '.csv'];

    caughtError = false;

    try
        validateAndPreprocess(missingFile);
    catch
        caughtError = true;
    end

    assert(caughtError);
    fprintf('PASS: Missing file is rejected.\n');

    % Test 3: A dataset with the wrong number of columns.
    badColumnsFile = [tempname(), '.csv'];

    fileID = fopen(badColumnsFile, 'w');

    fprintf(fileID, 'time_s,signal1,signal2\n');
    fprintf(fileID, '0,1,2\n');
    fprintf(fileID, '0.1,2,3\n');

    fclose(fileID);

    caughtError = false;

    try
        validateAndPreprocess(badColumnsFile);
    catch
        caughtError = true;
    end

    assert(caughtError);
    fprintf('PASS: Incorrect column count is rejected.\n');

    % Clean up the temporary files.
    delete(validFile);
    delete(badColumnsFile);

        % Test 4: NaN values should be rejected.
    nanFile = [tempname(), '.csv'];

    fileID = fopen(nanFile, 'w');
    fprintf(fileID, 'time_s,signal1,signal2,signal3\n');
    fprintf(fileID, '0,1,2,3\n');
    fprintf(fileID, '0.1,NaN,3,4\n');
    fclose(fileID);

    caughtError = false;

    try
        validateAndPreprocess(nanFile);
    catch
        caughtError = true;
    end

    assert(caughtError);
    fprintf('PASS: NaN values are rejected.\n');

    % Test 5: Non-increasing time values should be rejected.
    timeFile = [tempname(), '.csv'];

    fileID = fopen(timeFile, 'w');
    fprintf(fileID, 'time_s,signal1,signal2,signal3\n');
    fprintf(fileID, '0,1,2,3\n');
    fprintf(fileID, '0.1,2,3,4\n');
    fprintf(fileID, '0.1,3,4,5\n');
    fclose(fileID);

    caughtError = false;

    try
        validateAndPreprocess(timeFile);
    catch
        caughtError = true;
    end

    assert(caughtError);
    fprintf('PASS: Non-increasing time values are rejected.\n');

    % Test 6: Unevenly spaced time values should be rejected.
    unevenFile = [tempname(), '.csv'];

    fileID = fopen(unevenFile, 'w');
    fprintf(fileID, 'time_s,signal1,signal2,signal3\n');
    fprintf(fileID, '0,1,2,3\n');
    fprintf(fileID, '0.1,2,3,4\n');
    fprintf(fileID, '0.25,3,4,5\n');
    fclose(fileID);

    caughtError = false;

    try
        validateAndPreprocess(unevenFile);
    catch
        caughtError = true;
    end

    assert(caughtError);
    fprintf('PASS: Uneven sampling intervals are rejected.\n');

    % Remove temporary test files.
    delete(nanFile);
    delete(timeFile);
    delete(unevenFile);

    fprintf('All data validation tests passed.\n');

end
