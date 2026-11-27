
%% ECE COMMUNICATION SYSTEMS LAB
% Experiment:
% 1. Generation of PN sequence using LFSR
% 2. Performance analysis of CDMA systems
% 3. Performance analysis of RAKE receiver
%
% Metrics: PN autocorrelation and BER versus Eb/N0
% Modulation: BPSK
% Channel models: AWGN and frequency-selective multipath
%
% The code uses MATLAB base functions for the core simulations.

clc;
clear;
close all;
rng(10);                    % Reproducible results

%% ============================================================
% PART 1: GENERATION OF PN SEQUENCE
% =============================================================

disp('PART 1: PN Sequence Generation');

m = 5;                      % Number of LFSR stages
L = 2^m - 1;                % Maximum sequence length
taps = [1 4];               % Feedback tap positions
seed = ones(1,m);           % Non-zero initial state

% Generate binary PN sequence
pnBits = generatePN(m, taps, seed, L);

% Convert binary sequence {0,1} to bipolar sequence {-1,+1}
pn = 2*pnBits - 1;

fprintf('Number of LFSR stages = %d\n', m);
fprintf('Theoretical maximum period = %d chips\n', L);
fprintf('Generated sequence length = %d chips\n', length(pn));
fprintf('Number of ones = %d\n', sum(pnBits));
fprintf('Number of zeros = %d\n', L-sum(pnBits));

disp('Generated binary PN sequence:');
disp(pnBits);

% Circular autocorrelation of bipolar PN sequence
Rpn = real(ifft(abs(fft(pn)).^2))/L;

figure('Name','PN Sequence Generation','Color','w');

subplot(2,1,1);
stairs(0:L-1, pnBits, 'LineWidth', 1.2);
grid on;
xlabel('Chip Index');
ylabel('PN Bit');
title('Generated Binary PN Sequence');
ylim([-0.2 1.2]);

subplot(2,1,2);
stem(0:L-1, Rpn, 'filled');
grid on;
xlabel('Circular Lag (chips)');
ylabel('Normalized Autocorrelation');
title('Circular Autocorrelation of Bipolar PN Sequence');

%% ============================================================
% PART 2: PERFORMANCE ANALYSIS OF CDMA SYSTEM
% =============================================================

disp('PART 2: CDMA Performance Analysis');

K = 3;                      % Number of active users
SF = L;                     % Spreading factor
numBits = 10000;            % Information bits per user

EbN0dB = 0:2:14;            % Eb/N0 in dB
numSNR = length(EbN0dB);

% Construct user-specific PN spreading codes using cyclic shifts
% of the same maximal-length sequence.
codes = zeros(K,SF);

for k = 1:K
    shiftAmount = floor((k-1)*SF/K);
    codes(k,:) = circshift(pn, [0 shiftAmount]);
end

% Generate independent BPSK data for each user
dataCDMA = 2*randi([0 1],K,numBits)-1;

% Spread each user's data and combine all transmitted signals
txCDMA = zeros(1,numBits*SF);

for k = 1:K
    spreadSignal = kron(dataCDMA(k,:), ...
                        codes(k,:)/sqrt(SF));

    txCDMA = txCDMA + spreadSignal;
end

% Store BER for every user and SNR
berCDMA = zeros(numSNR,K);

for s = 1:numSNR

    gamma = 10^(EbN0dB(s)/10);

    % Real AWGN variance per chip.
    % Each isolated transmitted information bit has unit energy.
    noiseVariance = 1/(2*gamma);

    noise = sqrt(noiseVariance)*randn(size(txCDMA));
    rxCDMA = txCDMA + noise;

    % Reshape received chips into SF chips per information bit
    rxMatrix = reshape(rxCDMA,SF,numBits);

    % Despread each user's signal
    for k = 1:K

        decisionMetric = ...
            (codes(k,:)/sqrt(SF))*rxMatrix;

        detectedBits = 2*(decisionMetric >= 0)-1;

        berCDMA(s,k) = ...
            mean(detectedBits ~= dataCDMA(k,:));

    end

end

% Display BER results
disp('CDMA BER results:');
disp('Eb/N0 (dB)       User 1       User 2       User 3');

for s = 1:numSNR
    fprintf('%8.1f      %.5e    %.5e    %.5e\n', ...
        EbN0dB(s), berCDMA(s,1), ...
        berCDMA(s,2), berCDMA(s,3));
end

% Plot BER versus Eb/N0
figure('Name','CDMA BER Performance','Color','w');

semilogy(EbN0dB, max(berCDMA(:,1),1/(2*numBits)), ...
         '-o','LineWidth',1.5);
hold on;

semilogy(EbN0dB, max(berCDMA(:,2),1/(2*numBits)), ...
         '-s','LineWidth',1.5);

semilogy(EbN0dB, max(berCDMA(:,3),1/(2*numBits)), ...
         '-^','LineWidth',1.5);

grid on;
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
title('CDMA System Performance in AWGN');
legend('User 1','User 2','User 3','Location','southwest');

