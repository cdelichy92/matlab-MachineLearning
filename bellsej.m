%Cyprien de Lichy

clc;
clear all;
close all;
%------------------------------------------------------------
% ICA

load mix.dat	% load mixed sources
Fs = 11025; %sampling frequency being used

% listen to the mixed sources
normalizedMix = 0.99 * mix ./ (ones(size(mix,1),1)*max(abs(mix)));

% handle writing in both matlab and octave
v = version;
if (v(1) <= '3') % assume this is octave
  wavwrite('mix1.wav', normalizedMix(:, 1), Fs, 16);
  wavwrite('mix2.wav', normalizedMix(:, 2), Fs, 16);
  wavwrite('mix3.wav', normalizedMix(:, 3), Fs, 16);
  wavwrite('mix4.wav', normalizedMix(:, 4), Fs, 16);
  wavwrite('mix5.wav', normalizedMix(:, 5), Fs, 16);
else
  wavwrite(normalizedMix(:, 1), Fs, 16, 'mix1.wav');
  wavwrite(normalizedMix(:, 2), Fs, 16, 'mix2.wav');
  wavwrite(normalizedMix(:, 3), Fs, 16, 'mix3.wav');
  wavwrite(normalizedMix(:, 4), Fs, 16, 'mix4.wav');
  wavwrite(normalizedMix(:, 5), Fs, 16, 'mix5.wav');
end

W=eye(5);	% initialize unmixing matrix

% this is the annealing schedule I used for the learning rate.
% (We used stochastic gradient descent, where each value in the 
% array was used as the learning rate for one pass through the data.)
% Note: If this doesn't work for you, feel free to fiddle with learning
%  rates, etc. to make it work.
anneal = [0.1 0.1 0.1 0.05 0.05 0.05 0.02 0.02 0.01 0.01 ...
      0.005 0.005 0.002 0.002 0.001 0.001];

m=size(normalizedMix, 1);
shuffled_data = normalizedMix(randperm(m),:); 

for iter=1:length(anneal)
    
   alpha = anneal(iter);
   
   for i=1:m
       x_i = shuffled_data(i, :)';
       W = W + alpha*( ( 1 - 2*1./(1+exp(-W*x_i)) )*x_i' + inv(W') );
   end

end;


S = (W * normalizedMix')';

S=0.99 * S./(ones(size(mix,1),1)*max(abs(S))); 	% rescale each column to have maximum absolute value 1 

v = version;
if (v(1) <= '3') % assume this is octave
  wavwrite('unmix1.wav', S(:, 1), Fs, 16);
  wavwrite('unmix2.wav', S(:, 2), Fs, 16);
  wavwrite('unmix3.wav', S(:, 3), Fs, 16);
  wavwrite('unmix4.wav', S(:, 4), Fs, 16);
  wavwrite('unmix5.wav', S(:, 5), Fs, 16);
else
  wavwrite(S(:, 1), Fs, 16, 'unmix1.wav');
  wavwrite(S(:, 2), Fs, 16, 'unmix2.wav');
  wavwrite(S(:, 3), Fs, 16, 'unmix3.wav');
  wavwrite(S(:, 4), Fs, 16, 'unmix4.wav');
  wavwrite(S(:, 5), Fs, 16, 'unmix5.wav');
end
