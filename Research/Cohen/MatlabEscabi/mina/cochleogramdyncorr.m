%function [CorrData]=cochleogramdyncorr(data,Fs,dX,f1,fN,Fm,OF,dT,MaxDelay,MaxDisparity,OFc,Norm,GDelay,Gain,dis,ATT,ATTc,FilterType)
%	
%   FILE NAME   : COCHLEOGRAM DYN CORR
%   DESCRIPTION : Moves along the data in windows of size dT,
%                 Computes the short-term / dynamic cochleogram cross
%                 correlation function: R(t,tau)
%
%   data        : Input data vector (sound vector) or output data structure
%                 from cochleogram.m (AudData)
%   Fs          : Sampling Rate of original sound
%   dX          : Spectral Filter Bandwidth Resolution in Octaves
%                 Usually a fraction of an octave ~ 1/8 would allow 
%                 for a spectral envelope resolution of up to 4 
%                 cycles per octave
%                 Note that X=log2(f/f1) as defined for the ripple 
%                 representation 
%   f1          : Lower frequency to compute spectral decomposition
%   fN          : Upper freqeuncy to compute spectral decomposition
%   Fm          : Maximum Modulation frequency allowed for temporal
%                 envelope at each band. If Fm==inf full range of Fm is used.
%   OF          : Oversampling Factor for temporal envelope
%                 Since the maximum frequency of the envelope is 
%                 Fm, the Nyquist Frequency is 2*Fm
%                 The Frequency used to sample the envelope is 
%                 2*Fm*OF
%   dT          : Temporal Window Resolution (sec) - defined according to
%                 uncertainty principle so that dT = 2 * std(Wt) where Wt is a
%                 temporal Kaiser Window
%   MaxDelay    : Maximum delay time (sec)
%   MaxDisparity: Maximum distance between frequency channels used to
%                 find correlation function
%   OFc         : Oversampling Factor for correlation calculation
%   Norm        : Amplitude normalization (Optional)
%                 'En',  Equal Energy (Default)
%                 'Amp', Equal Amplitude
%   GDelay      : Remove group delay of filters prior to computing correlation 
%                 (Optional, 'y' or 'n': Default=='n')
%   Gain        : Output gain compression
%                 'dB', Units of dB (Defualt)
%                 'Lin', No compression
%   dis         : display (optional): 'log' or 'lin' or 'n'
%                 Default == 'n'
%   ATT         : Attenution / Sidelobe error in dB for Cochleogram Filterbank
%                 (Optional, Default == 60 dB) 
%   ATTc        : Attenuation / Sidelobe error for temporal window used to compute 
%                 dynamic correlation (Optional, Default == 40dB)
%   FilterType  : Type of filter to use (Optional): 'GammaTone' or 'BSpline'
%                 Default == 'GammaTone'
%
% RETURNED VARIABLES
%   CorrData    : Correlation data structure
%     .Rxy      : Short Term Correlation
%     .RxyN     : Normalized short term correlation (as a Pearson
%                 correlation coefficeint)
%     .RxyN2    : Normalized short term correlation (similar to
%                 RxyN but the means of X and Y are not removed)
%     .tauaxis  : Delay Axis (sec)
%     .taxis    : Time Axis (sec)
%     .Param.X  : Adds all input parameters from above 
%     .Param.Fst: Sampling rate for temporal axis of dynamic
%                 correlation
%     .Param.Wt : Temporal window used to segment dynamic correlation
%
%  (C) Monty A. Escabi, Aug 2015 (Edit Nov 2016, MAE)
%
function [CorrData]=cochleogramdyncorr(data,Fs,dX,f1,fN,Fm,OF,dT,MaxDelay,MaxDisparity,OFc,Norm,GDelay,Gain,dis,ATT,ATTc,FilterType)

%Input Parameters
if nargin<12
    Norm='En';
end
if nargin<13
    GDelay='n';
end
if nargin<14
    Gain='dB';
end
if nargin<15
	dis='n';
end
if nargin<16
	ATT=60;
end
if nargin<17
    ATTc=40;
end
if nargin<18 || isempty(FilterType)
   FilterType='GammaTone'; 
end

%Generating Cochleogram if necessary
if ~isstruct(data)
    data=data/std(data);    %Normalizing for unit variance
    [AudData]=cochleogram(data,Fs,dX,f1,fN,Fm,OF,Norm,dis,ATT,FilterType);
else
    AudData=data;
end

%Removing Group Delay if Desired (July 2015)
if strcmp(GDelay,'y') && strcmp(Gain,'dB')           %Corrected cochleogram is stored in 'data'
    S=AudData.ScdB;
elseif ~strcmp(GDelay,'y') && strcmp(Gain,'dB')
    S=AudData.SdB;
elseif strcmp(GDelay,'y') && strcmp(Gain,'Lin')      %Corrected cochleogram is stored in 'data'
    S=AudData.Sc;
elseif ~strcmp(GDelay,'y') && strcmp(Gain,'Lin')
    S=AudData.S;
end

%Generating Window
Fst=1/(AudData.taxis(2)-AudData.taxis(1));
[Beta,dN] = fdesignkdt(ATTc,dT,Fst);    %Fix ATT = 40 dB; Use Kaiser window to select data in time; dN is the window size to compute dynamic corrlation
Wt=kaiser(dN,Beta)';                    % Temporal Kaiser Window, April 2016, MAE
MaxLag=ceil(MaxDelay*Fst);

%Computing Short-Term Correlation from the Cochleogram
for k=1:size(S,1)         %Loop across channels
      
      if k+MaxDisparity <= size(S,1) 
         MaxCount = k+MaxDisparity;
      else
         MaxCount = size(S,1);
      end

     for l=k:MaxCount              %Lopp across channels

         %Computing short-term correlations
         [Rxy,RxyN,RxyN2,tauaxis,taxis]=xcorrstsym(S(k,:),S(l,:),MaxLag,Fst,Wt,OFc);
         CorrData.Rxy(k,l,:,:)=Rxy;
         CorrData.Rxy(l,k,:,:)=flipud(Rxy);

         CorrData.RxyN(k,l,:,:)=RxyN;
         CorrData.RxyN(l,k,:,:)=flipud(RxyN);

         CorrData.RxyN2(k,l,:,:)=RxyN2;
         CorrData.RxyN2(l,k,:,:)=flipud(RxyN2);

         CorrData.tauaxis=tauaxis;
         CorrData.taxis=taxis;

     end
end

%Adding Correlation Parameters - see header above for description
CorrData.Param.Fs=Fs;
CorrData.Param.dX=dX;
CorrData.Param.f1=f1;
CorrData.Param.fN=fN;
CorrData.Param.Fm=Fm;
CorrData.Param.OF=OF;
CorrData.Param.dT=dT;
CorrData.Param.MaxDelay=MaxDelay;
CorrData.Param.MaxDisparity=MaxDisparity;
CorrData.Param.OFc=OFc;
CorrData.Param.Norm=Norm;
CorrData.Param.GDelay=GDelay;
CorrData.Param.Gain=Gain;
CorrData.Param.ATT=ATT;
CorrData.Param.ATTc=ATTc;
CorrData.Param.FilterType=FilterType;
CorrData.Param.Fst=Fst;
CorrData.Param.Wt=Wt;
 
