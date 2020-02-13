
%
%function [PNetData]=poissongennetwork(S,Fs,Fsd,Tref,Lambda,seed)
%
%   FILE NAME       : POISON GEN NETWORK
%   DESCRIPTION     : Poisson spiking network. Each Poisson is assumed
%                     independent. The network has N inputs and produces 
%                     N ouputs 
%
%   S               : Spatio-temporal sound input. Expressed as the firing
%                     rate over time and neurons 
%   Fs              : Sampling Rate (Hz)
%   Tref            : Refractory Period (msec)
%   Lambda          : Desired Network Spike Rate. The input S is normalized
%                     according so that it has a minimum value of zero and
%                     a mean value Lambda as follows:
%
%                     S=S-min(min(S));
%                     S=S/mean(mean(S))*Lambda;
%
%                     ( Optional; If not provided assumes Lamba=mean(mean(S)) )
%
%OUTPUT VARIABLES
%
%   PNetdata        : Data structure containing the oupout spike trains
%
% (C) Monty A. Escabi, Feb 2017
%
function [PNetData]=poissongennetwork(S,Fs,Fsd,Tref,Lambda,seed)

%Inpout Arguments
if nargin<4 | ~exist('Tref')
        Tref=1/Fsd;
end
if nargin<5 |~exist('Lambda')
    Lambda=mean(mean(S));
else
    S=S-min(min((S)));
    S=S/mean(mean(S))*Lambda;
end
if exist('seed')
    rand('seed',seed);
end

%Generating Output Spike Trains
for k=1:size(S,1)
    [PNetData(k).spet]=poissongen(S(k,:),Fs,Fsd,Tref);
    PNetData(k).Fs=Fsd;
end
