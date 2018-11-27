function [mag, pha] = mod_fft(spec)
FrameSize = size(spec,2);

if rem(FrameSize,2) == 0
    FeaDim   = FrameSize    /2+1;
    hamm_w   = hamming(FrameSize,'periodic')';
else
    FeaDim   = (FrameSize-1)/2+1;
    hamm_w   = hamming(FrameSize)';
end
mag = zeros(size(spec,1), FeaDim);
pha = zeros(size(spec,1), FeaDim);

for i = 1:size(spec,1)
    tmp = fft(spec(i,:).*hamm_w);
    mag(i,:) =   abs(tmp(1:FeaDim));
    pha(i,:) = angle(tmp(1:FeaDim));
end

end

