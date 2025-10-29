# -EEG-Spectrum
  EEG Power Spectrum Analysis Script
This MATLAB script computes and visualizes the EEG power spectrum based on data stored in an EEGLAB .set file. Power Spectral Density (PSD) is estimated using Welch’s method for each epoch and channel, averaged across all channels and epochs, and then log-transformed (log10) for visualization.
⚠️ Important note: The logarithmic transformation in this analysis uses log10(P) and not 10 * log10(P). This means that the plotted values are in log-scale power units, not in decibels (dB). This choice was made to preserve the relative power distribution while avoiding amplitude scaling.
