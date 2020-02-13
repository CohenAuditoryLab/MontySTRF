%
%function [Y]=prewhiten(X,Fs,f1,f2,df)
%	
%   FILE NAME   : PRE WHITEN
%   DESCRIPTION : Pre-Whitens a singal in the frequency bands f1-f2.
%                 Normalizes the signal FFT by the signal periodogram at
%                 resolution 'df'. The signal is then interpolated using a
%                 spline function to match the FFT resolution.
%
%       X       : Input Signal
%       Fs      : Sampling rate
%       f1      : Lower Cutoff Frequency for Pre-Whitening
%       f2      : Upper Cutoff Frequency for Pre-Whitening
%       df      : Spectral Resolution for Periodogram (PSD)
%
%RETURNED VARIABLES
%       Y       : Pre Whitened Signal
%
%  (C) Monty A. Escabi, 2002 (Last Edit April 2019 MAE/XZ)
%
function [Y]=prewhiten(X,Fs,f1,f2,df)

%Finding Sinc(a,p) window as designed by Roark / Escabi
ATT=40;
W=designw(df,ATT,Fs);
M=2^nextpow2(length(W));

%Computing PSD
[Pxx,Faxis]=pwelch(X,W,[],M,Fs);    %Changed from PSD to PWELCH, Feb 2017
Pxx=10*log10(Pxx);
M1=round((length(Pxx)-1)*2*f1/Fs+1);
M2=round((length(Pxx)-1)*2*f2/Fs+1);

%Computing Fourier Transform of X
if size(X,1)>size(X,2)
	X=X';
end
Z=fft(X,2^nextpow2(length(X)));
N1=round((length(Z)-1)*f1/Fs+1);
N2=round((length(Z)-1)*f2/Fs);
faxis=(0:length(Z)-1)/length(Z)*Fs;

%Fitting Spline to Pxx
P = interp1(Faxis,Pxx,faxis,'spline');      %Change the interpolation from polynomial fitting to spline - April 2019
P=10.^(P/20);
PP=inf*ones(1,length(Z));
PP(N1:N2)=P(N1:N2);
PP(length(Z):-1:length(Z)/2+2)=PP(2:length(Z)/2);

%Whitening the Spectrum
Y=real(ifft(Z./PP));
Y=Y(1:length(X));

%Normalizing Y and PP so that Var(Y)=Var(X)
%Y and X therefore have the same power
NormFact=1/std(Y)*std(X);
Y=Y*NormFact;
PP=PP/NormFact;		%So that X is recoverable by X=real(ifft(fft(Y).*PP))

%Converting inf to 0
index=find(PP==inf);
PP(index)=zeros(size(index));
