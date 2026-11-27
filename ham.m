clc;
clear;
close all;

n = 7;
k = 4;
num_blocks = 100000;
EbN0_dB = 0:1:10;

P = [1 1 0; 
     0 1 1; 
     1 1 1; 
     1 0 1];
G = [eye(k), P];
H = [P', eye(n - k)];

syndrome_table = zeros(2^(n - k), n);
for i = 1:n
    err_vec = zeros(1, n);
    err_vec(i) = 1;
    syn = mod(err_vec * H', 2);
    idx = bi2de(syn, 'left-msb') + 1;
    syndrome_table(idx, :) = err_vec;
end

data_bits = randi([0 1], num_blocks, k);
coded_bits = mod(data_bits * G, 2);

ber_coded = zeros(size(EbN0_dB));
ber_uncoded = zeros(size(EbN0_dB));

R = k / n;

for idx = 1:length(EbN0_dB)
    EbN0 = 10^(EbN0_dB(idx) / 10);
    
    tx_coded = 2 * coded_bits - 1;
    sigma_coded = sqrt(1 / (2 * R * EbN0));
    rx_coded = tx_coded + sigma_coded * randn(size(tx_coded));
    rx_hard = rx_coded > 0;
    
    syndromes = mod(rx_hard * H', 2);
    syn_indices = bi2de(syndromes, 'left-msb') + 1;
    error_patterns = syndrome_table(syn_indices, :);
    corrected_codewords = mod(rx_hard + error_patterns, 2);
    
    decoded_bits = corrected_codewords(:, 1:k);
    ber_coded(idx) = sum(sum(decoded_bits ~= data_bits)) / (num_blocks * k);
    
    tx_uncoded = 2 * data_bits - 1;
    sigma_uncoded = sqrt(1 / (2 * EbN0));
    rx_uncoded = tx_uncoded + sigma_uncoded * randn(size(tx_uncoded));
    rx_uncoded_hard = rx_uncoded > 0;
    
    ber_uncoded(idx) = sum(sum(rx_uncoded_hard ~= data_bits)) / (num_blocks * k);
end

figure;
semilogy(EbN0_dB, ber_uncoded, 'b-o', 'LineWidth', 1.5);
hold on;
semilogy(EbN0_dB, ber_coded, 'r-s', 'LineWidth', 1.5);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
title('BER Performance of (7,4) Hamming Code over AWGN Channel');
legend('Uncoded BPSK', '(7,4) Hamming Coded BPSK');
ylim([1e-5 1]);