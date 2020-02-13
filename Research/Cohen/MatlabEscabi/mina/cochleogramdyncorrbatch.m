%
% function []=cochleogramdyncorrbatch(SoundExcelSheetHeader,FileHeader,N,dx,f1,fN,Fm,OF,TB,Dur,dT,MaxDelay,MaxDisparity,OFc,FsRe,Norm,GDelay,Gain,dis,ATT,ATTc,FilterType)
%	
%	FILE NAME 	  : COCHLEOGRAM DYN CORR BATCH
%	DESCRIPTION   : Generates and saves blocked Cochleogram & blocked 
%                   Correlation of sounds specified in the Excel sheet. It 
%                   receives the list of sounds from SoundExcelSheetHeader.
% 
%   SoundExcelSheetHeader : Sound Excel Sheet Header
%   FileHeader            : Sound Header ('/Volumes/TextureData1')
%   N        : Number of different sound categories
%	dx		 : Spectral Filter Bandwidth Resolution in Octaves
%			  Usually a fraction of an octave ~ 1/8 would allow
%			  for a spectral envelope resolution of up to 4 
%			  cycles per octave
%			  Note that X=log2(f/f1) as defined for the ripple 
%			  representation 
%	f1		 : Lower frequency to compute spectral decomposition
%	fN		 : Upper freqeuncy to compute spectral decomposition
%	Fm		 : Maximum Modulation frequency allowed for temporal
%			  envelope at each band. If Fm==inf full range of Fm is used.
%	OF		 : Oversampling Factor for temporal envelope
%			  Since the maximum frequency of the envelope is 
%			  Fm, the Nyquist Frequency is 2*Fm:q!
%			  The Frequency used to sample the envelope is 
%			  2*Fm*OF
%   TB       : Analysis Block Size (sec)
%   Dur      : Duration of sound to be used for analyzing (sec)
%   dT       : Temporal Window Resolution (sec) - defined according to
%              uncertainty principle so that dT = 2 * std(Wt) where Wt is a
%              temporal Kaiser Window
%   MaxDelay : Maximum delay time (sec)
%   MaxDisparity : Maximum distance between frequency channels used to
%                  find correlation function
%   OFc      : Oversampling Factor for correlation calculation
%   FsRe     : Resampling frequency
%   Norm     : Amplitude normalization (Optional)
%              En:  Equal Energy (Default)
%              Amp: Equal Amplitude
%   GDelay   : Remove group delay of filters prior to computing correlation 
%             (Optional, 'y' or 'n': Default=='n')
%   Gain      : Output gain compression
%               'dB', Units of dBDefualt)
%               'Lin', No compression
%	dis		 : display (optional): 'log' or 'lin' or 'n'
%			  Default == 'n'
%	ATT		 : Attenution / Sidelobe error in dB for Cochleogram Filterbank
%             (Optional, Default == 60 dB) 
%   ATTc     : Attenuation / Sidelobe error for temporal window used to compute 
%             dynamic correlation (Optional, Default == 40dB)
%   FilterType  : Type of filter to use (Optional): 'GammaTone' or 'BSpline'
%                 Default == 'GammaTone'
%
% (C) Mina, Jan 2017 
%
function []=cochleogramdyncorrbatch(SoundExcelSheetHeader,FileHeader,N,dx,f1,fN,Fm,OF,TB,Dur,dT,MaxDelay,MaxDisparity,OFc,FsRe,Norm,GDelay,Gain,dis,ATT,ATTc,FilterType)

%Input Parameters
if nargin<16
    Norm='En';
end
if nargin<17
    GDelay='n';
end
if nargin<18
    Gain='dB';
end
if nargin<19
	dis='n';
end
if nargin<20
	ATT=60;
end
if nargin<21
    ATTc=40;
end
if nargin<22 || isempty(FilterType)
    FilterType='GammaTone';
end
for k=1:N
    %Reading Sound Excel Sheet
    [num,TXT,~]= xlsread(SoundExcelSheetHeader,['Category' int2str(k)]);
    CatName=cell2mat(TXT(3,2));
    mkdir(CatName);
    
    for n=4:size(TXT,1)
       path=[FileHeader '/' cell2mat(TXT(n,16))];
       %Reading sounds
       [data,Fs]=audioread(path);
       
       %Resampling data to Fs
       if Fs ~= FsRe
       data=resample(data,FsRe,Fs);
       Fs=FsRe;
       end
       
       OutFileHeader=['Sound' int2strconvert(n-3,3)];
       SampleNum=Fs*Dur;
       start_time=Fs*num(n,3);
       
       %Generating blocked cochleograms
       if length(data)>SampleNum
          cochleogramblockedfast([CatName '/' OutFileHeader],data((1+start_time):(SampleNum+start_time),1),Fs,dx,f1,fN,Fm,OF,TB,Norm,dis,ATT,FilterType)
       else
          cochleogramblockedfast([CatName '/' OutFileHeader],data(:,1),Fs,dx,f1,fN,Fm,OF,TB,Norm,dis,ATT,FilterType)
       end
         
       load([CatName '/' OutFileHeader '_AGram'])
       
       for counter=1:LB
           %Generating Correlation blocks
           eval([ '[CorrData' int2str(counter) ']=cochleogramdyncorr(AudData' int2str(counter) ',Fs,dx,f1,fN,Fm,OF,dT,MaxDelay,MaxDisparity,OFc,Norm,GDelay,Gain,dis,ATT,ATTc,FilterType)' ])
           %Saving Correlation blocks
           if counter==1
           save ([CatName '/' OutFileHeader '_DynCorr'],['CorrData'  int2str(counter)]);
           else
           save ([CatName '/' OutFileHeader '_DynCorr'],['CorrData'  int2str(counter)],'-append');
           end
       end
       %Saving number of blocks
       save([CatName '/' OutFileHeader '_DynCorr'],'LB','-append');
    end
end