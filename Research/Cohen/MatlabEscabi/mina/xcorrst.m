%
%function [Rxy,RxyN,RxyN2,tauaxis,taxis]=xcorrst(X,Y,MaxLag,Fs,W,OF)
%
%       FILE NAME       : XCORR ST
%       DESCRIPTION     : Short term xcorrelation function.
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
%                         RxyN but the means of X and Y are not removed).
%                         Uses Schwartz inequality (normalizes by the norm)
%                         to guarantee that the normalized correlation is
%                         bounded
%
%                                   1 < RxyN2 < 1
%
%       tauaxis         : Delay Axis (sec)
%       taxis           : Time Axis (sec)
%
%   (C) M. Escabi, May 2016 (Edit June 20, 2016)
%
function [Rxy,RxyN,RxyN2,tauaxis,taxis]=xcorrst(X,Y,MaxLag,Fs,W,OF)

%Input arguments
if nargin<6
    OF=inf;
end

%Window Length
N=(length(W)-1)/2;

%Take square root of window - W^2 is the window used across X and Y and
%normalizing for unit area
W=sqrt(W);
    
%Limiting MaxLag if it is > than N
if MaxLag>N
    MaxLag=N;
end

%Find window bandwidth and determine step size to achieve desired
%oversampling factor
if OF==inf
    Fst=Fs;
    Nstep=1;
else
    NFFT=2^(nextpow2(2*N+1)+4);
    [dT,dF,dT3dB,dF3dB]=finddtdfw(W,Fs,NFFT);
    Fst=OF*4*dF3dB;         %Note that dF3dB/2 is the actual cutoff freuency. Choose 4*dF3dB (four times as much) to be conservative.
    Nstep=floor(Fs/Fst);    %Floor to make sure step size is integer value
    Fst=Fs/Nstep;           %This is the actual sampling rate after the floor() operation
end

%Computing short-term correlation
count=1;
for k=2*N+1:Nstep:length(X)-2*N       %Estimating short-term correlation for differnt time points - remove N points at edges to avoid edge effects

    %Selecting and Windowing data
    Wt=[zeros(1,MaxLag)  W  zeros(1,MaxLag)];
    Xt=X(k-N-MaxLag:k+N+MaxLag);
    Yt=Y(k-N-MaxLag:k+N+MaxLag);

    %Computing Instantaneous Means, second moment, and varaince. This is
    %used to normalize the time-varying correlation signal as a correlation coefficeint.
    %
    %Note that since X is the fixed reference signal (No delay), the mean and
    %variance are delay independent and only vary with time (not delay dependent)
    %
    %For Y, however, the means and varaince do vary with time and delay.
    %THerefore the variance is computed by estimaing the time and delay
    %dependent first and second moment and applying Var[Y]=E[Y^2]-E[Y]^2
    %
    MX(count)=mean(X(k-N:k+N).*W);                      %Mean of X - time depenedent
    VarX(count)=var(X(k-N:k+N).*W);                     %Variance of X - time dependent
    E2X(count)=sum((X(k-N:k+N).*W).^2)/(2*N+1);         %Second Moment of X - time dependent
    MY(:,count)=xcorr(Wt,Yt,MaxLag)'/(2*N+1);           %First Moment of Y - delay and time depdendent 
    E2Y(:,count)=xcorr(Wt.^2,Yt.^2,MaxLag)'/(2*N+1);    %Second Moment of Y - delay and time dependent 
    VarY(:,count)=E2Y(:,count)-MY(:,count).^2;          %Variance of Y - delay and time deopendent
       
    %Computing Short Term Correaltion
    Rxy(:,count)=xcorr(Xt.*Wt.^2,Yt,MaxLag)'/(2*N+1);   %Grab only the correlation for N point lag - this is where there is no edge artifact
    
    %Itteration Counter
    count=count+1;    

end

%Computing Normalized Correlations
MX=repmat(MX,size(MY,1),1);
VarX=repmat(VarX,size(VarY,1),1);
E2X=repmat(E2X,size(VarY,1),1);
RxyN=(Rxy-MX.*MY)./sqrt(VarX.*VarY);                    %Normalized as a correlation coefficient
RxyN2=Rxy./sqrt(E2X.*E2Y);                              %Normnalizes by the norm - According to the Schwartz inequality this gurantess that:   1 < RxyN2 < 1

%Time and delay axis
taxis=(1:size(Rxy,2))/Fst;
tauaxis=(-MaxLag:MaxLag)/Fs;