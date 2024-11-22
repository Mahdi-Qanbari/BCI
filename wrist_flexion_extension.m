clear;
clc;
load("/MATLAB Drive/wrist_flexion_extension.mat");

 %% Task 1. Data preprocessing & visualisation
% Create individual time vectors for each signal
T = 1/fsamp ;
t_fl = (0:length(force_fl)-1) * T;
t_ex = (0:length(force_ex)-1) * T;


ConversionFactor = 0.1; 
Gravity= 9.81 ;

force_fl_n = -force_fl / ConversionFactor * Gravity;
force_ex_n = -force_ex / ConversionFactor * Gravity;

% Plot both signals on the same figure
figure;
plot(t_fl, force_fl_n, 'r'); hold on;
plot(t_ex, force_ex_n, 'b');
xlabel('Time (s)');
ylabel('Force (N)');
legend('Force FL', 'Force EX');
title('Signals with Different Lengths');





%% Task 1.3

num_channels = 32; % Number of EMG channels
interspace = 2; % Interspace value to separate the channels (mV)

% Plot all channels of EMG_raw_fl
figure;
hold on;
for ch = 1:num_channels
    plot(t_fl, EMG_raw_fl(ch, :) + (ch - 1) * interspace, 'b'); % Offset each channel
end
hold off;

% Formatting
xlabel('Time (s)');
ylabel('Channels (with offsets)');
title('EMG Flexion Channels Over Time');
yticks((0:num_channels-1) * interspace); % Adjust y-axis ticks to match channels
yticklabels(arrayfun(@(x) sprintf('Ch %d', x), 1:num_channels, 'UniformOutput', false));
grid on;

%%
% Plot all channels of EMG_raw_ex
figure;
hold on;
for ch = 1:num_channels
    plot(t_ex, EMG_raw_ex(ch, :) + (ch - 1) * interspace, 'b'); % Offset each channel
end
hold off;

% Formatting
xlabel('Time (s)');
ylabel('Channels (with offsets)');
title('EMG Extension Channels Over Time');
yticks((0:num_channels-1) * interspace); % Adjust y-axis ticks to match channels
yticklabels(arrayfun(@(x) sprintf('Ch %d', x), 1:num_channels, 'UniformOutput', false));
grid on;


%% Task 1.4 Removing noisy channels
%Flexion ---> Channels 12,13      Extension ----> channel 12

EMG_raw_fl([12, 13], :) = []; % Remove channel 5 from y1 (example)
EMG_raw_ex(12, :) = []; % Remove channels 3 and 8 from y2 (example)





% Plot all channels of updated EMG_raw_fl
figure;
hold on;
for ch = 1:size(EMG_raw_fl,1)
    plot(t_fl, EMG_raw_fl(ch, :) + (ch - 1) * interspace, 'b'); % Offset each channel
end
hold off;

% Formatting
xlabel('Time (s)');
ylabel('Channels (with offsets)');
title('EMG Flexion Channels Over Time');
yticks((0:num_channels-1) * interspace); % Adjust y-axis ticks to match channels
yticklabels(arrayfun(@(x) sprintf('Ch %d', x), 1:num_channels, 'UniformOutput', false));
grid on;



% Plot all channels of updated EMG_raw_ex
figure;
hold on;
for ch = 1:size(EMG_raw_ex,1)
    plot(t_ex, EMG_raw_ex(ch, :) + (ch - 1) * interspace, 'b'); % Offset each channel
end
hold off;

% Formatting
xlabel('Time (s)');
ylabel('Channels (with offsets)');
title('EMG Extension Channels Over Time');
yticks((0:num_channels-1) * interspace); % Adjust y-axis ticks to match channels
yticklabels(arrayfun(@(x) sprintf('Ch %d', x), 1:num_channels, 'UniformOutput', false));
grid on;


%% Task 1.5 

% Choose a channel 
channel_data = EMG_raw_fl(21,:);  % Selecting the channel

% Plot the unfiltered signal (first 2 seconds of the signal for better visualization)
time = (0:length(channel_data)-1) / fsamp;  % Time vector

% Plot the unfiltered signal
figure;
subplot(3,1,1);
plot(time, channel_data);
title('Original (Unfiltered) EMG Signal - Channel 1');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;


filtered_signal = BPF(channel_data, fsamp);
% Plot the filtered signal
subplot(3,1,2);
plot(time, filtered_signal);
title('Filtered EMG Signal - Channel 1');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;


% Compute the difference between filtered and unfiltered signals
difference_signal = channel_data - filtered_signal;

% Plot the difference
subplot(3,1,3);
plot(time, difference_signal);
title('Difference between Filtered and Unfiltered Signal');
xlabel('Time (seconds)');
ylabel('Difference in Amplitude');
grid on;


% Perform FFT on unfiltered signal
N = length(channel_data);         % Number of samples
f = (0:N-1) * (fsamp / N);        % Frequency vector
unfiltered_fft = abs(fft(channel_data));  % FFT of the unfiltered signal

