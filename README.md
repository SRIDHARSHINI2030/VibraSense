
# VibraSense
### Vibration Signal Analysis and Rule-Based Condition Assessment

VibraSense is a GNU Octave project for analyzing vibration signals through data validation, preprocessing, statistical feature extraction, frequency-domain analysis, and rule-based condition assessment.

The project uses a reproducible workflow to demonstrate how signal characteristics can be extracted, compared, and summarized in reports. Its current dataset is synthetic and intended for demonstration and testing.

## Project Overview

Vibration signals contain information about the motion and periodic behaviour of a system. Examining their time-domain and frequency-domain characteristics provides a foundation for understanding signal patterns.

VibraSense implements a modular analysis pipeline that processes three synthetic signal patterns:

- **Healthy-like:** Low-amplitude periodic behaviour with noise.
- **Imbalance-like:** A stronger periodic component with a harmonic.
- **Impact-like:** Repeated, damped oscillatory bursts.

These labels describe the generated examples. They are not confirmed diagnoses of actual machine conditions.

## Key Features

- **Data validation:** Checks input structure, finite values, time ordering, and sampling consistency.
- **Signal preprocessing:** Removes the mean from each signal before feature analysis.
- **Statistical features:** Calculates RMS, peak amplitude, peak-to-peak amplitude, crest factor, standard deviation, energy, skewness, and excess kurtosis.
- **Frequency analysis:** Applies a Hann window and the Fast Fourier Transform (FFT) to calculate a single-sided amplitude spectrum and estimate dominant frequency.
- **Rule-based assessment:** Applies explicit conditions to flag selected signal patterns.
- **Automated outputs:** Generates CSV summaries, assessment reports, and comparison figures.
- **Tests:** Includes checks for data validation, feature extraction, assessment rules, and spectral accuracy.

## Technology Stack

- GNU Octave
- MATLAB-compatible `.m` scripts
- CSV for input data and tabular results
- FFT-based signal processing
- Git and GitHub for version control
- GitHub Pages for the project showcase

## Analysis Workflow

```text
Synthetic Vibration Data
          |
          v
Data Validation
          |
          v
Signal Preprocessing
          |
          v
Feature Extraction
          |
          v
Frequency-Domain Analysis
          |
          v
Rule-Based Assessment
          |
          v
CSV Reports and Figures
```

## Project Structure

```text
VibraSense/
├── config/
├── data/
│   ├── raw/
│   └── processed/
├── docs/
│   ├── assets/
│   ├── index.html
│   └── README.md
├── examples/
├── outputs/
│   ├── figures/
│   ├── metrics/
│   └── reports/
├── scripts/
│   └── runVibraSense.m
├── src/
│   ├── generateSyntheticDataset.m
│   ├── validateAndPreprocess.m
│   ├── extractFeatures.m
│   ├── saveFeatureSummary.m
│   ├── analyzeSpectrum.m
│   ├── assessCondition.m
│   ├── generateAssessmentReport.m
│   ├── plotVibrationComparison.m
│   └── compareSignalFeatures.m
├── tests/
├── .gitignore
└── README.md
```

## Getting Started

### Prerequisites

Install GNU Octave on your computer.

Download: https://octave.org/download

Git is optional if you download the repository as a ZIP file.

### 1. Clone the repository

```bash
git clone https://github.com/SRIDHARSHINI2030/VibraSense.git
cd VibraSense
```

Alternatively, download the repository ZIP from GitHub and extract it.

### 2. Open GNU Octave

Set the project directory to the extracted `VibraSense` folder.

### 3. Run the analysis

Execute the main script:

```matlab
run('scripts/runVibraSense.m')
```

The script adds the source directory to the Octave path, validates and preprocesses the dataset, generates assessment and comparison reports, and creates figures.


The script determines the project root from its own location, so the repository can be placed in a different folder without manually editing the project path.


### 4. Inspect the outputs

After execution, inspect the following locations:

| Location | Contents |
|---|---|
| `data/processed/` | Generated synthetic dataset |
| `outputs/figures/` | Signal and comparison plots |
| `outputs/metrics/` | Feature summaries and comparisons |
| `outputs/reports/` | Condition assessment report |

## Features and Signal Processing

### Time-domain features

| Feature | Description |
|---|---|
| RMS | Root mean square amplitude |
| Peak amplitude | Maximum absolute signal value |
| Peak-to-peak | Difference between maximum and minimum values |
| Crest factor | Peak amplitude divided by RMS |
| Standard deviation | Measures signal variation around its mean |
| Energy | Sum of squared signal samples |
| Skewness | Describes distribution asymmetry |
| Excess kurtosis | Describes distribution tail and peak characteristics |

### Frequency-domain analysis

The frequency analysis applies a Hann window to reduce spectral leakage before computing the FFT. It then calculates the single-sided amplitude spectrum and estimates the dominant non-zero frequency.

Frequency resolution depends on the number of samples and sampling frequency. Windowing and the frequency-search method also affect spectral estimates.

## Condition Assessment

The current assessment is rule-based rather than machine-learning-based. It uses selected extracted features, including crest factor, excess kurtosis, RMS, and dominant frequency, to flag illustrative patterns.

These rules are demonstration criteria, not universally valid fault thresholds. Their effectiveness has not been established using real machinery data.


The project includes tests for feature extraction, data validation, condition assessment, and spectral accuracy.

To run the tests, open GNU Octave, navigate to the project root, and execute each test script:

```matlab
addpath('src');
run('tests/testFeatureExtraction.m');
run('tests/testDataValidation.m');
run('tests/testConditionAssessment.m');
run('tests/testSpectralAccuracy.m');
```

Run each script separately and check its output for failed checks or errors. The tests passed in the development environment; results may vary across Octave versions.


## Project Showcase

**Live website:** https://sridharshini2030.github.io/VibraSense/

**Source code:** https://github.com/SRIDHARSHINI2030/VibraSense

The website presents the project overview, generated signal plots, and a browser-based interactive demonstration. The browser demo is separate from the GNU Octave analysis pipeline.

## Limitations and Future Work

- The current examples use synthetic rather than measured vibration data.
- The rule-based assessment has not been validated against real operating conditions.
- The browser demonstration uses a simplified frequency search and is not a replacement for the Octave analysis pipeline.
- Further work could include real sensor data, systematic validation, configurable input datasets, and more comprehensive test coverage.

## License

No license has been specified yet. Contact the repository owner before reusing or redistributing the code.
