%
%function [Emodel,Time]=vocenvpulsemodel()
%	
%	FILE NAME 	: VOC ENV PULSE MODEL
%	DESCRIPTION : Envelope pulse model for vocalization. The vocalization
%                 envelope is modeled as a sequence of non overlapping
%                 pulses each definted by the onset time (T1), offset time
%                 (T2) and amplitude (A).
%
%	CallParam   : Vocalization data structure containing segmented calls
%
%   DF          : Down sampling factor (used for smapling rate of model
%                 envelope)
%
% (C) Monty A. Escabi, October 2017
%
function [Emodel,Time]=vocenvpulsemodel(CallParam,DF)

%Initializing
Fs=CallParam.Fs/DF;
T=max(CallParam.T2);
Emodel=zeros(1,round(Fs*T));

%Generating Vocalization Envelope Model
L=length(CallParam.T1);
N1=ceil([CallParam.T1]*Fs);
N2=ceil([CallParam.T2]*Fs);
for k=1:L
    Emodel(N1(k):N2(k))=ones(size(N1(k):N2(k)))*CallParam.A2(k);
end
Time=(0:length(Emodel)-1)/Fs;
