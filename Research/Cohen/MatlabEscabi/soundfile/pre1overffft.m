%
%function [Y]=pre1overffft(X,Fs,f1,f2,alpha)
%	
%	FILE NAME   : PRE 1OVERF FFT
%	DESCRIPTION : Changes the spectrum of a signal so that it follows the
%                 generalized 1/f power-law of general form:
%
%                 Pxx(f) = C * 1/f^(-alpha)
%
%                 where C is a constant and alpha is the power law exponent
%                 over a specified frequency range [f1 f2]. Outside this
%                 range the spectrum is zero power
%
%                 The signal is originally whitened by normalizing the 
%                 signal FFT by the magnitude of the signal FFT 
%                 (abs(fft(X)). This first normalization is identical to 
%                 PREWHITENFFT. Following the whiteneing, the 1/f^alpha 
%                 spectrum is imposed in the frequency domain.
%
%                 The approach works but reduces the overal FFT variance of
%                 the original signal.
%
%       X		: Input Signal
%       Fs		: Sampling rate
%       f1		: Lower Cutoff Frequency for Pre-Whitening (>0)
%       f2		: Upper Cutoff Frequency for Pre-Whitening (<Fs/2)
%       alpha   : Power law exponent
%
%RETURNED VARIABLES
%       Y		: Pre Whitened Signal
%
%  (C) Monty A. Escabi & Xiu Zhai,  April 2019
%
function [Y]=pre1overffft(X,Fs,f1,f2,alpha)

%Computing Fourier Transform of 
NFFT=2^nextpow2(length(X));
if size(X,1)>size(X,2)
	X=X';
end
Z=fft(X,NFFT);              %Compute zero padded FFT

%Generate 1/f^alpha Power Law trend
faxis=(0:NFFT-1)/NFFT*Fs;
H=zeros(1,NFFT);
H(2:NFFT/2+1)=faxis(2:NFFT/2+1).^(-alpha/2);                 %Filter that creates 1/f^alpha power spectrym trend 
H(NFFT:-1:NFFT/2+2)=H(2:NFFT/2);

%Whiten and 1/f the signal FFT and invert
Y=ifft(Z./abs(Z).*H);

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
Y=Y(1:length(X));
Y=Y/std(Y)*std(X);                  %Normalize STD to orignal value