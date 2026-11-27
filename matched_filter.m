%% Experiment 4: Matched Filter and Eye Diagram
clc; clear; close all;

% --- Parameters ---
numSymbols = 1000;         % Number of symbols to transmit
sps = 8;                   % Samples per symbol (Oversampling factor)
rolloff = 0.5;             % Rolloff factor for the Raised Cosine filter
span = 6;                  % Filter span in symbols
snr_dB = 15;               % Signal-to-Noise Ratio (dB)

% 1. Generate random data (BPSK: -1 and 1)
dataBits = randi([0 1], numSymbols, 1);
symbols = 2*dataBits - 1; 

% 2. Transmit Filter (Pulse Shaping)
% A Square Root Raised Cosine (SRRC) filter is standard for matched filtering
txFilter = rcosdesign(rolloff, span, sps, 'sqrt');
% Upsample and apply the transmit filter
txSignal = upfirdn(symbols, txFilter, sps);

% 3. Channel (Add AWGN)
rxSignal = awgn(txSignal, snr_dB, 'measured');

% 4. Receiver (Matched Filter)
% The receiver filter matches the transmit filter perfectly
rxFilter = txFilter; 
% Apply matched filter and downsample back (1 output per sample)
rxMatched = upfirdn(rxSignal, rxFilter, 1, 1);

% 5. Eye Diagram Investigation
% Discard the filter transients (delay) to get a clean, aligned eye diagram
delay = span * sps; 
validRxMatched = rxMatched(delay+1 : end-delay);

% Plot the Eye Diagram
eyediagram(validRxMatched, 2*sps);
title('Eye Diagram after Matched Filtering');