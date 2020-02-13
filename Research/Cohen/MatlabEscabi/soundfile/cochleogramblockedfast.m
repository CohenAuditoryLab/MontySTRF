%
% function []=cochleogramblockedfast(fileheader,data,Fs,dX,f1,fN,Fm,OF,TB,Norm,dis,ATT,FilterType)
%	
%	FILE NAME       : COCHLEOGRAM BLOCKED FAST
%	DESCRIPTION     : The progam produces an output similar to COCHLEOGRAM but 
%                     the data is blocked into segments of TB seconds. This
%                     routine is faster than COCHLEOGRAM BLOCKED since it
%                     doesn't use temporary files but takes more memory.
%  
%	fileheader    : Output File Header
%   data          : Input data
%	Fs            : Sampling Rate
%	dX		      : Spectral separation betwen adjacent filters in octaves
%			        Usually a fraction of an octave ~ 1/8 would allow 
%			        for a spectral envelope resolution of up to 4 
%			        cycles per octave
%			        Note that X=log2(f/f1) as defined for the ripple 
%			        representation 
%	f1		      : Lower frequency to compute spectral decomposition
%	fN		      : Upper freqeuncy to compute spectral decomposition
%	Fm		      : Maximum Modulation frequency allowed for temporal
%			        envelope at each band. If Fm==inf full range of Fm is used.
%	OF		      : Oversampling Factor for temporal envelope
%			        Since the maximum frequency of the envelope is 
%			        Fm, the Nyquist Frequency is 2*Fm
%			        The Frequency used to sample the envelope is 
%			        2*Fm*OF
%  TB             : Analysis Block Size (sec)
%  Norm           : Amplitude normalization (Optional)
%                   En:  Equal Energy (Default)
%                   Amp: Equal Amplitude
%	dis           : display (optional): 'log' or 'lin' or 'n'
%                     Default == 'n'
%	ATT           : Attenution / Sidelobe error in dB (Optional)
%                     Default == 60 dB
%   FilterType    : Type of filter to use (Optional): 'GammaTone' or 'BSpline'
%                   Default == 'GammaTone'
%
% (C) Monty A. Escabi, September 2015 
%
function []=cochleogramblockedfast(fileheader,data,Fs,dX,f1,fN,Fm,OF,TB,Norm,dis,ATT,FilterType)

%Input Parameters
if nargin<10 || isempty(Norm)
    Norm='En';
end
if nargin<11 || isempty(dis)
	dis='n';
end
if nargin<12 || isempty(ATT)
	ATT=60;
end
if nargin<13 || isempty(FilterType)
   FilterType='GammaTone'; 
end

%Computing Cochleogram for the whole sound file
[CochData]=cochleogram(data,Fs,dX,f1,fN,Fm,OF,Norm,dis,ATT,FilterType);

%Temporal downsampling factor and block size
DF=max(ceil(Fs/2/Fm/OF),1);     %Downsampling factor
NB=ceil(Fs*TB/DF);              %Block size in samples

%Blocking the data
count=1;
while count*NB < size(CochData.S,2)
eval(['CochData'  int2str(count) '.S = CochData.S(:,(count-1)*NB+1:count*NB);'])
eval(['CochData'  int2str(count) '.SdB = CochData.SdB(:,(count-1)*NB+1:count*NB);'])
eval(['CochData'  int2str(count) '.Sc = CochData.Sc(:,(count-1)*NB+1:count*NB);'])
eval(['CochData'  int2str(count) '.ScdB = CochData.ScdB(:,(count-1)*NB+1:count*NB);'])
eval(['CochData'  int2str(count) '.Sf = CochData.Sf;'])
eval(['CochData'  int2str(count) '.taxis = CochData.taxis(:,(count-1)*NB+1:count*NB);'])
eval(['CochData'  int2str(count) '.faxis = CochData.faxis;'])
eval(['CochData'  int2str(count) '.Norm = CochData.Norm;']) 
eval(['CochData'  int2str(count) '.NormGain = CochData.NormGain;']) 
eval(['CochData'  int2str(count) '.Filter = CochData.Filter;']) 
eval(['CochData'  int2str(count) '.GroupDelay = CochData.GroupDelay;'])
eval(['CochData'  int2str(count) '.BW = CochData.BW;'])
eval(['CochData'  int2str(count) '.Param = CochData.Param;'])

%Saving Data 

    if count==1
        save ([fileheader '_AGram'],['CochData'  int2str(count)]);
    else
        save ([fileheader '_AGram'],['CochData'  int2str(count)],'-append');
    end
    
count=count+1;
end

if size(CochData.S,2) - ((count-1)*NB) >= 0
eval(['CochData'  int2str(count) '.S = CochData.S(:,(count-1)*NB+1:end);'])
eval(['CochData'  int2str(count) '.SdB = CochData.SdB(:,(count-1)*NB+1:end);'])
eval(['CochData'  int2str(count) '.Sc = CochData.Sc(:,(count-1)*NB+1:end);'])
eval(['CochData'  int2str(count) '.ScdB = CochData.ScdB(:,(count-1)*NB+1:end);'])
eval(['CochData'  int2str(count) '.Sf = CochData.Sf;'])
eval(['CochData'  int2str(count) '.taxis = CochData.taxis(:,(count-1)*NB+1:end);'])
eval(['CochData'  int2str(count) '.faxis = CochData.faxis;'])
eval(['CochData'  int2str(count) '.Norm = CochData.Norm;']) 
eval(['CochData'  int2str(count) '.NormGain = CochData.NormGain;']) 
eval(['CochData'  int2str(count) '.Filter = CochData.Filter;']) 
eval(['CochData'  int2str(count) '.GroupDelay = CochData.GroupDelay;'])
eval(['CochData'  int2str(count) '.BW = CochData.BW;'])
eval(['CochData'  int2str(count) '.Param = CochData.Param;'])

save ([fileheader '_AGram'],['CochData'  int2str(count)],'-append');

LB=count; %LB is the number of blocks
save([fileheader '_AGram'],'LB','-append');

end

