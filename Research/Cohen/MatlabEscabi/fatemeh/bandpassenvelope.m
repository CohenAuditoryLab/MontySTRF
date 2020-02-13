%
%function [DataEnv]=bandpassenvelope(X,f1,f2,fm,Fs,FiltType,NLType,TW,TWm,ATT,ATTm)
%
%   FILE NAME   : BANDPASSENVELOPE
%   DESCRIPTION : Extracts the envelope of a signal within a band between
%                 f1 and f2. The modulations are limited to a frequency fm.
%
%   X           : Input signal
%   f1          : Lower cutoff frequency of bandpass filter (Hz)
%   f2          : Upper cutoff frequency of bandpass filter (Hz)
%   fm          : Upper modulation frequency limit (Hz)
%   Fs          : Samping rate (Hz)
%   FiltType    : Filter type: b-spline ('b') or Kaiser ('k'). Default=='b'
%   NLType      : Nonlinearity used to rectify 
%
%                 1 - Hilbert transform magnitude - uses analytic signal
%                     approximation
%                 2 - abs() - absolute value - full wave rectification
%                 3 - max(X,0) - half wave rectification
%                 4 - ().^2 - squared rectification
%
%                 Default == 1 (Hilbert approach)
%   TW          : Transition width of bandpass filter (Hz)
%                 (Optional, Default TW=0.25*min([f1 f2-f1 Fs/2-f2])
%   TWm         : Transition width of modualtion lowpass filter (Hz)
%                 (Optional, Default TWm=fm*0.25)
%   ATT         : Bandpass filter attenuation (Optional, Default==60 dB)
%   ATTm        : Lowpass modulation filter attenuation 
%                 (Optional, Default==60 dB)
%
%RETURNED OUTPUTS
%
%   DataEnv     : Data structure containing all of the extracted envelope
%                 information
%        .E     : Envelope of Data
%        .Enorm : Normalized envelope with unit standard deviation
%        .Xa    : Bandpass Filtered Signal
%        .Param : parameters used for generationg envelope
%
% (C) Monty A. Escabi, Jan 2016 (Edit Nov 2017)
%
function [DataEnv] = bandpassenvelope(X,f1,f2,fm,Fs,FiltType,NLType,TW,TWm,ATT,ATTm)

%Inputu Args
if nargin<6
    FiltType='b';
end
if nargin<7 | nargin<7
    NLType=1;
end
if nargin<8 | ~exist('TW')
    TW=0.25*min([f1 f2-f1 Fs/2-f2]);
end
if nargin<9 | ~exist('TWm')
    TWm=0.25*fm;
end
if nargin<10 | ~exist('ATT')
    ATT=60;
end
if nargin<11 | ~exist('ATTm')
    ATTm=60;
end

%Generating input and output filters
Ha=bandpass(f1,f2,TW,Fs,ATT,'n');
Na=(length(Ha)-1)/2;
if strcmp(FiltType,'k')
    Hb=lowpass(fm,TWm,Fs,ATTm,'n');
else
    Hb=bsplinelowpass(fm,5,Fs);
end
Nb=(length(Hb)-1)/2;
Hb=Hb/sum(Hb);  %Normalized for unit DC gain

%Bandpass filtering input
Xa=conv(X,Ha);
Xa=Xa(Na+1:end-Na);

%Extracting Envelope
if NLType==1
    E=abs(hilbert(Xa));
elseif NLType==2
    E=abs(Xa);
elseif NLType==3
    E=max(Xa,0);
else
    E=Xa.^2;
end

%Lowpass filtering Envelope
E=conv(E,Hb);
Nb=(length(Hb)-1)/2;
E=abs(E(Nb+1:end-Nb));

%Saving to Data Structure
DataEnv.Xa=Xa;                              % Filtered Signal
DataEnv.E=E;                                % Envelope
DataEnv.Enorm=DataEnv.E/std(DataEnv.E);     % Normalized Envelope
DataEnv.Param.f1=f1;                        % Lower cutoff frequency of bandpass filter (Hz)
DataEnv.Param.f2=f2;                        % Upper cutoff frequency of bandpass filter (Hz)
DataEnv.Param.fm=fm;                        % Upper modulation frequency limit (Hz)
DataEnv.Param.Fs=Fs;                        % Sampling Frequency of original signal
DataEnv.Param.FiltType=FiltType;            % Filter type used for lowpass filter - Kaiser or Bspline
