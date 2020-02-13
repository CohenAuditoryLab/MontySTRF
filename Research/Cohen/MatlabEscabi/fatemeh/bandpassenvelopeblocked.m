%
%function [DataEnv]=bandpassenvelopeblocked(X,f1,f2,fm,Fs,FiltType,NLType,TW,TWm,ATT,ATTm,M,N)
%
%   FILE NAME   : BANDPASS ENVELOPE BLOCKED
%   DESCRIPTION : Extracts the envelope of a signal within a band between
%                 f1 and f2. The modulations are limited to a frequency fm.
%                 Uses Overlap Save method to assure that there are no edge
%                 artifacts. See FILTFILE.m. The output is identical to
%                 BANDPASSENVELOPE but the routine is implemented in data
%                 blocks of size M.
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
%
%   TW          : Transition width of bandpass filter (Hz)
%                 (Optional, Default TW=0.25*min([f1 f2-f1 Fs/2-f2])
%   TWm         : Transition width of modualtion lowpass filter (Hz)
%                 (Optional, Default TWm=fm*0.25)
%   ATT         : Bandpass filter attenuation (Optional, Default==60 dB)
%   ATTm        : Lowpass modulation filter attenuation 
%                 (Optional, Default==60 dB)
%   M           : Block Size (Defaul=1024*128)
%   N           : Number of filter coefficients (2*N+1) used for the
%                 Hilbert Kernel (Optional, Default==1000)

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
function [DataEnv] = bandpassenvelopeblocked(X,f1,f2,fm,Fs,FiltType,NLType,TW,TWm,ATT,ATTm,M,N)

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
if nargin<12 | ~exist(M)
   M=1024*128; 
end
if nargin<13 | ~exist(N)
   N=1000; 
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

%Generate Temporary File
infile='XInputData.bin';
outfileXa='XaOutputData.bin';   %Contains bandpass filtered signal
outfileXh='XhOutputData.bin';   %Contains hilbert transform of Xa
outfileE='EOutputData.bin';     %Contains envelope signal
outfileEb='EbOutputData.bin';   %Contains filtered envelope signal
fid=fopen(infile,'wb');
fwrite(fid,X,'float');
fclose(fid);

%Bandpass filtering input
filtfile(infile,outfileXa,[],[],[],[],Fs,M,[],'float',Ha);

%Computing Envelope
if NLType==1
    %Computing Envelope - to do this step we will compute the Hilbert
    %transform by convolving the Hilbert Kernel with the input. We then
    %generate the anlytic signal and its magnitude to estimate the Envelope.

    %Generating Hilbert Kernel - there is a N+1 point group delay in the output
    %that needs to be subtracted
    n=-N:N;                                 %2*N+1 filter coefficients for Hilber Kernel
    Hh=real([(1-(exp(j*pi*n)))./pi./n]);    %See Gold, Oppenheim, Rader - 1969 - Eqn. 24 defines the Hilbert Kernel
    Hh(N+1)=0;
    filtfile(outfileXa,outfileXh,[],[],[],[],Fs,M,[],'float',Hh);

    %Computing Unfiltered Envelope
    addfilemag(outfileXa,outfileXh,outfileE,'float',M);
    
elseif NLType==2
    %Full Wave Rectification
    filerectify(ou,outtfileXa,outfileE,'float',M,1)
elseif NLType==3
    %Half Wave Rectification
    filerectify(ou,outtfileXa,outfileE,'float',M,2)
else
    %Squared Wave Rectification
    filerectify(ou,outtfileXa,outfileE,'float',M,3)
end

    %Lowpass filtering Envelope
    filtfile(outfileE,outfileEb,[],[],[],[],Fs,M,[],'float',Hb);

%Reading Data
fid=fopen(outfileEb,'rb');
E=fread(fid,inf,'float')';
fclose(fid);
fid=fopen(outfileXa,'rb');
Xa=fread(fid,inf,'float')';
fclose(fid);

%Removing Temporary Files 
if isunix
    eval('!rm *InputData.bin *OutputData.bin')
end
if ispc
   eval('!del *InputData.bin *OutputData.bin') 
end

%Saving to Data Structure
DataEnv.Xa=Xa;                              % Filtered Signal
DataEnv.E=E;                                % Envelope
DataEnv.Enorm=DataEnv.E/std(DataEnv.E);     % Normalized Envelope
DataEnv.Param.f1=f1;                        % Lower cutoff frequency of bandpass filter (Hz)
DataEnv.Param.f2=f2;                        % Upper cutoff frequency of bandpass filter (Hz)
DataEnv.Param.fm=fm;                        % Upper modulation frequency limit (Hz)
DataEnv.Param.Fs=Fs;                        % Sampling Frequency of original signal
DataEnv.Param.FiltType=FiltType;            % Filter type used for lowpass filter - Kaiser or Bspline
DataEnv.Param.M=M;                          % Block Size
DataEnv.Param.N=N;                          % Number of filter coefficients (2*N+1) used for the Hilbert Kernel