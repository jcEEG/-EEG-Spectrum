%% ------------------------------------------------------------------------
%  EEG Power Spectrum Analysis Script
%  Author: [jin chen]
%  Date: 2025-10-29
%
%  Description:
%  This script loads EEG data from an EEGLAB .set file, computes the
%  power spectral density (PSD) for each epoch and channel using Welch's method,
%  averages across channels and epochs, and plots the grand-average
%  log-transformed power spectrum.
%
%  Requirements:
%  - MATLAB R2021b or later
%  - EEGLAB toolbox installed and added to the MATLAB path
% ------------------------------------------------------------------------

clear; clc; close all;

%% ------------------------- User Parameters ------------------------------
data_path = 'C:\Users\32487\Desktop\谐波letter\数据\6种载体\rn.set';  % Path to EEG dataset
fs = 250;           % Sampling rate (Hz)
plot_xlim = [0 94]; % Frequency range for plotting (Hz)
plot_ylim = [2 12]; % Power (log10) range for plotting
font_size = 28;     % Font size for axis labels and ticks
% ------------------------------------------------------------------------

%% ------------------------- Load EEG Data --------------------------------
EEG = pop_loadset(data_path);
fprintf('Loaded dataset: %s\n', EEG.setname);

n_epochs   = EEG.trials;
n_channels = size(EEG.data, 1);

%% ------------------------- Compute Power Spectrum ------------------------
% Precompute frequency vector using one channel
[Pxx, F] = pwelch(EEG.data(1, :, 1)', [], [], [], fs);
n_freqs = length(F);

powers = zeros(n_freqs, n_epochs);

for i = 1:n_epochs
    epoch_power = zeros(n_freqs, 1);
    for ch = 1:n_channels
        data = EEG.data(ch, :, i);
        [Pxx, ~] = pwelch(data', [], [], [], fs);
        epoch_power = epoch_power + Pxx;
    end
    powers(:, i) = log10(epoch_power / n_channels); % Average across channels
end

avg_power = mean(powers, 2); % Average across epochs

%% ------------------------- Plotting -------------------------------------
figure('Color', 'w');
plot(F, avg_power, 'k', 'LineWidth', 2);

xlabel('Frequency (Hz)', 'FontSize', font_size, ...
    'FontWeight', 'bold', 'FontName', 'Times New Roman');
ylabel('Power (log_{10} μV^2/Hz)', 'FontSize', font_size, ...
    'FontWeight', 'bold', 'FontName', 'Times New Roman');

xlim(plot_xlim);
ylim(plot_ylim);
set(gca, 'XTick', 0:20:plot_xlim(2));
set(gca, 'YTick', plot_ylim(1):2:plot_ylim(2));
set(gca, 'Box', 'off', ...
         'FontSize', font_size, ...
         'FontWeight', 'bold', ...
         'FontName', 'Times New Roman', ...
         'XColor', 'k', 'YColor', 'k', ...
         'LineWidth', 1.5, ...
         'TickDir', 'out');
grid off;

title('Average EEG Power Spectrum', ...
    'FontSize', font_size, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

%% ------------------------- Save Figure ----------------------------------
saveas(gcf, 'EEG_Power_Spectrum.png');
fprintf('Figure saved as EEG_Power_Spectrum.png\n');
