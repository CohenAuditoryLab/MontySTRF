%
%function [CochStatsData,CochData,CochDataMS] = cochleogramstatanalysis(filename,T1,T2,dX,f1,fN,Fm,fm1,dfm,Nms,OF,Norm,MSflag,ATT,dT,Overlap,GDelay,dFm,Save,SUFFIX)
%	
%	FILE NAME   : COCHLEOGRAM STAT ANALYSIS ALL
%	DESCRIPTION : Analyzes the spectro-temproal statistics of a sound
%                 database. The METAData contains information of the sound
%                 database that will be analyzed. See XLS2METADATA for
%                 details. The program first generates and cochleogram for
%                 each sound. Subsequently it will measure statistics from
%                 the cochleogram including: the amplitude statistcs,
%                 multi-scale statistics, channel correlations, and
%                 modualtion spectrum.
%
%   filename: Filename for WAV sound to be analyzed
%   T1      : Start time for data to be analyzed (sec) - if 0 uses the
%             first sample point as begining of file
%   T2      : End time for data to be analyzed (sec) - if Inf uses the last
%             sample point as the end of file
%	dX		: Spectral Filter Bandwidth Resolution in Octaves
%			  Usually a fraction of an octave ~ 1/8 would allow 
%			  for a spectral envelope resolution of up to 4 
%			  cycles per octave
%			  Note that X=log2(f/f1) as defined for the ripple 
%			  representation 
%	f1		: Lower frequency to compute spectral decomposition
%	fN		: Upper freqeuncy to compute spectral decomposition
%	Fm		: Maximum Modulation frequency allowed for temporal
%			  envelope at each band. If Fm==inf full range of Fm is used.
%   fm1     : Lowest modulation frequency for multi-scale decomposition
%   dfm     : Modulation filter bandwidht (Octave for MSflag=1; Hz for
%             MSflag==2) for multi-scale decomposition
%   Nms     : Number of multi-scale decompositions
%	OF		: Oversampling Factor for temporal envelope
%			  Since the maximum frequency of the envelope is 
%			  Fm, the Nyquist Frequency is 2*Fm
%			  The Frequency used to sample the envelope is 
%			  2*Fm*OF
%   Norm    : Amplitude normalization (Optional)
%             En:  Equal Energy (Default)
%             Amp: Equal Amplitude
%   MSflag  : Multi-scale flag
%             MSflag==1     - proportional filters (Octave, default)
%             MSflag==2     - equal resolution filters (Hz)
%   ATT     : Attenution / Sidelobe error in dB (Optional)
%             Default == 60 d
%   dT      : Temporal Window Used to Compute Amplitude Distribution (sec)
%   Overlap : Percent overlap between consecutive windows used to genreate
%             contrast distribution. Overlap = 0 to 1. 0 indicates no
%             overlap. 0.9 would indicate 90 % overlap.
%   GDelay  : Remove group delay of filters prior to computing ripple 
%             spectrum (Optional, 'y' or 'n': Default=='n')
%   dFm     : Temporal modulaiton frequency resolution (Hz) for Ripple
%             Spectrum (see RIPPLESPEC.M)
%   Save    : Save analyzed data to file : 'y' or 'n' (Optional, Default='n')
%   SUFFIX  : Filename suffix (Optional, if desired)
%
%RETURNED VARIABLES
%
%   CochStatsData    : Cochleogram statistics Data Structure
%                     .X            - Sound segment
%                     .AmpData      - Amplitude / contrast statistics (see
%                                     COCHLEOGRAMAMPDIST)
%                     .CorrDataMS   - Multi-Scale Channel Correlations (see
%                                     COCHLEOGRAMCHANCORRMULTISCALE.m)
%                     .CorrData     - Channel Correlations (see
%                                     COCHLEOGRAMCHANCORR.m)
%                     .RipSpec      - Ripple Spectrum (see RIPPLESPEC.m)
%                     .filename     - filename
%                     .Fs           - Sampling Rate
%                     .Param        - Data structure containig all of the
%                                     input parameters used for the anlaysis 
%
%   CochData         : Cochleogram (see COCHLEOGRAM.m)
%   CochDataMS       : Multi-scale cochleogram (see COCHLEOGRAMMULTISCALE.m)
%
%   If Save=='y' the three data sturcture fields are stored into a data
%   file with the original filename header and a Suffix 'COCHSTATS'
%
% (C) Monty A. Escabi, January 2013
%
function [CochStatsData,CochData,CochDataMS] = cochleogramstatanalysis(filename,T1,T2,dX,f1,fN,Fm,fm1,dfm,Nms,OF,Norm,MSflag,ATT,dT,Overlap,GDelay,dFm,Save,SUFFIX)

%Input Args
if nargin<19
    Save='n';
end
if nargin<20
    SUFFIX='';
end
%Reading WAV FILE and normalizing data
[X,Fs]=wavread(filename);   %Reading WAV Data
if size(X,2)==2
    X=X(:,1);               %Selecting Channel 1
end
X=X/std(X);                 %Normalizing for unit variance

%Selecting Sound Segments
N1=max(ceil(T1*Fs),1);
N2=min(floor(T2*Fs),length(X));
X=X(N1:N2);

%Analyzing Cochleogram Statistics
dis='n';
[CochData]=cochleogram(X,Fs,dX,f1,fN,Fm,OF,'Amp','log');
[CochDataMS]=cochleogrammultiscale(CochData,Fs,dX,f1,fN,Fm,fm1,dfm,Nms,OF,Norm,MSflag,dis,ATT);
[AmpData]=cochleogramampdist(CochData,Fs,dX,[],[],[],[],dT,Overlap);
[CorrDataMS]=cochleogramchancorrmultiscale(CochDataMS,Fs,dX,f1,fN,Fm,fm1,dfm,Nms,OF,Norm,MSflag,dis,ATT);
[CorrData]=cochleogramchancorr(CochData,Fs,dX,f1,fN,Fm,OF,Norm,GDelay,dis,ATT);
[RipSpec]=ripplespec(CochData,Fs,dX,dFm,f1,fN,Fm,OF,Norm,GDelay,dis,ATT);

%Combinging results into a single data structure
CochDataStats.X=X;
CochStatsData.AmpData=AmpData;
CochStatsData.CorrDataMS=CorrDataMS;
CochStatsData.CorrData=CorrData;
CochStatsData.RipSpec=RipSpec;
CochStatsData.filename=filename;
CochStatsData.Param.Fs=Fs;
CochStatsData.Param.T1=T1;
CochStatsData.Param.T2=T2;
CochStatsData.Param.dX=dX;
CochStatsData.Param.f1=f1;
CochStatsData.Param.fN=fN;
CochStatsData.Param.Fm=Fm;
CochStatsData.Param.fm1=fm1;
CochStatsData.Param.dfm=dfm;
CochStatsData.Param.Nms=Nms;
CochStatsData.Param.OF=OF;
CochStatsData.Param.Norm=Norm;
CochStatsData.Param.MSflag=MSflag;
CochStatsData.Param.ATT=ATT;
CochStatsData.Param.dT=dT;
CochStatsData.Param.Overlap=Overlap;
CochStatsData.Param.GDelay=GDelay;
CochStatsData.Param.dFm=dFm;

%Saving Data
if strcmp(Save,'y')
    i=strfind(filename,'.');
    outfile=[filename(1:i-1) '_' SUFFIX '_COCHSTATS'];
    save(outfile,'CochStatsData','CochData','CochDataMS');
end