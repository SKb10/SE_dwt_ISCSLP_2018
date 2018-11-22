fclose all;clear;close all;clc;
% Clear everything

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
[mag, pha] = get_Spectrogram(y, 512, 256);
% get magnitude and phase spectorgrams
% set frame size as 512 points
% set frame rate as 256 points(Overlap 50%)

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
subplot(131)
plot_spectrogram(fs, length(y), 'Log Spectrogram', mag)
% plot spectorgram in log scale

subplot(132)
plot_spectrogram(fs, length(y), 'reconstruction from ca', mag_ca_only)
% reconstruction of approximation coefficients

subplot(133)
plot_spectrogram(fs, length(y), 'reconstruction from cd', mag_cd_only)
% reconstruction of detail coefficients