% Perform FFT on filtered signal
filtered_fft = abs(fft(filtered_signal));  % FFT of the filtered signal

% Plot FFT results
figure;

% Plot FFT of unfiltered signal (subplot 1)
subplot(2,1,1);
plot(f(1:floor(N/2)), unfiltered_fft(1:floor(N/2)));  % Plot only the positive frequencies
title('Frequency Spectrum of Unfiltered EMG Signal - Channel 1');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% Plot FFT of filtered signal (subplot 2)
subplot(2,1,2);
plot(f(1:floor(N/2)), filtered_fft(1:floor(N/2)));  % Plot only the positive frequencies
title('Frequency Spectrum of Filtered EMG Signal - Channel 1');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;


%% Task 1.6 

% Choose an exemplary channel for EMG (e.g., channel )
emg_channel_data = EMG_raw_fl(5, :);  % Replace 5 with the desired channel index

% Define the corresponding force signal
force_signal = force_fl_n;  %  force_data in Newton

% Generate time vector (assuming same fsamp for both signals)
N_emg = length(emg_channel_data);
N_force = length(force_fl_n);

time_emg = (0:N_emg-1) / fsamp;  % Time vector for EMG
time_force = (0:N_force-1) / fsamp;  % Time vector for force

% Ensure both signals cover the same time range (truncate longer signal if needed)
min_length = min(length(time_emg), length(time_force));
time_emg = time_emg(1:min_length);
time_force = time_force(1:min_length);
emg_channel_data = emg_channel_data(1:min_length);
force_signal = force_signal(1:min_length);

% Plot with two y-axes
figure;
yyaxis left;
plot(time_emg, emg_channel_data, 'b');
xlabel('Time (seconds)');
ylabel('Filtered EMG (mV)');
title('Filtered EMG and Force Signal');
grid on;

yyaxis right;
plot(time_force, force_signal, 'r');
ylabel('Force (N)');
legend({'Filtered EMG', 'Force Signal'}, 'Location', 'best');



%% Task 2. Force steadiness 
% [start: end time ] = 8.5 sec until 19 sec
flat_fl = force_fl_n(8.5*2000 : 19*2000) ;
CV_fl = std (flat_fl) / mean(flat_fl) * 100;

flat_ex = force_ex_n(8.5*2000 : 19*2000)  ;
CV_ex = std (flat_ex) / mean(flat_ex) * 100;

CV = table(CV_fl, CV_ex);
disp(CV);


%% Task 3. Rate of Force Development

% force signals 
force_signal1 = force_fl_n; % flexion force signal
force_signal2 = force_ex_n; % extension force signal
%fsamp = fsamp    ;              % Sampling frequency in Hz
window_size = 1000;             % Window size in ms

% Call the relevant function
calculate_and_plot_rfd(force_signal1, force_signal2, fsamp, window_size);





%% Task 4.1 Root-Mean-Square (RMS) of EMG across all channels
% Flexion RMS

signal_rms_fl  = channel_rms(EMG_raw_fl, fsamp);
% Extension RMS
signal_rms_ex  = channel_rms(EMG_raw_ex, fsamp);


 
%% Task 4.2 Move Mean

% Window length in samples corresponding to 400 ms
window_length = round(0.4 * fsamp);  % 400 ms window

% Apply moving average (window length corresponds to 400 ms)
rms_moving_avg_fl = movmean(signal_rms_fl, window_length);
rms_moving_avg_ex = movmean(signal_rms_ex, window_length);

% Define time vector based on the number of samples in the signal
time_fl = (0:length(signal_rms_fl)-1) / fsamp;  % Time vector for Flexion signal
time_ex = (0:length(signal_rms_ex)-1) / fsamp;  % Time vector for Extension signal
% Plot the original RMS and moving average
figure;
subplot(2,2,1);
plot(time_fl, signal_rms_fl, 'LineWidth', 1.5);
title('EMG Flexion_RMS_Across All Channels');
xlabel('Time (s)');
ylabel('RMS Amplitude (mV)');
grid on;

subplot(2,2,2);
plot(time_fl, rms_moving_avg_fl, 'LineWidth', 1.5, 'Color', 'r');
title('EMG Flexion (Moving Average )');
xlabel('Time (s)');
ylabel('RMS Amplitude (mV)');
grid on;


% Plot the original RMS and moving average

subplot(2,2,3);
plot(time_ex, signal_rms_ex, 'LineWidth', 1.5);
title(' EMG Extension_RMS_Across All Channels');
xlabel('Time (s)');
ylabel('RMS Amplitude (mV)');
grid on;

subplot(2,2,4);
plot(time_ex, rms_moving_avg_ex, 'LineWidth', 1.5, 'Color', 'r');
title('EMG Extension (Moving Average )');
xlabel('Time (s)');
ylabel('RMS Amplitude (mV)');
grid on;
%% Task 4.3 Correlation btw signal_rms and force_signal

% Normalize the RMS and Force signals ( Flexion)
normalized_rms_fl = (rms_moving_avg_fl - mean(rms_moving_avg_fl)) / std(rms_moving_avg_fl);
normalized_force_fl = (force_fl_n - mean(force_fl_n)) / std(force_fl_n);

