
clc; clear; close all;
% This base signal (tone + interference + noise) is reused by the
% Spectrum and Time Domain sections below.
fs = 1000;                  % Sampling frequency (Hz)
t  = 0:1/fs:1-1/fs;         % Time vector, 1 second
f1 = 50;                    % Desired signal frequency (Hz)
f2 = 120;                   % Interfering tone frequency (Hz)
x = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.2*randn(size(t));
%%
figure('Name','Spectrum Analysis');
subplot(2,1,1);
periodogram(x, [], [], fs);
title('Spectrum Analysis - Periodogram');
%%
subplot(2,1,2);
pwelch(x, [], [], [], fs);
title('Spectrum Analysis - Welch PSD (smoother estimate)');
%%
envelope_sig = abs(hilbert(x));
figure('Name','Time Domain Analysis');
subplot(2,1,1);
plot(t, x); title('Time Domain Signal'); xlabel('Time (s)'); ylabel('Amplitude');
%
subplot(2,1,2);
plot(t, envelope_sig); title('Signal Envelope (via Hilbert Transform)');
xlabel('Time (s)'); ylabel('Envelope');
%%
    M = 16;                                 % 16-QAM
    numSymbols = 1000;
    dataSymbols = randi([0 M-1], numSymbols, 1);
    refConst = qammod(0:M-1, M, 'UnitAveragePower', true);
    txSignal = qammod(dataSymbols, M, 'UnitAveragePower', true);
    snr_dB = -10;   % <-- change this (try 10, 15, 25) and re-run to see the effect
    rxSignal = awgn(txSignal, snr_dB, 'measured');
    constDiagram = comm.ConstellationDiagram( ...
        'ShowReferenceConstellation', true, ...
        'ReferenceConstellation', refConst, ...
        'Title', sprintf('Constellation Diagram (SNR = %d dB)', snr_dB));
    constDiagram(rxSignal);
    evm = comm.EVM('ReferenceSignalSource', 'Estimated from reference constellation', ...
        'ReferenceConstellation', refConst);
    rmsEVM = evm(rxSignal);

    ccdfObj = comm.CCDF('PAPROutputPort', true);
    [ccdfY, ccdfX, paprValue] = ccdfObj(txSignal);
    figure('Name','CCDF');
    plot(ccdfObj);
    title('CCDF Curve');
   %
    M_psk = 2;                 % QPSK
    numSym = 2000;
    sps = 8;                   % samples per symbol
    dataE = randi([0 M_psk-1], numSym, 1);
    modSig = pskmod(dataE, M_psk, pi/4);
    rrcFilter = rcosdesign(0.35, 6, sps);
    txUpsampled = upsample(modSig, sps);
    txPulse = conv(txUpsampled, rrcFilter, 'same');
    % Try adding noise here to see the eye close:
    %txPulse = awgn(txPulse, 15, 'measured');
    figure('Name','Eye Diagram');
    subplot(2,1,1);
    eyediagram(real(txPulse(1:1000)), sps*2);
    title('Eye Diagram');
%%
fs2 = 1000;
t2 = 0:1/fs2:2;
chirpSig = chirp(t2, 50, 2, 200);   % sweeps 50 Hz -> 200 Hz over 2 s
figure('Name','Joint Time-Frequency Analysis');
spectrogram(chirpSig, 128, 120, 128, fs2, 'yaxis');
title('Joint Time-Frequency Analysis - Spectrogram');
%%
N = 8;
walsh = hadamard(N);
corrMatrix = (walsh * walsh') / N;
figure('Name','Code Domain Analysis');
imagesc(abs(corrMatrix)); colorbar;
title('Code Domain Power - Walsh Code Orthogonality');
xlabel('Code Index'); ylabel('Code Index');
%%
fs3 = 1000;
t3 = 0:1/fs3:1-1/fs3;
fc = 100;
symbolRate = 20;
xCyc = cos(2*pi*fc*t3) .* square(2*pi*symbolRate*t3);
alpha = 2*fc;    % candidate cyclic frequency to test
cyclicCorr = mean(xCyc .* exp(-1j*2*pi*alpha*t3));

    array = phased.ULA('NumElements', 8, 'ElementSpacing', 0.5);
    fc2 = 3e8;
    incidentAngle = 30;   % degrees, true direction of arrival
    x_arr = sensorsig(getElementPosition(array)/physconst('LightSpeed'), ...
        200, incidentAngle, 0.1);
    musicEstimator = phased.MUSICEstimator('SensorArray', array, ...
        'OperatingFrequency', fc2, 'ScanAngles', -90:90, ...
        'DOAOutputPort', true, 'NumSignalsSource', 'Property', 'NumSignals', 1);
    [~, ang] = musicEstimator(x_arr);
    figure('Name','Angular Domain Analysis');
    plotSpectrum(musicEstimator);
    title('Angular Domain Analysis - MUSIC Spectrum');