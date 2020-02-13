%
%function [Rxy,RxyN,RxyN2,tauaxis,taxis]=xcorrstsym(X,Y,MaxLag,Fs,W,OF)
%
%       FILE NAME       : XCORR ST SYM
%       DESCRIPTION     : Short term xcorrelation function. This version is
%                         similar to XCORRST but guarantees correaltion
%                         symmetry so that
%
%                           Rxy(t,tau)=Ryx(t,-tau)
%
%       X,Y             : Signals to be correlated
%       MaxLag          : Maximum number of delay samples. If MaxLag is >
%                         N, where N is half the window width then MaxLag
%                         is limited to N
%       Fs              : Sampling Rate
%       W               : Window used for short-term analysis (should be a 
%                         row vector with dimensions 1x2*N+1)
%       OF              : Oversampling factor - intiger value that
%                         determines how much to oversample the time axis
%                         for the specified window used (Default==inf). If
%                         using default the time axis is computed at a
%                         smapling rate of Fs.
%
%RETURNED VALUES
%       Rxy             : Short Term Correlation
%       RxyN            : Normalized short term correlation (as a Pearson
%                         correlation coefficeint)
%       RxyN2           : Normalized short term correlation (similar to
%                         RxyN but the means of X and Y are not removed)
%       tauaxis         : Delay Axis (sec)
%       taxis           : Time Axis (sec)
%
%   (C) M. Escabi, May 2016 (Edit June 20, 2016)
%
function [Rxy,RxyN,RxyN2,tauaxis,taxis]=xcorrstsym(X,Y,MaxLag,Fs,W,OF)

%Estimating Correlations
[Rxy,RxyN,RxyN2,tauaxis,taxis]=xcorrst(X,Y,MaxLag,Fs,W,OF);
[Ryx,RyxN,RyxN2,tauaxis,taxis]=xcorrst(Y,X,MaxLag,Fs,W,OF);

%Making sure that Rxy is an even function so as to have symmetry about tau=0
Rxy=(Rxy+flipud(Ryx))/2;
RxyN=(RxyN+flipud(RyxN))/2;
RxyN2=(RxyN2+flipud(RyxN2))/2;