function [mag, pha] = get_Spectrogram(wave, FrameSize, FrameRate)

if rem(FrameSize,2) == 0
    FeaDim   = FrameSize    /2+1;
    hamm_w   = hamming(FrameSize,'periodic')';
else
    FeaDim   = (FrameSize-1)/2+1;
    hamm_w   = hamming(FrameSize)';
end


wav_len  = length(wave);
ncols    = ceil((wav_len - FrameSize)/FrameRate) + 1;
Spectra  = zeros(FeaDim,ncols);

Waveform = [wave; zeros(FrameSize,1)];
TEMP     = zeros(ncols,FrameSize);
for j = 1:ncols
    TEMP(j,:) = Waveform(1+(j-1)*FrameRate:(j-1)*FrameRate+FrameSize);
end

for j = 1:ncols
    TEMP_fft     = fft(TEMP(j,:).*hamm_w);
    Spectra(:,j) = TEMP_fft(1:FeaDim);
end
mag =   abs(Spectra);
pha = angle(Spectra);

end
