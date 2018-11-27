%% Clear everything
fclose all;clear;close all;clc;

%% prepare audio
% https://www.mathworks.com/help/matlab/import_export/
% record-and-play-audio.html
% Record audio for demo
recObj = audiorecorder(16000,16,1,1);
disp('Start speaking.')
recordblocking(recObj, 3);
disp('End of Recording.');
y  = getaudiodata(recObj); % signal
fs = recObj.SampleRate;    % samplerate

%% prepare spectrogram
FrameSize = 256;
FrameRate = 512;
% set frame size as 512 points
% set frame rate as 160 points(10 ms)

[mag, ~] = get_Spectrogram(y, FrameRate, FrameSize);
% get magnitude and phase spectorgrams

%% plot
plot_data_mode = 'spectrogram';
plot_angle_setup = 0;
sig_length = length(y);
subplot(231)
Plot_Spec_or_MSpec(plot_data_mode, plot_angle_setup, ...
                   fs, FrameRate, sig_length, mag, ...
                   'spectrogram')
subplot(234)
plot_data_mode = 'modulation';
[mod_mag, ~] = mod_fft(mag);
Plot_Spec_or_MSpec(plot_data_mode, plot_angle_setup, ...
                   fs, FrameRate, sig_length, mod_mag, ...
                   'moddulation spectrum of spectrogram')

%% dwt and idwt
wname = 'bior3.7'; % wavelet name
ca = zeros(size(mag,1), length(dwt(mag(1,:), wname)));
cd = zeros(size(ca));
% preallocate for dwt

for i = 1:size(mag,1)
    [ca(i,:), cd(i,:)] = dwt(mag(i,:), wname);
end
% ca: approximation coefficients
% cd: detail        coefficients

mag_ca_only = zeros(size(mag));
mag_cd_only = zeros(size(mag));
% preallocate recovered spectrogram

for i = 1:size(mag,1)
    tmp_ca = idwt(ca(i,:),      [], wname);
    tmp_cd = idwt(     [], cd(i,:), wname);
    % discard if there is a extra point
    mag_ca_only(i,:) = tmp_ca(1:size(mag,2));
    mag_cd_only(i,:) = tmp_cd(1:size(mag,2));
end

%% plot
plot_data_mode = 'spectrogram';
subplot(232)
Plot_Spec_or_MSpec(plot_data_mode, plot_angle_setup, ...
                   fs, FrameRate, sig_length, ca, ...
                   'approximation coefficients')
subplot(235)
Plot_Spec_or_MSpec(plot_data_mode, plot_angle_setup, ...
                   fs, FrameRate, sig_length, cd, ...
                   'detail coefficients')
 
subplot(233)
Plot_Spec_or_MSpec(plot_data_mode, plot_angle_setup, ...
                   fs, FrameRate, sig_length, mag_ca_only, ...
                   'reconstruct with approximation coefficients only')
subplot(236)
Plot_Spec_or_MSpec(plot_data_mode, plot_angle_setup, ...
                   fs, FrameRate, sig_length, mag_cd_only, ...
                   'reconstruct with detail coefficients only')