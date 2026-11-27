%% EXPERIMENT 4
% Matched Filter Based Signal Detection
% and Eye Diagram Investigation

clear;
clc;
close all;

%  GENERATE RANDOM BITS

% Number of bits to transmit
N = 1000;

% Generate random bits: either 0 or 1
bits = randi([0 1], 1, N);

% Display first 20 bits
disp('First 20 transmitted bits:');
disp(bits(1:20));


%% 
%  BPSK MODULATION

bpsk_symbols = 2*bits - 1;

% Display first 20 BPSK symbols
disp('First 20 BPSK symbols:');
disp(bpsk_symbols(1:20));


%% 
% CONVERT EACH SYMBOL INTO A PULSE


% Number of samples used to represent one bit
samples_per_bit = 20;

transmitted_signal = repelem(bpsk_symbols, samples_per_bit);


%% 
% PLOT THE TRANSMITTED BPSK SIGNAL


figure;

% Plot only first 10 bits so that waveform is clearly visible
plot(transmitted_signal(1:10*samples_per_bit), 'LineWidth', 1.5);

grid on;

xlabel('Sample Number');
ylabel('Amplitude');

title('Transmitted BPSK Signal');

ylim([-1.5 1.5]);


%% 
% ADD AWGN NOISE


% Choose SNR
SNR_dB = 5;

% Calculate signal power
signal_power = mean(transmitted_signal.^2);

% Convert SNR from dB to normal value
SNR = 10^(SNR_dB/10);

% Calculate required noise power
noise_power = signal_power/SNR;

% Generate Gaussian noise
noise = sqrt(noise_power)*randn(size(transmitted_signal));

% Received signal = transmitted signal + noise
received_signal = transmitted_signal + noise;


%%
%  PLOT THE NOISY RECEIVED SIGNAL

figure;

plot(received_signal(1:10*samples_per_bit), 'LineWidth', 1);

grid on;

xlabel('Sample Number');
ylabel('Amplitude');

title(['Received BPSK Signal with Noise, SNR = ', ...
       num2str(SNR_dB), ' dB']);


%% 
% CREATE THE MATCHED FILTER

transmitted_pulse = ones(1, samples_per_bit);

matched_filter = fliplr(transmitted_pulse);


%% 
%  DISPLAY THE MATCHED FILTER


figure;

stem(matched_filter, 'filled');

grid on;

xlabel('Sample Number');
ylabel('Amplitude');

title('Impulse Response of Matched Filter');


%%
%  PASS RECEIVED SIGNAL THROUGH MATCHED FILTER


% Convolution performs the filtering operation.

matched_filter_output = conv(received_signal, matched_filter);


%%
%  PLOT MATCHED FILTER OUTPUT


figure;

plot(matched_filter_output(1:12*samples_per_bit), ...
     'LineWidth', 1.5);

grid on;

xlabel('Sample Number');
ylabel('Amplitude');

title('Output of Matched Filter');


%% 
%  TAKE SAMPLES AT THE DECISION POINT



first_sample = samples_per_bit;

% Sampling locations
sample_positions = first_sample : samples_per_bit : ...
                   first_sample + (N-1)*samples_per_bit;

% Take the samples
decision_samples = matched_filter_output(sample_positions);


%%
% NORMALIZE THE SAMPLES


decision_samples = decision_samples / samples_per_bit;


%% 
% MAKE THE DECISION


detected_bits = decision_samples >= 0;



%% 
% CALCULATE NUMBER OF ERRORS


% Compare transmitted bits and detected bits

number_of_errors = sum(bits ~= detected_bits);


%% 
% CALCULATE BER


% BER = Number of errors / Total number of bits

BER = number_of_errors / N;


%% 
%  EYE DIAGRAM OF TRANSMITTED SIGNAL


figure;

hold on;

% Number of eye traces
number_of_traces = 50;

% Each trace contains two bits
eye_length = 2*samples_per_bit;

for k = 1:number_of_traces

    % Starting position of the trace
    start_position = (k-1)*samples_per_bit + 1;

    % Ending position
    end_position = start_position + eye_length - 1;

    % Make sure we do not go outside the signal
    if end_position <= length(transmitted_signal)

        % Take two-bit portion
        eye_signal = transmitted_signal(start_position:end_position);

        % Plot it
        plot(eye_signal);

    end

end

grid on;

xlabel('Time');
ylabel('Amplitude');

title('Eye Diagram of Transmitted BPSK Signal');

hold off;


%% 
% EYE DIAGRAM OF NOISY RECEIVED SIGNAL


figure;

hold on;

for k = 1:number_of_traces

    start_position = (k-1)*samples_per_bit + 1;

    end_position = start_position + eye_length - 1;

    if end_position <= length(received_signal)

        % Take two-bit portion
        eye_signal = received_signal(start_position:end_position);

        % Plot it
        plot(eye_signal);

    end

end

grid on;

xlabel('Time');
ylabel('Amplitude');

title(['Eye Diagram of Received Signal, SNR = ', ...
       num2str(SNR_dB), ' dB']);

hold off;


%% 
% BER FOR DIFFERENT SNR VALUES

% SNR values that we want to test

SNR_values = 0:2:20;

% Create an empty array to store BER
BER_values = zeros(size(SNR_values));


% Repeat the experiment for different SNR values

for i = 1:length(SNR_values)

    % Current SNR
    current_SNR_dB = SNR_values(i);

    % Convert dB to normal SNR
    current_SNR = 10^(current_SNR_dB/10);

    % Calculate noise power
    current_noise_power = signal_power/current_SNR;

    % Generate noise
    current_noise = sqrt(current_noise_power) ...
                    * randn(size(transmitted_signal));

    % Add noise
    current_received_signal = ...
        transmitted_signal + current_noise;

    % Matched filter
    current_output = ...
        conv(current_received_signal, matched_filter);

    % Take samples
    current_samples = current_output(sample_positions);

    % Normalize
    current_samples = current_samples/samples_per_bit;

    % Make decisions
    current_detected_bits = current_samples >= 0;

    % Count errors
    current_errors = ...
        sum(bits ~= current_detected_bits);

    % Calculate BER
    BER_values(i) = current_errors/N;
    
end


%% 
% PLOT BER VS SNR

figure;

semilogy(SNR_values, BER_values, 'o-', ...
         'LineWidth', 1.5);

grid on;

xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

title('BER Performance of Matched Filter');