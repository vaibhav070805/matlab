clc;
clear;
close all;
%% 
N = 100000;              % Number of symbols/bits
SNRdB = 0:2:20;          % SNR range in dB
%% 
%   BPSK MODULATION
% Generate random binary data
bits_BPSK = randi([0 1],N,1);
% BPSK modulation (Phase offset pi is used here)
tx_BPSK = pskmod(bits_BPSK,2,pi);
%% 
%  BPSK CONSTELLATION
figure;
scatter(real(tx_BPSK),imag(tx_BPSK),10,'filled');
grid on;
axis equal;
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
title('BPSK Constellation');
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
%% 
%   BPSK DEMODULATION
rx_BPSK_ideal = pskdemod(tx_BPSK,2,pi);
% Calculate errors
BER_BPSK_ideal = mean(bits_BPSK ~= rx_BPSK_ideal);
%% 
%  QPSK MODULATION
% QPSK symbols: 0,1,2,3
data_QPSK = randi([0 3],N,1);
% QPSK modulation
tx_QPSK = pskmod(data_QPSK,4,pi/4);
%% 
%  QPSK CONSTELLATION
figure;
scatter(real(tx_QPSK),imag(tx_QPSK),10,'filled');
grid on;
axis equal;
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
title('QPSK Constellation');
%% 
%  QPSK DEMODULATION
rx_QPSK_ideal = pskdemod(tx_QPSK,4,pi/4);
SER_QPSK_ideal = mean(data_QPSK ~= rx_QPSK_ideal);
%% 
% 16-QAM MODULATION
% Generate random 16-QAM symbols
data_QAM = randi([0 15],N,1);
% 16-QAM modulation
tx_QAM = qammod(data_QAM,16);
%% 
%  16-QAM CONSTELLATION
figure;
scatter(real(tx_QAM),imag(tx_QAM),10,'filled');
grid on;
axis equal;
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
title('16-QAM Constellation');
%% 
%  16-QAM DEMODULATION
rx_QAM_ideal = qamdemod(tx_QAM,16);
SER_QAM_ideal = mean(data_QAM ~= rx_QAM_ideal);
%% 
% COMPARISON OF BPSK, QPSK AND 16-QAM CONSTELLATIONS
figure;
subplot(1,3,1);
scatter(real(tx_BPSK),imag(tx_BPSK),10,'filled');
grid on;
axis equal;
xlabel('I');
ylabel('Q');
title('BPSK');
subplot(1,3,2);
scatter(real(tx_QPSK),imag(tx_QPSK),10,'filled');
grid on;
axis equal;
xlabel('I');
ylabel('Q');
title('QPSK');
subplot(1,3,3);
scatter(real(tx_QAM),imag(tx_QAM),10,'filled');
grid on;
axis equal;
xlabel('I');
ylabel('Q');
title('16-QAM');
sgtitle('Comparison of Digital Modulation Constellations');
%% PART B : COHERENT DETECTION
%  B1. COHERENT BPSK DETECTION
SNR_coherent = 10;
% Add AWGN
rx_BPSK = awgn(tx_BPSK,SNR_coherent,'measured');
% Coherent BPSK demodulation
detected_BPSK = pskdemod(rx_BPSK,2,pi);
% Calculate BER
BER_coherent_BPSK = mean(bits_BPSK ~= detected_BPSK);
%% 
%   NOISY BPSK CONSTELLATION
figure;
subplot(1,2,1);
scatter(real(tx_BPSK(1:5000)), ...
        imag(tx_BPSK(1:5000)),10,'filled');
grid on;
axis equal;
xlabel('I');
ylabel('Q');
title('BPSK Without Noise');
subplot(1,2,2);
scatter(real(rx_BPSK(1:5000)), ...
        imag(rx_BPSK(1:5000)),10,'filled');
grid on;
axis equal;
xlabel('I');
ylabel('Q');
title('BPSK With AWGN');
sgtitle('Effect of AWGN on BPSK Constellation');
%%  
% NON-COHERENT DETECTION USING DPSK
% Generate binary data
data_DPSK = randi([0 1],N,1);
% Differential PSK modulation
tx_DPSK = dpskmod(data_DPSK,2);
% Add AWGN
rx_DPSK = awgn(tx_DPSK,SNR_coherent,'measured');
% Differential demodulation
detected_DPSK = dpskdemod(rx_DPSK,2);
% BER
BER_DPSK = mean(data_DPSK ~= detected_DPSK);
%% 
%  DPSK CONSTELLATION
figure;
scatter(real(tx_DPSK(1:5000)), ...
        imag(tx_DPSK(1:5000)),10,'filled');
