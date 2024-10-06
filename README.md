# BCI
BCI_Data_Analysis


Table of Contents

    What Are Events in EEG Data?
    Why Are Events Important?
    Understanding Event Data Structure
    Step-by-Step Example: Plotting Raw EEG Data with Events
        1. Import Necessary Libraries
        2. Load Your EEG Data
        3. Inspect and Extract Events
        4. Create an MNE Raw Object
        5. Format Events for MNE
        6. Plotting the Raw EEG Data with Events
        
    P300 Pre-processing Steps





What Are Events in EEG Data?

Events in EEG data are markers or annotations that indicate specific moments during the recording when something of interest occurs. These can be:

    Stimuli Presentations: Such as visual or auditory cues presented to the participant.
    Participant Responses: Button presses, key presses, or other responses.
    System Triggers: Internal signals from the EEG recording system marking particular points in time.
    External Events: Any significant occurrence you want to analyze in relation to the EEG data.

Visual Representation

Imagine you have an EEG recording session where participants are shown images and asked to respond by pressing a button. Each time an image is shown, an event marker is recorded. Later, you can analyze the EEG data segments (epochs) around these markers to study brain responses to the images.
Why Are Events Important?

Events are crucial for several reasons:

    Segmentation: They allow you to segment continuous EEG data into meaningful epochs (e.g., before, during, and after a stimulus).
    Analysis: You can perform event-related analyses, such as Event-Related Potentials (ERPs), which average EEG responses time-locked to events.
    Synchronization: Events help synchronize EEG data with other data sources (e.g., behavioral responses, video recordings).

Without event markers, it would be challenging to relate EEG signals to specific experimental conditions or stimuli.
Understanding Event Data Structure

In MNE, events are typically represented as a NumPy array with shape (n_events, 3), where each row corresponds to an event and contains three integers:

    Sample Number: The exact point in the EEG data (in samples) when the event occurred.
    Previous Event ID: Usually set to 0. It's reserved for specific uses but not commonly used.
    Event ID: An integer that uniquely identifies the type of event.


P300 Pre-processing Steps

Here’s a comprehensive guide for pre-processing your P300-related EEG data:

1.Load and Inspect the Data
2.Filter the Data:
    Applying a band-pass filter helps to focus on the frequency range where the P300 component typically resides (0.1 Hz to 30 Hz).
3.Identify and Mark Bad Channels 
4.Re-reference the Data:
    Re-referencing involves adjusting the voltage measurements of EEG channels based on the average or another reference channel. This means that the recorded EEG signals from each electrode are        recalibrated relative to a chosen reference point.
    Purpose:
        Minimize Noise: The reference electrode may pick up noise or artifacts that can skew results. By re-referencing, you can minimize this noise and improve the clarity of the signal.
        Improve Spatial Resolution: Re-referencing can enhance the spatial resolution of your data, making it easier to identify brain activity related to specific cognitive processes, such as the          P300.
        Consistency: It helps to standardize the signals across different recordings and subjects, making comparisons more valid.
    Common Referencing Strategies
        Average Reference: This involves taking the average of all channel recordings and using it as a reference. This is common in many studies, including those analyzing P300, because it can             help reduce the impact of noise from specific channels.
        Linked Ears: In this method, the signals from both ear electrodes are averaged and used as the reference.
        Common Reference: A specific electrode (like Cz) is used as a reference for all other electrodes.
    
5. Artifact Removal Using ICA:
    Assumptions:
    Statistical Independence: ICA assumes that the sources (e.g., brain signals, artifacts) are statistically independent from each other.
    Non-Gaussianity: The sources must have a non-Gaussian distribution. ICA uses this property to separate the signals.
    Mathematical Process:
    ICA takes the observed mixed signals (EEG recordings) and finds a transformation that maximizes the statistical independence of the resulting components.
    Essentially, it estimates the "mixing matrix" that combines the independent sources to produce the observed data.
   
7. Create Events and Epochs
7.Baseline Correction
8.Reject Bad Epochs
9.Averaging Epochs for P300 Extraction