% correlation coefficient between normalized RMS and Force
R_fl = corr(normalized_rms_fl', normalized_force_fl);  % Transpose if needed to match dimensions


% Normalize the RMS and Force signals ( Extension)
normalized_rms_ex = (rms_moving_avg_ex - mean(rms_moving_avg_ex)) / std(rms_moving_avg_ex);
normalized_force_ex = (force_ex_n - mean(force_ex_n)) / std(force_ex_n);

% Compute the correlation coefficient between normalized RMS and Force
R_ex = corr(normalized_rms_ex', normalized_force_ex);  % Transpose if needed to match dimensions



% plot to visualize the correlation (Flexion)
figure;
subplot(2,1,1);
scatter(normalized_rms_fl, normalized_force_fl, 1, 'filled');
title(['Task 4.3: Wrist Flexion – Correlation – R = ' num2str(R_fl, '%.3f')]);
xlabel('Normalized RMS');
ylabel('Normalized Force');
grid on;



% plot to visualize the correlation (Extension)
subplot(2,1,2);
scatter(normalized_rms_ex, normalized_force_ex, 1, 'filled');
title(['Task 4.3: Wrist Extension – Correlation – R = ' num2str(R_ex, '%.3f')]);
xlabel('Normalized RMS');
ylabel('Normalized Force');
grid on;





%% Functions
function filtered_signal = BPF(channel_data, fsamp)

    % Design a bandpass filter (e.g., 20 Hz to 500 Hz)
    low_cutoff = 15;  % Low cutoff in Hz
    high_cutoff = 500;  % High cutoff in Hz
    
    % Normalize the cutoff frequencies by dividing by Nyquist frequency (fsamp/2)
    low_cutoff_norm = low_cutoff / (fsamp / 2);
    high_cutoff_norm = high_cutoff / (fsamp / 2);
    
    % Create a 5th order Butterworth bandpass filter
    [b, a] = butter(5, [low_cutoff_norm, high_cutoff_norm], 'bandpass');
    
    % Apply the filter to the selected channel data using filtfilt (zero-phase filtering)
    filtered_signal = filtfilt(b, a, channel_data);

end




function calculate_and_plot_rfd(force_signal1, force_signal2, fsamp, window_size)
    % Inputs:
    % - force_signal1: First force signal (vector)
    % - force_signal2: Second force signal (vector)
    % - fsamp: Sampling frequency (Hz)
    % - window_size: Window size for RFD calculation in milliseconds
    
    % Parameters
    samples_per_window = fsamp * (window_size / 1000); % Convert window size to samples
    dt = window_size / 1000;                          % Time window in seconds
    
    % Calculate RFD for both signals
    [RFD1, time_RFD1] = compute_rfd(force_signal1, samples_per_window, dt, fsamp);
    [RFD2, time_RFD2] = compute_rfd(force_signal2, samples_per_window, dt, fsamp);
    
    % Plot the results
    figure;
    hold on;
    plot(time_RFD1, RFD1, 'b', 'LineWidth', 1.5, 'DisplayName', 'Force Signal 1');
    plot(time_RFD2, RFD2, 'r', 'LineWidth', 1.5, 'DisplayName', 'Force Signal 2');
    title('Rate of Force Development (RFD) for Two Force Signals');
    xlabel('Time (s)');
    ylabel('RFD (N/s)');
    legend('show');
    grid on;
    hold off;
end

function [RFD, time_RFD] = compute_rfd(force_signal, samples_per_window, dt, fsamp)
    % Helper function to compute RFD for a single force signal
    num_windows = floor(length(force_signal) / samples_per_window) - 1;
    RFD = zeros(1, num_windows); % Preallocate RFD array
    time_RFD = zeros(1, num_windows); % Preallocate time array
    
    for i = 1:num_windows
        start_idx = (i - 1) * samples_per_window + 1; % Start of the window
        end_idx = start_idx + samples_per_window - 1; % End of the window
        
        if end_idx > length(force_signal)
            break; % Ensure we don't exceed the signal length
        end
        
        % Calculate force difference and RFD
        delta_force = force_signal(end_idx) - force_signal(start_idx);
        RFD(i) = delta_force / dt; % RFD in N/s
        
        % Time at the center of the window
        time_RFD(i) = (start_idx + end_idx) / 2 / fsamp; % Time in seconds
    end
end



function signal_rms  = channel_rms(signal, fsamp)     
    % Dimensions
  
    [num_channels, num_samples] = size(signal);
    signal_squared = zeros(1,num_samples) ; 
    
    for i =1 : num_channels
        filtered_signal(i, :) = BPF(signal(i, :), fsamp);
        %squared
        filtered_signal(i, :) = filtered_signal(i, :).^2 ;
        %summed
        signal_squared = signal_squared + filtered_signal(i, :);
    
    end
    
    signal_rms = sqrt(signal_squared / num_channels) ; 
end
