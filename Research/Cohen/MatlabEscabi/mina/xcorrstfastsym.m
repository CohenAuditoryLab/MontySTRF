%
%function [Rxy,RxyN,RxyN2,tauaxis,taxis]=xcorrstfastsym(X,Y,MaxLag,Fs,W,OF)
%
%       FILE NAME       : XCORR ST FAST SYM
%       DESCRIPTION     : Short term xcorrelation funciton. Uses a fast
%                         convolution algorithm to compute short-term correlation.
%                         This version is similar to XCORRSTFAST but guarantees 
%                         correaltion symmetry so that
%
%                           Rxy(t,tau)=Ryx(t,-tau)
%
%       X,Y             : Signals to be correlated
%       MaxLag          : Maximum number of delay samples 
%       Fs              : Sampling Rate
%       W               : Window used for short-term analysis (1x2*N+1
%                         vector)
%       OF              : Oversampling factor - intiger value that
%                         determines how much to oversample the time axis
%                         for the specified window used (Default==inf). If
%                         using default the time axis is computed at a
%                         smapling rate of Fs.
%
%RETURNED VALUES
%       Rxy             : Short Term Correlation
%       RxyN            : Normalized Short Term Correlation (as a Pearson
%                         correlation coefficeint)
%       RxyN2           : Normalized short term correlation (similar to
%                         RxyN but the means of X and Y are not removed)
%       tauaxis         : Delay Axis (sec)
%       taxis           : Time Axis (sec)
%
%   (C) M. Escabi, May 2016 (Edit June 20, 2016)
%
function [Rxy,RxyN,RxyN2,tauaxis,taxis]=xcorrstfastsym(X,Y,MaxLag,Fs,W,OF)

%Estimating Correlations
[Rxy,RxyN,RxyN2,tauaxis,taxis]=xcorrstfast(X,Y,MaxLag,Fs,W,OF);
[Ryx,RyxN,RyxN2,tauaxis,taxis]=xcorrstfast(Y,X,MaxLag,Fs,W,OF);

%Making sure that Rxy is an even function so as to have symmetry about tau=0
Rxy=(Rxy+flipud(Ryx))/2;
RxyN=(RxyN+flipud(RyxN))/2;
RxyN2=(RxyN2+flipud(RyxN2))/2;