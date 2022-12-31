%Part(2)
clc
clear
close all
z = randi([0 1],10,1);
z = polar_nrz(z);
Ts=input('Input The time of the signals as an integer: ');
[phi,coef,energy]=get_bases(z,Ts); %getting constellation diagram of polar NRZ
X = randi([0 1],100000,1); %Generating random 100000 stream of bits
encoded=polar_nrz(X); %Encoding the random stream of bits using polar NRZ
Eb_No_dB=[-10 -8 -6 -4 -2 0 2 4 6];
numBit = 100000;
for i=1:length(Eb_No_dB)
Input = awgn(encoded,Eb_No_dB(i)+3,'measured');
scatterplot(Input);
axis([-10 10 -10 10]);
Eb_No = 10^(Eb_No_dB(i)/10);
thber(i) = 0.5*erfc(sqrt(Eb_No)); % Theoretical BER
output=Decode_polar_nrz(Input);
output1=transpose(output);
numBitErrs = biterr(output1,X);
BER(i) = numBitErrs/numBit;         %simulation BER
end
figure
semilogy(Eb_No_dB,BER,'*r');
hold on;
xlabel('Eb/No (dB)');
ylabel('BER');
title('Eb/No Vs BER plot for BPSK Modualtion in AWGN Channel');
semilogy(Eb_No_dB,thber);
grid on;
legend('Simulated Curve', 'Theoretical Curve');


function [output]=Decode_polar_nrz(Input)
output = zeros(1,length(Input));
for j=1:length(Input)
if Input(j)> 0
    output(j)=0;                       %%Decode
else
    output(j)=1;
end
end
end

function [y]=polar_nrz(X)

% Polar  not return to zero line coding
% X : binary input vector
% Returns: Polar NRZ line coding plot

y = zeros(1,length(X));
for m= 1:length(X)
   if X(m) == 0
       y(m) = 1;
   else
       y(m) = -1;
   end
end
end