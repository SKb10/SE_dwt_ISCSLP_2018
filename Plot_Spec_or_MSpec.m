function Plot_Spec_or_MSpec(plot_data_mode, plot_angle_setup, ...
                            fs, frame_rate, sig_length, ...
                            magnitude, title_str)
points_frequencies = fs         /  2;
points_signal_time = sig_length / fs;
F = linspace(0, points_frequencies, size(magnitude,1));

if contains(lower(plot_data_mode), 'modulation')
    bandwidth_of_mod = (fs/frame_rate)/2;
    T  = linspace(0, bandwidth_of_mod, size(magnitude,2));
    xlabel_str = 'Modulation Frequences (Hz)';
elseif contains(lower(plot_data_mode), 'spectrogram')
    T  = linspace(0, points_signal_time, size(magnitude,2));
    xlabel_str = 'Time (s)';
else
    warning('out of option, pause')
    pause
end

tmp  = magnitude >= 0;
temp = magnitude.*tmp;
Ps = 10*log10(temp);

surf(T,F,Ps,'edgecolor', 'none');
axis tight;

xlabel(xlabel_str);
ylabel('Frequences (Hz)');
zlabel('Power/frequency (dB/Hz)');
title(title_str);

if plot_angle_setup == 0
    view(0,  90);
elseif plot_angle_setup == 1
    view(135,30);
end

end