# BCI_Data_Analysis

## Table of Contents
1. [What Are Events in EEG Data?](#what-are-events-in-eeg-data)
2. [Why Are Events Important?](#why-are-events-important)
3. [Understanding Event Data Structure](#understanding-event-data-structure)
4. [Step-by-Step Example: Plotting Raw EEG Data with Events](#step-by-step-example-plotting-raw-eeg-data-with-events)
   - 1. Import Necessary Libraries
   - 2. Load Your EEG Data
   - 3. Inspect and Extract Events
   - 4. Create an MNE Raw Object
   - 5. Format Events for MNE
   - 6. Plotting the Raw EEG Data with Events
5. [P300 Pre-processing Steps](#p300-pre-processing-steps)

---

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

## Step-by-Step Example: Plotting Raw EEG Data with Events

### 1. Import Necessary Libraries
```python
import numpy as np
import mne
import matplotlib.pyplot as plt

## P300 Pre-processing Steps

This section outlines the steps necessary for pre-processing P300-related EEG data. Each step is crucial for preparing your data for subsequent analysis.

### 1. Load and Inspect the Data
Begin by loading your EEG data and inspecting it for any artifacts or irregularities. This initial review helps identify potential issues that may affect the analysis.

### 2. Filter the Data
Apply a band-pass filter to isolate the frequency range where the P300 component typically occurs (0.1 Hz to 30 Hz). Filtering helps enhance the relevant brain signals while minimizing noise.

### 3. Identify and Mark Bad Channels
Inspect the data to identify any bad channels, which should be marked for exclusion during analysis. This step is essential for ensuring data quality and reliability.

### 4. Re-reference the Data
Re-referencing involves adjusting the voltage measurements of EEG channels based on the average or another reference channel. This process improves signal clarity and reduces noise.

- **Purpose:**
  - **Minimize Noise:** Reduces artifacts from specific channels, enhancing signal quality.
  - **Improve Spatial Resolution:** Aids in identifying brain activity related to cognitive processes, such as the P300.
  - **Ensure Consistency:** Standardizes signals across different recordings and subjects, allowing for valid comparisons.

- **Common Referencing Strategies:**
  - **Average Reference:** Utilizes the average of all channel recordings.
  - **Linked Ears:** Averages signals from both ear electrodes.
  - **Common Reference:** Uses a specific electrode (e.g., Cz) as a reference for all other electrodes.

### 5. Artifact Removal Using ICA
Independent Component Analysis (ICA) is employed to remove artifacts from EEG data. ICA operates under the assumptions of statistical independence and non-Gaussianity of the underlying sources.

### 6. Create Events and Epochs
Identify events of interest within the EEG data and create epochs around these events for further analysis. This segmentation allows for a more focused study of brain responses related to specific stimuli.

### 7. Baseline Correction
Apply baseline correction to adjust the data for pre-stimulus activity. This step helps to account for any pre-existing electrical activity that could skew the results.

### 8. Reject Bad Epochs
Identify and reject epochs that contain excessive artifacts. This quality control step ensures that only clean, reliable data is used for analysis.

### 9. Averaging Epochs for P300 Extraction
Finally, average the epochs to extract the P300 component for analysis. This averaging process helps enhance the signal-to-noise ratio, allowing for clearer interpretation of the P300 response.

---

By following these steps, you will effectively pre-process your P300-related EEG data, preparing it for reliable analysis.
