% function [H] = wienerfilt1(X,Y,N,Fs)
%  
%  	FILE NAME 	: WIENER FILT 1
%  	DESCRIPTION	: Wiener filter estimate using xcorrelation
%  
%  	X           : Input Signal
%  	Y           : Output Signal (recorded neural trace)
%  	N           : Filter order
%  
%   (C) Monty A. Escabi, May 2018
%
function [H] = wienerfilt1(X,Y,N,Fs)

%Derive artifact filter using crosscorrelation
H=xcorr(Y-mean(Y),X-mean(X),N)/var(X)/Fs;
H=H-mean(H(1:N));   %Remove DC offset if present - occasionally this could be an issue due to finite data or nonstationarity
H=H(N+1:end);
