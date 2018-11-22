function plot_spectrogram(fs, sig_length, title_name, magnitude)
points_frequencies = fs        /  2;
points_signal_time = sig_length / fs;
F  = linspace(0, points_frequencies, size(magnitude,1));
T  = linspace(0, points_signal_time, size(magnitude,2));

TMP  = magnitude >= 0;
TEMP = magnitude.*TMP;
Ps = 10*log10(TEMP);

surf(T,F,Ps,'edgecolor', 'none');
axis tight;

xlabel('Temp (s)');
ylabel('Frequences (Hz)');
zlabel('Power/frequency (dB/Hz)');

title(title_name, 'FontSize', 16);

view(0,90);
end