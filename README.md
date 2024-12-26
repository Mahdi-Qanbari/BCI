# BCI and Movement Neuroscience Data Analysis Using MNE-Python and MATLAB

## Table of Contents
1. [What Are Events in EEG Data?](#what-are-events-in-eeg-data)
2. [Why Are Events Important?](#why-are-events-important)
3. [Understanding Event Data Structure](#understanding-event-data-structure)
4. Step-by-Step Example: Plotting Raw EEG Data with Events
   - 1. Import Necessary Libraries
   - 2. Load Your EEG Data
   - 3. Inspect and Extract Events
   - 4. Create an MNE Raw Object
   - 5. Format Events for MNE
   - 6. Plotting the Raw EEG Data with Events
5. [P300 Pre-processing Steps](#p300-pre-processing-steps)
6. [When to Use LDA in EEG Analysis](#When-to-Use-LDA-in-EEG-Analysis)
7. [Movement Neuroscience ; EMGs and iEMG](#Movement-Neuroscience-;-EMGs-and-iEMG)

## What Are Events in EEG Data?

Events in EEG data are markers or annotations that indicate specific moments during the recording when something of interest occurs. These can include:

- **Stimuli Presentations:** Visual or auditory cues presented to the participant.
- **Participant Responses:** Button presses, key presses, or other responses.
- **System Triggers:** Internal signals from the EEG recording system marking particular points in time.
- **External Events:** Any significant occurrence you want to analyze in relation to the EEG data.

### Visual Representation

Imagine an EEG recording session where participants are shown images and asked to respond by pressing a button. Each time an image is shown, an event marker is recorded. You can later analyze the EEG data segments (epochs) around these markers to study brain responses to the images.

---

## Why Are Events Important?

Events are crucial for several reasons:

- **Segmentation:** They allow you to segment continuous EEG data into meaningful epochs (e.g., before, during, and after a stimulus).
- **Analysis:** Enable event-related analyses, such as Event-Related Potentials (ERPs), which average EEG responses time-locked to events.
- **Synchronization:** Help synchronize EEG data with other data sources (e.g., behavioral responses, video recordings).

Without event markers, it would be challenging to relate EEG signals to specific experimental conditions or stimuli.

---

## Understanding Event Data Structure

In MNE, events are typically represented as a NumPy array with shape `(n_events, 3)`, where each row corresponds to an event and contains three integers:

- **Sample Number:** The exact point in the EEG data (in samples) when the event occurred.
- **Previous Event ID:** Usually set to 0, reserved for specific uses but not commonly used.
- **Event ID:** An integer that uniquely identifies the type of event.

---

## P300 Pre-processing Steps

This section outlines the essential steps required for pre-processing P300-related EEG data. Each step is vital for ensuring the quality and reliability of your analysis.

### 1. Load and Inspect the Data
Begin by loading your EEG data into the analysis environment. Inspect the dataset for any noticeable artifacts or irregularities that could impact the analysis. This preliminary examination helps identify potential issues such as noise, missing data, or abnormalities in the recordings.

### 2. Filter the Data
Apply a band-pass filter to focus on the frequency range typically associated with the P300 component, which generally falls between 0.1 Hz and 30 Hz. Filtering enhances relevant brain signals while minimizing noise from other frequency ranges.

### 3. Identify and Mark Bad Channels
Inspect the EEG data for channels that display excessive noise or artifacts. Mark these bad channels for exclusion during further analysis. This step is crucial for maintaining data integrity, as bad channels can introduce bias or inaccuracies in the results.

### 4. Re-reference the Data
Re-referencing adjusts the voltage measurements of the EEG channels based on a reference point, typically the average of all channels or a specific channel (e.g., Cz). The purposes of re-referencing include:

- **Minimizing Noise:** Reducing the influence of artifacts from individual channels can enhance the overall quality of the data.
- **Improving Spatial Resolution:** A better reference can lead to clearer identification of brain activity associated with cognitive processes like the P300.
- **Ensuring Consistency:** Standardizing reference points across different recordings facilitates more valid comparisons.

#### Common Referencing Strategies:
- **Average Reference:** Uses the average signal from all channels as the reference.
- **Linked Ears:** Averages the signals from both ear electrodes to serve as a reference.
- **Common Reference:** Uses a specific electrode, such as Cz, as the reference for all other electrodes.

### 5. Artifact Removal Using Independent Component Analysis (ICA)
ICA is a statistical method used to separate mixed signals into independent components. This technique is effective for identifying and removing artifacts from EEG data. ICA relies on the following principles:

- **Statistical Independence:** Assumes that the sources (e.g., brain signals and artifacts) are statistically independent from each other.
- **Non-Gaussianity:** ICA exploits the non-Gaussian nature of the sources to separate them effectively.

Mathematical Process:

- ICA takes the observed mixed signals (EEG recordings) and finds a transformation that maximizes the statistical independence of the resulting components.
- Essentially, it estimates the "mixing matrix" that combines the independent sources to produce the observed data.


Example:

   - Original EEG Signal: Assume you have a mixed signal that combines true brain activity (like P300) and artifacts (like eye blinks).

   - ICA Decomposition: When you apply ICA, it separates the mixed signal into several independent components. Let’s say you have:
        - Component 1: Represents the true P300 response.
        - Component 2: Represents eye blinks (artifact).
        - Component 3: Represents muscle activity (another artifact).

   - Identifying Components: You look at the waveforms of the components. You can visually recognize Component 2 as an eye blink artifact.

   - Excluding Artifacts: You exclude Component 2 and keep Components 1 and 3.

   - Reconstruction: When you reconstruct the data using ICA without Component 2, you end up with a cleaner EEG signal that retains the true brain activity while removing the eye blink interference.

### 6. Create Events and Epochs
Identify significant events within the EEG data (e.g., stimulus presentations or participant responses) and create epochs around these events. This segmentation allows for targeted analysis of brain responses associated with specific stimuli or actions.

### 7. Baseline Correction
Implement baseline correction to adjust the EEG data for any pre-stimulus activity. This process helps remove any potential biases introduced by ongoing neural activity prior to the event of interest, ensuring that the analysis focuses on the effects of the stimulus.

### 8. Reject Bad Epochs
Evaluate the epochs for excessive artifacts or noise. Reject any epochs that do not meet quality criteria to ensure that only reliable data is included in the final analysis. This step is essential for maintaining the integrity of the results.

### 9. Averaging Epochs for P300 Extraction
Finally, average the epochs corresponding to the P300 events to extract the P300 component for further analysis. This averaging process enhances the signal-to-noise ratio, making it easier to interpret the P300 response in relation to the experimental stimuli.

---

By following these detailed steps, you will effectively pre-process your P300-related EEG data, ensuring it is ready for accurate and reliable analysis.


### When to Use LDA in EEG Analysis

While ICA is suitable for artifact removal, LDA can still play a valuable role in EEG analysis, particularly in the following scenarios:

- **Classification Tasks**: After preprocessing with ICA (removing artifacts), you can use LDA to classify different mental states or cognitive tasks based on the cleaned EEG data. For instance, if you're interested in distinguishing between different types of stimuli that evoke P300 responses, LDA can help classify these events.

- **Feature Reduction**: LDA can also be used to reduce dimensionality in high-dimensional data before classification, retaining the most discriminative features that separate classes.

Example Workflow Using Both ICA and LDA

    Data Acquisition: Record EEG data from subjects during an experiment designed to evoke P300 responses.

    Preprocessing with ICA:
        Load the raw EEG data.
        Apply ICA to separate the independent components.
        Identify and remove artifact components (e.g., EOG, EMG).
        Reconstruct the cleaned EEG data.

    Feature Extraction: Extract relevant features from the cleaned EEG data, such as event-related potentials (ERPs), power spectral features, etc.

    Classification with LDA:
        Prepare labeled data (e.g., segments corresponding to P300 vs. non-P300).
        Train the LDA classifier on the extracted features.
        Evaluate the classifier’s performance on unseen data.

## Movement Neuroscience ; EMGs and iEMG

Movement neuroscience is the study of how the brain and nervous system control body movements. It focuses on understanding motor control, coordination, and the neural mechanisms that enable movement. One key area of research is the use of electromyography (EMG), a technique that measures electrical activity in muscles. **EMGs** detect muscle activation, helping researchers analyze movement patterns and muscle function. **Intramuscular EMG (iEMG)** is a more specific variation where electrodes are inserted directly into the muscle to record more detailed activity. This technique allows for high-resolution data on muscle firing, making it useful in clinical and research settings. EMGs are widely used to study muscle disorders, rehabilitation, and motor performance. iEMG is particularly useful in understanding muscle behavior during complex or fine motor tasks. Both EMG and iEMG are essential for investigating neural control of movement, aiding in diagnoses and therapeutic interventions. I have added **two files** related to experiments involving these techniques for further study.
