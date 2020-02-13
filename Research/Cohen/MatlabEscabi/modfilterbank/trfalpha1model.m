%
%function [TRF,E]=trfalpha1model(beta,taxis)
%
%   FILE NAME       : TRF ALPHA 1 MODEL
%   DESCRIPTION     : Temporal receptive field alpha function 1 model
%                     Fm and bandwidth are linear related (ratio using 1, temporarily)
%                     Phase use pi/4, fixed
%
%   beta            : Parameter vector
%                     beta(1): delay: Response latency (msec)
%                     beta(2): Fm: Character frequency (Hz)
%                     beta(3): Modulation bandwidth (Hz)
%                     beta(4): phase: default/recommendation is pi/4
%   taxis            : Time axis (msec) 
%
%RETURNED VARIABLES
%
%   TRF             : Model temporal receptive field (TRF)
%   E               : Envelope
%
% Feb 2, 2018
function [TRF, E]=trfalpha1model(beta,taxis)

if length(beta)<4
    phase = pi/4;
else
    phase = beta(4);
end

%Model Parameters
delay = beta(1);
Fm = beta(2);
bw = beta(3);
tau = 2*sqrt(sqrt(2)-1)/2/pi/bw;% sec 
%%% isn't tau should = sqrt(sqrt(2)-1)/pi/bw??? a factor of 2 may be wrong.
K = 0;

E = alphafxn1model([delay,tau*1000,1,K],taxis);
TRF = E.*cos(2*pi*Fm*(taxis-delay)/1000-phase);
A=max(abs(fft(TRF,1024*32)));
TRF = TRF/A;


% E * cos function changes the amplitude, since cos function here does not
% go to infinity, which means the fft analysis will be affected by this
% multiplication. 

% cos amplitude affection is interesting, think about it later. 