%
%function [Y]=pre1overf(X,Fs,f1,f2,alpha,df)
%	
%   FILE NAME   : PRE 1 OVER F
%   DESCRIPTION : Changes the spectrum of a signal so that it follows the
%                 generalized 1/f power-law of general form:
%
%                 Pxx(f) = C * 1/f^(-alpha)
%
%                 where C is a constant and alpha is the power law exponent
%                 over a specified frequency range [f1 f2]. Outside this
%                 range the spectrum is zero power
%
%                 Uses a procedure similar to PREWHITEN followed by
%                 applying the 1/f trend. Whitening is first performed by
%                 normalizing the signal FFT by the signal Periodogram at a
%                 resolution of df. The signal is then interpolated using a
%                 spline function to match the FFT resolution.
%
%       X       : Input Signal
%       Fs      : Sampling rate
%       f1      : Lower Cutoff Frequency for Pre-Whitening
%       f2      : Upper Cutoff Frequency for Pre-Whitening
%       alpha   : Power law exponent
%       df      : Spectral Resolution for Periodogram (PSD)
%
%RETURNED VARIABLES
%       Y       : Pre 1 Over F signal
%
%  (C) Monty A. Escabi, Feb. 2017 (edit April 2019, MAE/XZ)
%
function [Y]=pre1overf(X,Fs,f1,f2,alpha,df)

%Finding Sinc(a,p) window as designed by Roark / Escabi
ATT=40;
W=designw(df,ATT,Fs);
M=2^nextpow2(length(W));

%Computing PSD
[Pxx,Faxis]=pwelch(X,W,[],M,Fs);
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

%Whitening the Spectrum and incorporating power law trend
H=zeros(1,length(Z));
H(N1:N2)=faxis(N1:N2).^(-alpha/2);                 %Filter that creates 1/f^alpha power spectrym trend 
H(length(Z):-1:length(Z)/2+2)=H(2:length(Z)/2);
H(1)=0;                                             %Otherwise you get Inf when f1=0; Note that 0^(-alpha/2)==Inf
Y=real(ifft(Z./PP.*H));
Y=Y(1:length(X));

%Normalizing Y and PP so that Var(Y)=Var(X)
%Y and X therefore have the same power
NormFact=1/std(Y)*std(X);
Y=Y*NormFact;
PP=PP/NormFact;		%So that X is recoverable by X=real(ifft(fft(Y).*PP))

%Converting inf to 0
index=find(PP==inf);
PP(index)=zeros(size(index));
