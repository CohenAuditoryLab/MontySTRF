%
%function [Y]=prewhitenfft(X,Fs,f1,f2)
%	
%	FILE NAME   : PRE WHITEN FFT
%	DESCRIPTION : Pre-Whitens a singal in the frequency bands f1-f2.
%                 Whitens by normalizing the signal FFT by the magnitude of
%                 the signal FFT (abs(fft(X)). The approach works but
%                 reduces the overal FFT variance of the original signal.
%
%       X		: Input Signal
%       Fs		: Sampling rate
%       f1		: Lower Cutoff Frequency for Pre-Whitening (>0)
%       f2		: Upper Cutoff Frequency for Pre-Whitening (<Fs/2)
%
%RETURNED VARIABLES
%       Y		: Pre Whitened Signal
%
%  (C) Monty A. Escabi & Xiu Zhai,  April 2019
%
function [Y]=prewhitenfft(X,Fs,f1,f2)

%Computing Fourier Transform of X and whitening power spectrum
if size(X,1)>size(X,2)
	X=X';
end
Z=fft(X);                           %Compute FFT
Y=ifft(Z./abs(Z));

%Filtering between f1 and f2
ATT=40;
TW=min(f1,(Fs-f1));
if ~(f1==0 & f2==Fs/2)
    H=bandpass(f1,f2,TW,Fs,ATT);
    Y=conv(Y,H);
    N=(length(H)-1)/2;
    Y=Y(N+1:end-N);                 %Remove filter delay
end

%Truncating and Normalizing 
Y=Y/std(Y)*std(X);                  %Normalize STD to orignal value