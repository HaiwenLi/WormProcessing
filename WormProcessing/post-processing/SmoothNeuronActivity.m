function F = SmoothNeuronActivity(data)
% smooth one-dimensional data

% Default frame rate is 24Hz
FrameRate  = 24;
winsize = 2*FrameRate;

T = length(data);
% F = smooth(data,winsize,'moving');
F = smooth(data,winsize/T,'rlowess');
% F = smoothts(data, 'e', winsize);

% F = sgolayfilt(data,3,2*floor(winsize/2)+1);
% F = medfilt1(F,winsize);
end