%% ============================================================
% PART 3: PERFORMANCE ANALYSIS OF RAKE RECEIVER
% =============================================================

disp('PART 3: RAKE Receiver Performance Analysis');

numRakeBits = 5000;

% Multipath channel parameters
pathDelays = [0 3 7];       % Path delays in chips
pathGains = [0.8 0.5 0.3]; % Real-valued path amplitudes

% Normalize channel energy
pathGains = pathGains/norm(pathGains);

numPaths = length(pathDelays);
maxDelay = max(pathDelays);

% Generate BPSK information data
dataRake = 2*randi([0 1],1,numRakeBits)-1;

% Spread information data using the PN sequence
txRake = kron(dataRake,pn/sqrt(SF));

% Pass the signal through a discrete-time multipath channel
rxChannel = zeros(1,length(txRake)+maxDelay);

for p = 1:numPaths

    indices = pathDelays(p)+(1:length(txRake));

    rxChannel(indices) = rxChannel(indices) ...
                       + pathGains(p)*txRake;

end

% BER arrays for single-finger and RAKE reception
berSingleFinger = zeros(1,numSNR);
berRake = zeros(1,numSNR);

% Preallocate correlator outputs
fingerMetric = zeros(numPaths,numRakeBits);

for s = 1:numSNR

    gamma = 10^(EbN0dB(s)/10);
    noiseVariance = 1/(2*gamma);

    % Add receiver thermal noise
    rxSignal = rxChannel ...
             + sqrt(noiseVariance)*randn(size(rxChannel));

    % --------------------------------------------------------
    % RAKE FINGERS
    % Each finger aligns to one resolvable multipath delay.
    % Correlation with the PN code estimates the path output.
    % --------------------------------------------------------

    for p = 1:numPaths

        for b = 1:numRakeBits

            startIndex = (b-1)*SF + 1 + pathDelays(p);
            indices = startIndex:startIndex+SF-1;

            fingerMetric(p,b) = ...
                sum(rxSignal(indices).*(pn/sqrt(SF)));

        end

    end

    % --------------------------------------------------------
    % SINGLE-FINGER RECEIVER
    % Uses only the earliest path.
    % --------------------------------------------------------

    singleMetric = conj(pathGains(1))*fingerMetric(1,:);

    detectedSingle = 2*(real(singleMetric) >= 0)-1;

    berSingleFinger(s) = ...
        mean(detectedSingle ~= dataRake);

    % --------------------------------------------------------
    % RAKE RECEIVER WITH MAXIMAL-RATIO COMBINING (MRC)
    %
    % Weight each finger by the conjugate of its channel gain
    % and add the aligned outputs.
    % --------------------------------------------------------

    rakeMetric = zeros(1,numRakeBits);

    for p = 1:numPaths

        rakeMetric = rakeMetric ...
                   + conj(pathGains(p))*fingerMetric(p,:);

    end

    detectedRake = 2*(real(rakeMetric) >= 0)-1;

    berRake(s) = mean(detectedRake ~= dataRake);

end

% Display RAKE results
disp('RAKE receiver BER results:');
disp('Eb/N0 (dB)       Single Finger       RAKE-MRC');

for s = 1:numSNR
    fprintf('%8.1f          %.5e       %.5e\n', ...
        EbN0dB(s), berSingleFinger(s), berRake(s));
end

% Plot performance comparison
figure('Name','RAKE Receiver Performance','Color','w');

semilogy(EbN0dB, max(berSingleFinger,1/(2*numRakeBits)), ...
         '-o','LineWidth',1.5);
hold on;

semilogy(EbN0dB, max(berRake,1/(2*numRakeBits)), ...
         '-s','LineWidth',1.5);

grid on;
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
title('RAKE Receiver Performance in a Multipath Channel');
legend('Single-Finger Receiver','RAKE with MRC', ...
       'Location','southwest');

disp('All three experiments completed successfully.');

%% ============================================================
% LOCAL FUNCTION: LFSR-BASED PN SEQUENCE GENERATOR
% =============================================================

function sequence = generatePN(m, taps, initialState, numChips)

    % Validate LFSR parameters
    if length(initialState) ~= m
        error('Initial state must contain exactly m bits.');
    end

    if any(initialState ~= 0 & initialState ~= 1)
        error('Initial state must contain binary values.');
    end

    if all(initialState == 0)
        error('The all-zero LFSR state is not permitted.');
    end

    if any(taps < 1 | taps > m | taps ~= floor(taps))
        error('Tap indices must be integers between 1 and m.');
    end

    % Initialize the shift register
    registerState = initialState;
    sequence = zeros(1,numChips);

    for n = 1:numChips

        % Output bit from the last register stage
        sequence(n) = registerState(end);

        % XOR the selected feedback stages
        feedbackBit = mod(sum(registerState(taps)),2);

        % Shift the register and insert feedback
        registerState = [feedbackBit registerState(1:end-1)];

    end

end
