function ph = CalculatePhase(activity)

frame_rate = 24;

N = size(activity,1);
L = size(activity,2);
% phase_lag = zeros(N-1,1);
% for i=1:N-1
%     phase_lag(i) = phdiffmeasure(activity(i,:),activity(i+1,:));
% %     phase_lag(i) = mod(phase_lag(i),2*pi);
% end

ph = zeros(N,1);
F = zeros(N,1);
win = rectwin(L);
for i=1:N
    y = activity(i,:);
    y = y - mean(y);
    Y = fft(y'.*win);
    [~, indy] = max(abs(Y));
    F(i) = ComputeFrequency(y,1/frame_rate);
    ph(i) = angle(Y(indy));
end
% fs = (-L/2:L/2-1)*frame_rate/L;

% imagesc(ph');
% set(gca,'ytick',0:L/frame_rate:L);
% set(gca,'yticklabel',-frame_rate/2:frame_rate/2);
% ylabel('Frequency (Hz)');
% ylabel('Phase/\pi');
plot(ph);
figure;plot(F);
end