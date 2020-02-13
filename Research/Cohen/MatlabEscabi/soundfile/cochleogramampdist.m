%
%function [AmpData]=cochleogramampdist(data,Fs,dX,f1,fN,Fm,OF,dT,ND,Norm,dis,ATT)
%	
%	FILE NAME 	: COCHLEOGRAM AMP DIST
%	DESCRIPTION : Computes time-dependent envelope amplitude / contrast
%                 distribution from the cochleogram of a sound
%
%   data    : Input data vector (sound vector) or output data structure
%             from cochleogram.m (CochData)
%   Fs      : Sampling Rate
%   dX      : Spectral Filter Bandwidth Resolution in Octaves
%             Usually a fraction of an octave ~ 1/8 would allow
%             for a spectral envelope resolution of up to 4
%             cycles per octave
%             Note that X=log2(f/f1) as defined for the ripple
%             representation
%   f1      : Lower frequency to compute spectral decomposition
%   fN      : Upper freqeuncy to compute spectral decomposition
%   Fm      : Maximum Modulation frequency allowed for temporal
%             envelope at each band. If Fm==inf full range of Fm is used.
%   OF      : Oversampling Factor for temporal envelope
%             Since the maximum frequency of the envelope is
%             Fm, the Nyquist Frequency is 2*Fm
%             The Frequency used to sample the envelope is
%             2*Fm*OF
%   dT      : Temporal Window Used to Compute Amplitude Distribution (sec)
%   Overlap : Percent overlap between consecutive windows used to genreate
%             contrast distribution. Overlap = 0 to 1. 0 indicates no
%             overlap. 0.9 would indicate 90 % overlap.
%   ND      : Polynomial Order: Detrends the local spectrum
%             by fiting a polynomial of order ND. The fitted
%             trend is then removed(Default==1, No detrending)
%   Norm    : Amplitude normalization (Optional)
%             'En'  = Equal Energy (Default)
%             'Amp' = Equal Amplitude
%   dis     : display (optional): 'log' or 'lin' or 'n'
%             Default == 'n'
%   ATT     : Attenution / Sidelobe error in dB (Optional)
%             Default == 60 dB
%
%RETURNED VARIABLES
%
%   AmpData : Data Structure containg the following 
%
%             .PDist1       - Time dependent amplitude distribution - mean
%                             removed
%             .PDist2       - Time dependent amplitude distribution - best
%                             polynomial fit of power spectrum removed
%             .PDist3       - Time dependent amplitude distribution - mean
%                             power spectrum removed
%             .StddB1,2,3   - Standard deviation (dB)
%             .MeandB1,2,3  - Mean amplitude (dB)
%             .KurtdB1,2,3  - Kurtosis
%             .PDist1r      - Time dependent amplitude distribution - mean
%                             removed - for randomized time samples - used 
%                               as a reference condition
%             .PDist2r      - Time dependent amplitude distribution - best
%                             polynomial fit of power spectrum removed - 
%                             for randomized time samples - used as a 
%                             reference condition
%             .PDist3r      - Time dependent amplitude distribution - mean
%                             power spectrum removed - for randomized time
%   `                         samples - used as a reference condition
%             .StddB1r,2,3  - Standard deviation (dB) - for randomized time
%                             samples - used as a reference condition
%             .MeandB1r,2,3 - Mean amplitude (dB) - for randomized time
%                             samples - used as a reference condition
%             .KurtdB1r,2,3 - Kurtosis - for randomized time
%                             samples - used as a reference condition
%             .Time         - Time Axis
%             .Amp          - Amplitude Axis ( decibels )
%             .dT           - Temporal Window Used to Compute Amplitude
%                             Distribution (sec)
%             .dN           - Temporal Window Used to Compute Amplitude
%                             Distribution (samples)
%
% (C) Monty A. Escabi, (Edit May 2014)
%
function [AmpData]=cochleogramampdist(data,Fs,dX,f1,fN,Fm,OF,dT,Overlap,ND,Norm,dis,ATT)

%Input Parameters
if nargin<10
	ND=1;
end
if nargin<11
    Norm='En';
end
if nargin<12
	dis='n';
end
if nargin<13
	ATT=60;
end

%Generating Cochleogram if necessary
if ~isstruct(data)
    data=data/std(data);    %Normalizing for unit variance
    [CochData]=cochleogram(data,Fs,dX,f1,fN,Fm,OF,Norm,dis,ATT);
else
    CochData=data;
end

%Detrending Probability Distribution
SdB=20*log10(CochData.S);
i=find(~isinf(SdB));
MindB=min(SdB(i));
i=find(isinf(SdB));
SdB(i)=MindB*ones(size(SdB(i)));                %Remove values with -Inf - i.e., note that when S == 0 -> SdB=-Inf
SdB1=SdB-mean(mean(SdB));                       %Subtract Mean Value
[P,S] = polyfit(log2(CochData.faxis),mean(SdB'),ND);
[Sline] = polyval(P,log2(CochData.faxis),S);
SdB2=SdB-Sline'*ones(1,size(SdB,2));            %Subtract straight line fit
SdB3=SdB-mean(SdB,2)*ones(1,size(SdB,2));       %Subtract Mean Spectrum

%Randomly sampled spectrograms
SdB1r=SdB1(:,randsample(size(SdB1,2),size(SdB1,2)));
SdB2r=SdB2(:,randsample(size(SdB2,2),size(SdB2,2)));
SdB3r=SdB3(:,randsample(size(SdB3,2),size(SdB3,2)));

%Computing Amplitude Distribution
Fst=1/(CochData.taxis(2)-CochData.taxis(1));
dN=round(dT*Fst);                               %Window size to compute distribution
dNt=round(dT*Fst*(1-Overlap));                  %Temporal sampling period for computing distribution (in sample numbers)
count=1;
PDist1=[];
PDist2=[];
PDist3=[];
PDist1r=[];
PDist2r=[];
PDist3r=[];
while count*dNt+dN<size(CochData.S,2)
    offset=(count-1)*dNt;
  
    %Mean value removed
    SS1=reshape(SdB1(:,offset+1:offset+dN),1,numel(SdB1(:,offset+1:offset+dN)));
    [P1,Amp]=hist(SS1,[-100:1:100]);
    PDist1=[PDist1 P1'/length(SS1)];
    
    %Straight line removed
    SS2=reshape(SdB2(:,offset+1:offset+dN),1,numel(SdB2(:,offset+1:offset+dN)));
    [P2,Amp]=hist(SS2,[-100:1:100]);
    PDist2=[PDist2 P2'/length(SS2)];
    
    %Mean spectrum removed
    SS3=reshape(SdB3(:,offset+1:offset+dN),1,numel(SdB3(:,offset+1:offset+dN)));
    [P3,Amp]=hist(SS3,[-100:1:100]);
    PDist3=[PDist3 P3'/length(SS3)];
    
    %Random Sampled Data Distributions - used as a null hypothesis and for
    %stationarity analysis
    
    %Mean value removed
    SS1=reshape(SdB1r(:,offset+1:offset+dN),1,numel(SdB1r(:,offset+1:offset+dN)));
    [P1r,Amp]=hist(SS1,[-100:1:100]);
    PDist1r=[PDist1r P1r'/length(SS1)];
    
    %Straight line removed
    SS2=reshape(SdB2r(:,offset+1:offset+dN),1,numel(SdB2r(:,offset+1:offset+dN)));
    [P2r,Amp]=hist(SS2,[-100:1:100]);
    PDist2r=[PDist2r P2r'/length(SS2)];
    
    %Mean spectrum removed
    SS3=reshape(SdB3r(:,offset+1:offset+dN),1,numel(SdB3r(:,offset+1:offset+dN)));
    [P3r,Amp]=hist(SS3,[-100:1:100]);
    PDist3r=[PDist3r P3r'/length(SS3)];
    
%     %Choosing randomly sampled time values
%     index=randsample(size(SdB1,2),dN);
%  
%     %Mean value removed
%     SS1=reshape(SdB1(:,index),1,numel(SdB1(:,index)));
%     [P1r,Amp]=hist(SS1r,[-100:1:100]);
%     PDist1r=[PDist1r P1r'/length(SS1)];
%     
%     %Straight line removed
%     SS2=reshape(SdB2(:,index),1,numel(SdB2(:,index)));
%     [P2r,Amp]=hist(SS2r,[-100:1:100]);
%     PDist2r=[PDist2r P2r'/length(SS2)];
%     
%     %Mean spectrum removed
%     SS3=reshape(SdB3(:,index),1,numel(SdB3(:,index)));
%     [P3r,Amp]=hist(SS3,[-100:1:100]);
%     PDist3r=[PDist3r P3r'/length(SS3)];
%     
    %Amplitude Axis
	Amp=Amp';
    
    %Counter
    count=count+1;

end

%Finding Mean, Std, and Kurtosis Trajectories
Time=(0:size(PDist1,2)-1)*dNt/Fst;
[Time,StddB1,MeandB1,KurtdB1]=ampstdmean(Time,Amp,PDist1);
[Time,StddB2,MeandB2,KurtdB2]=ampstdmean(Time,Amp,PDist2);
[Time,StddB3,MeandB3,KurtdB3]=ampstdmean(Time,Amp,PDist3);

%Finding Mean, Std, and Kurtosis Trajectories - for randomly sampled distributtions
[Time,StddB1r,MeandB1r,KurtdB1r]=ampstdmean(Time,Amp,PDist1r);
[Time,StddB2r,MeandB2r,KurtdB2r]=ampstdmean(Time,Amp,PDist2r);
[Time,StddB3r,MeandB3r,KurtdB3r]=ampstdmean(Time,Amp,PDist3r);


%Storing Data to Structure
AmpData.PDist1=PDist1;
AmpData.PDist2=PDist2;
AmpData.PDist3=PDist3;
AmpData.StddB1=StddB1;
AmpData.MeandB1=MeandB1;
AmpData.KurtdB1=KurtdB1;
AmpData.StddB2=StddB2;
AmpData.MeandB2=MeandB2;
AmpData.KurtdB2=KurtdB2;
AmpData.StddB3=StddB3;
AmpData.MeandB3=MeandB3;
AmpData.KurtdB3=KurtdB3;
AmpData.PDist1r=PDist1r;
AmpData.PDist2r=PDist2r;
AmpData.PDist3r=PDist3r;
AmpData.StddB1r=StddB1r;
AmpData.MeandB1r=MeandB1r;
AmpData.KurtdB1r=KurtdB1r;
AmpData.StddB2r=StddB2r;
AmpData.MeandB2r=MeandB2r;
AmpData.KurtdB2r=KurtdB2r;
AmpData.StddB3r=StddB3r;
AmpData.MeandB3r=MeandB3r;
AmpData.KurtdB3r=KurtdB3r;
AmpData.Amp=Amp;
AmpData.Time=Time;
AmpData.dT=dT;
AmpData.dN=dN;