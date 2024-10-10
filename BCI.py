import scipy.io as sio
import numpy as np
import mne
from mne.preprocessing import ICA, create_eog_epochs
import matplotlib.pyplot as plt
# Load the data
mat = sio.loadmat('/home/mahdi/Downloads/p300/S1.mat')
eeg_data = mat['y']
trig = mat['trig'].flatten()
sfreq = 250
n_channels = eeg_data.shape[1]
channel_names = [f'y{i}' for i in range(n_channels)]
info = mne.create_info(ch_names=channel_names, sfreq=sfreq, ch_types=['eeg'] * n_channels)
raw = mne.io.RawArray(eeg_data.T, info)

# Filter the data
raw.filter(l_freq=0.1, h_freq=30.0, fir_design='firwin')

# Mark bad channels
channel_variances = np.var(raw.get_data(), axis=1)
threshold = np.mean(channel_variances) + 2 * np.std(channel_variances)
bad_channels = [ch for ch, var in zip(raw.ch_names, channel_variances) if var > threshold]
raw.info['bads'].extend(bad_channels)

# Re-reference the data
raw.set_eeg_reference('average')

# Remove artifacts using ICA
ica = ICA(n_components=7, random_state=97, max_iter='auto')
ica.fit(raw)
eog_indices, eog_scores = ica.find_bads_eog(raw)
ica.exclude = eog_indices
ica.apply(raw)

# Create events and epochs
event_id = {'target': 1, 'non-target': 2}  # Adjust as needed
events = np.column_stack((np.where(trig == 1)[0], np.zeros_like(trig[trig == 1]), np.ones_like(trig[trig == 1])))
tmin = -0.2
tmax = 0.8
epochs = mne.Epochs(raw, events, event_id=event_id, tmin=tmin, tmax=tmax, baseline=(None, 0), preload=True)

# Reject bad epochs
reject_criteria = dict(eeg=100e-6)
epochs.drop_bad(reject=reject_criteria)

# Average epochs to extract P300
p300_average = epochs['target'].average()
p300_average.plot()
plt.show()