grid on;
axis equal;
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
title('DPSK Constellation');
%% 
% BER PERFORMANCE IN AWGN
%% 
% BPSK BER VS SNR
BER_BPSK = zeros(size(SNRdB));
for k = 1:length(SNRdB)
    % Add AWGN
    rx = awgn(tx_BPSK,SNRdB(k),'measured');
    % Coherent demodulation
    detected = pskdemod(rx,2,pi);
    % BER
    BER_BPSK(k) = mean(bits_BPSK ~= detected);
end
%% 
%  THEORETICAL BPSK BER
EbN0 = 10.^(SNRdB/10);
BER_BPSK_theory = 0.5*erfc(sqrt(EbN0));
%% 
%  BPSK BER PLOT
figure;
semilogy(SNRdB,BER_BPSK,'o-','LineWidth',1.5);
hold on;
semilogy(SNRdB,BER_BPSK_theory,'--','LineWidth',1.5);
grid on;
xlabel('SNR / E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
title('BPSK BER Performance in AWGN');
legend('Simulation','Theory','Location','southwest');
%% 
% QPSK BER/SER VS SNR
SER_QPSK = zeros(size(SNRdB));
for k = 1:length(SNRdB)
    % Add AWGN
    rx = awgn(tx_QPSK,SNRdB(k),'measured');
    % Demodulation
    detected = pskdemod(rx,4,pi/4);
    % Symbol error rate
    SER_QPSK(k) = mean(data_QPSK ~= detected);
end
%%
%  QPSK SER PLOT
figure;
semilogy(SNRdB,SER_QPSK,'o-','LineWidth',1.5);
grid on;
xlabel('SNR (dB)');
ylabel('Symbol Error Rate (SER)');
title('QPSK SER Performance in AWGN');
%% 
% 16-QAM SER VS SNR
SER_QAM = zeros(size(SNRdB));
for k = 1:length(SNRdB)
    % Add AWGN
    rx = awgn(tx_QAM,SNRdB(k),'measured');
    % Demodulation
    detected = qamdemod(rx,16);
    % Symbol error rate
    SER_QAM(k) = mean(data_QAM ~= detected);
end
%% 
%  16-QAM SER PLOT
figure;
semilogy(SNRdB,SER_QAM,'o-','LineWidth',1.5);
grid on;
xlabel('SNR (dB)');
ylabel('Symbol Error Rate (SER)');
title('16-QAM SER Performance in AWGN');
%% 
% COMPARISON OF BPSK, QPSK AND 16-QAM
figure;
semilogy(SNRdB,BER_BPSK,'o-','LineWidth',1.5);
hold on;
semilogy(SNRdB,SER_QPSK,'s-','LineWidth',1.5);
semilogy(SNRdB,SER_QAM,'^-','LineWidth',1.5);
grid on;
xlabel('SNR (dB)');
ylabel('Error Rate');
title('Performance Comparison');
legend('BPSK BER','QPSK SER','16-QAM SER', ...
       'Location','southwest');
%% 
% CONSTELLATION AT DIFFERENT SNR VALUES
SNR1 = 0;
SNR2 = 10;
SNR3 = 20;
% Generate noisy QPSK signals
rx_QPSK_0dB  = awgn(tx_QPSK,SNR1,'measured');
rx_QPSK_10dB = awgn(tx_QPSK,SNR2,'measured');
rx_QPSK_20dB = awgn(tx_QPSK,SNR3,'measured');
%  PLOT QPSK AT DIFFERENT SNR
figure;
subplot(1,3,1);
scatter(real(rx_QPSK_0dB(1:3000)), ...
        imag(rx_QPSK_0dB(1:3000)),10,'filled');
grid on;
axis equal;
xlabel('I');
ylabel('Q');
title('QPSK: SNR = 0 dB');
subplot(1,3,2);
scatter(real(rx_QPSK_10dB(1:3000)), ...
        imag(rx_QPSK_10dB(1:3000)),10,'filled');
grid on;
axis equal;
xlabel('I');
ylabel('Q');
title('QPSK: SNR = 10 dB');
subplot(1,3,3);
scatter(real(rx_QPSK_20dB(1:3000)), ...
        imag(rx_QPSK_20dB(1:3000)),10,'filled');
grid on;
axis equal;
xlabel('I');
ylabel('Q');
title('QPSK: SNR = 20 dB');
sgtitle('Effect of SNR on QPSK Constellation');