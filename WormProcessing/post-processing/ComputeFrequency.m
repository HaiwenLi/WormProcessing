function freq = ComputeFrequency(activity,delta_time)
% Compute the frequency of fluctuation signal by FFT
% 
% Input parameters:
% delta_time: the sampling interval in activity

N = length(activity);
fft_activity = abs(fftshift(fft(activity)));
if mod(N-1,2) == 0 % N is odd
    center = (N+1)/2;
    offset = 0;
elseif mod(N,2) == 0  % N is even
    center = N/2 + 1;
    offset = 1;
end
half_signal = fft_activity(center:end);
half_signal(1) = 0; % remove center signal
half_len = find(half_signal == max(half_signal));
freq = (half_len-offset)/(N*delta_time);

% disp(['Frequency: ' num2str(freq)]);
end