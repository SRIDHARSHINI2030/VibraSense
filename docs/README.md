\# VibraSense

\## Vibration Signal Analysis and Condition Assessment



VibraSense is a vibration signal analysis project implemented in GNU Octave. It brings together signal preprocessing, statistical feature extraction, frequency-domain analysis, and rule-based condition assessment in a single workflow.



The objective is to take sampled vibration data, validate it, extract measurable characteristics, and produce outputs that make the differences between signals easier to examine. The implementation is divided into small, independent functions so that each stage can be tested and understood separately.



The current workflow uses three synthetic signals representing healthy-like behaviour, an imbalance-like pattern, and repeated impact events. These signals provide a controlled way to examine the behaviour of the processing pipeline.



\## How the analysis works



The workflow begins with dataset validation. The input file is checked for the expected number of columns, sufficient samples, finite numerical values, increasing timestamps, and consistent sampling intervals. The sampling frequency is estimated from the time column rather than assumed from the filename or signal label.



After validation, the mean is removed from each signal. This centres the measurements around zero and reduces the influence of a constant offset on subsequent calculations.



The preprocessed signals are then passed through the feature extraction module. Time-domain statistics describe signal magnitude and distribution, while the frequency-domain calculations help identify periodic components and describe how the signal is distributed across frequency.



The extracted features are compared across the three signals. A separate assessment module applies explicit thresholds to selected features and produces a corresponding label. Finally, the workflow writes CSV reports and saves plots for further inspection.



\## Signal processing



\### Time-domain features



The feature extraction module calculates the following measurements:



\- RMS and standard deviation

\- Peak and peak-to-peak amplitude

\- Crest factor

\- Signal energy

\- Skewness

\- Excess kurtosis



RMS provides a measure of the overall signal magnitude. Standard deviation describes the spread of the samples around their mean. Peak amplitude captures the largest absolute sample, while peak-to-peak amplitude measures the difference between the maximum and minimum values.



Crest factor is calculated as peak amplitude divided by RMS. It provides a useful way to compare the size of isolated peaks with the overall signal level. Skewness and excess kurtosis describe aspects of the sample distribution and can help distinguish signals with different statistical characteristics.



These measurements are complementary. No single feature provides a complete description of a vibration signal, so the implementation retains several measurements for comparison.



\### Frequency-domain analysis



The frequency-domain calculation removes the signal mean, applies a Hann window, and computes the Fast Fourier Transform (FFT). The spectrum is converted into a single-sided amplitude representation for analysis.



Windowing reduces spectral leakage caused by observing a finite section of a signal. The amplitude scaling uses the sum of the window coefficients, which accounts for the attenuation introduced by the window. The DC component is excluded when selecting the dominant non-zero frequency.



The module returns the dominant frequency, its spectral amplitude, the frequency resolution, and the spectral centroid. Frequency resolution is determined by the sampling frequency and number of samples. The spectral centroid is calculated as an amplitude-weighted frequency measure.



A separate plotting function uses the same general windowing and amplitude-normalisation approach to produce frequency-spectrum comparisons.



\## Condition assessment



The assessment module uses a small set of explicit rules based on extracted features.



A signal is labelled impact-like when its crest factor and excess kurtosis exceed the configured thresholds. A strong 20–30 Hz component is reported when the dominant frequency falls within that range and the RMS exceeds the configured threshold. Signals that satisfy neither rule receive a separate result.



Keeping these rules in a dedicated function makes the assessment logic straightforward to inspect and modify. The thresholds are part of the current demonstration implementation, not universal vibration limits.



\## Implementation



The code is organised by responsibility rather than placing the entire workflow in one script.



`validateAndPreprocess.m` handles input checks and signal preparation.



`extractFeatures.m` calculates the time-domain and frequency-domain features for an individual signal.



`analyzeSpectrum.m` produces frequency-spectrum plots.



`assessCondition.m` evaluates the extracted features against the configured rules.



`compareSignalFeatures.m` processes the three demonstration signals and writes their measurements to a comparison CSV.



`generateAssessmentReport.m` combines feature extraction and condition assessment to produce a report.



`plotVibrationComparison.m` generates the time-domain and frequency-domain comparison figures.



`generateSyntheticDataset.m` creates the demonstration data, while `saveFeatureSummary.m` writes a separate feature summary.



The main workflow is defined in `scripts/runVibraSense.m`. It calls the processing functions in sequence and reports where the generated outputs are saved.



\## Project structure



```text

VibraSense/

├── src/

│   ├── generateSyntheticDataset.m

│   ├── validateAndPreprocess.m

│   ├── extractFeatures.m

│   ├── analyzeSpectrum.m

│   ├── assessCondition.m

│   ├── compareSignalFeatures.m

│   ├── generateAssessmentReport.m

│   ├── saveFeatureSummary.m

│   └── plotVibrationComparison.m

├── tests/

│   ├── testDataValidation.m

│   ├── testFeatureExtraction.m

│   ├── testSpectralAccuracy.m

│   └── testConditionAssessment.m

├── scripts/

│   └── runVibraSense.m

├── config/

├── data/

│   ├── raw/

│   └── processed/

├── outputs/

│   ├── figures/

│   ├── metrics/

│   └── reports/

├── examples/

└── docs/

&#x20;   └── README.md

