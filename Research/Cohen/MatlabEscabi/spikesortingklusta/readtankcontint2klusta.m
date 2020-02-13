%
%function [] = readtankcontint2klusta(TankFileName,BlockNumber,UF,f1,f2,Thresh,dT,SpikePhase,TBlock,ProbeFile)
%
%	FILE NAME 	: READ TANK CONT INT 2 KLUSTA
%	DESCRIPTION : Reads a specific block from a data tank file and saves
%                 the data to a KLUSTA formated file. The data is interpolated
%                 prior to saving by a factor of UF. Assumes reading of
%                 all channels. The program outputs a binary 'single' file
%                 along wiht a txt file containing header information
%
%   DataTank    : Data tank file name
%   BlockNumber : Block Number
%   UF          :  Upsampling factor (Default==4)
%   f1          : High pass filter cutoff frequency (Default == 300 Hz)
%   f2          : Lowpass filter cutoff frequency (Default == 5000 Hz)
%   Thresh      : Threshold for spike detection. The threshold is expressed
%                 as a vector [T1 T2] where T1 is the number of standard
%                 deviations for a weak threshold and T2 is the number of
%                 standard deviations for a strong threshold. (Optional,
%                 Default == [2 4.5])
%   dT          : Window size in milliseconds seconds for reading spike
%                 waveform snips (Default=2 msec)
%   SpikePhase  : Spike Waveform Phase - either 'possitive' or 'negative'.
%                 (Optional, Default == 'negative')
%   TBlock      : Duration for read block buffer size in seconds (Optional,
%                 Default == 32 sec). The block size will be rounded up so
%                 that each block corresponds to an integer number of
%                 samples at the recording sampling rate.
%   ProbeFile   : File containg information for the recording probe.
%                 Default == 'Linear16.prb'
%
% RETURNED DATA
%
% (C) Monty A. Escabi, February 2017 (Edited Oct 9 2017 with Xiu)
%
function [] = readtankcontint2klusta(TankFileName,BlockNumber,UF,f1,f2,Thresh,dT,SpikePhase,TBlock,ProbeFile)

%Input Args
if nargin<3 | ~exist('UF')
    UF=4;
end
if nargin<4 | ~exist('f1')
    f1=300;
end
if nargin<5 | ~exist('f2')
    f2=5000;
end
if nargin<6 | ~exist('Thresh')
    Tresh=[2 4.5];
end
if nargin<7 | ~exist('dT')
    dT=2;
end
if nargin<8 | ~exist('SpikePhase')
    SpikePhase='negative';
end
if nargin<9 | ~exist('TBlock')
   TBlock=32;                                                       %
end
if nargin<10 | ~exist('ProbeFile')
   ProbeFile='Linear16.prb';
end

%Reading Data Information
Block=['block-' int2str(BlockNumber)];
[data] = TDT2mat(TankFileName,Block,'T1',0,'T2',1);                 %short 1-sec segment
T=data.info.duration;                                               %Recording duaration
[Y, M, D, H, MN, S] = datevec(T);
T=H*3600+MN*60+S;                                                   %Recording duration in seconds
NChan=size(data.streams.sWav.data,1);                               %Number of electrode channels
Fs=data.streams.sWav.fs;                                            %Sampling rate

%Rounding off TBlock so that it consists of a fixed number of samples per
%recording segment. This is necessary so that during interpolation the
%samples line up correctly with the original uninterpolated signal samples
TBlockMin=1/(Fs-floor(Fs));
TBlock=ceil(TBlock/TBlockMin)*TBlockMin;
NBlock=round(TBlock*Fs);                                            %Technically round() is not necessary - however its included in case of roundoff error

%Opening Output Files
fid1=fopen([TankFileName 'Block' num2str(BlockNumber) '.dat'],'wb');
fid2=fopen([TankFileName 'Block' num2str(BlockNumber) '.prm'],'w');

%Reading Data in TBlock second blocks, upsampling, and storing to file
L=floor(T/TBlock);
for k=1:L
    
    %Reading Data Block - 1 extra second at edges to allow for
    %interpolation 
    if k==1
        T1=0;
        T2=(k*NBlock+100-1)/Fs;     %
    else
        T1=((k-1)*NBlock-100)/Fs;   %
        T2=(k*NBlock+100-1)/Fs;     %
    end
    [data] = TDT2mat(TankFileName,Block,'T1',T1,'T2',T2,'Type',4,'Store','sWav');  %Only read the streams
    
    %Interpolating and Removing edge samples
    X=data.streams.sWav.data;
    X=single(resample(double(X'),UF,1)');                           %Resampled signals for all channels
                                                                    %Fixed 10/9/17 Xiu & Escabi - previously the order of resampling and reshaping were incorrect           
    %Removing Edge Samples
    if k==1
        X=X(:,1:end-UF*100);                                         %Removing Edge samples - Fs corresponds to 1 second removed
    else
        X=X(:,UF*100+1:end-UF*100);                                   %Removing Edge samples - Fs correspomds to 1 second removed
    end

    %Rashape multi-channel recording signal to a single vector
    X=reshape(X,1,numel(X));                                         % Fixed order - 10/9/17 - previously reshaped first prior to interpolation 
   
    %Writing Interpolated and Reshaped Data
    fwrite(fid1,X,'single');
end
T1=(k*NBlock-100)/Fs;               %
[data] = TDT2mat(TankFileName,Block,'T1',T1,'T2',0,'Type',4,'Store','sWav');       %Read last incomplete block
X=data.streams.sWav.data;
X=single(resample(double(X'),UF,1)'); 
X=X(:,UF*100+1:end);   
X=reshape(X,1,numel(X));                                               %Removing Edge samples
fwrite(fid1,X,'single');

%Data Parameters
Fs=data.streams.sWav.fs*UF;     %Sampling rate after upsampling

%Saving Parameter File Information
dN=ceil(dT/2/1000*Fs);  %Number of samples for 1/2 of a spike waveform snip (total = 2*dN)
NClust=100;
q=setstr(39);   %Quote
lf=setstr(10);  %Line Feed
t='    ';       %Simple Tab
Header1=['experiment_name = ' q TankFileName 'Block' num2str(BlockNumber) q lf];
Header2=['prb_file = ' q ProbeFile q lf lf];
Header3=['traces = dict(' lf,...
    t 'raw_data_files=' q TankFileName 'Block' num2str(BlockNumber) '.dat' q ',' lf ,...
    t 'voltage_gain=1,' lf,...
    t 'sample_rate=' num2str(Fs,12) ',' lf,...
    t 'n_channels=' int2str(NChan) ',' lf,...
    t 'dtype=' q 'single' q ',' lf,...
    ')' lf lf];
Header4=['spikedetekt = dict(' lf, ...
    t 'filter_low=' num2str(f1,12) ',  # Low pass frequency (Hz)' lf, ...
    t 'filter_high_factor=' num2str(f2/Fs,12) ',' lf, ...
    t 'filter_butter_order=3,  # Order of Butterworth filter.' lf, ...
    lf, ...
    t 'filter_lfp_low=0,  # LFP filter low-pass frequency' lf, ...
    t 'filter_lfp_high=300,  # LFP filter high-pass frequency' lf, ...
    lf, ...
    t 'chunk_size_seconds=1,' lf, ...
    t 'chunk_overlap_seconds=.015,' lf, ...
    lf, ...
    t 'n_excerpts=50,' lf, ...
    t 'excerpt_size_seconds=1,' lf, ...
    t 'threshold_strong_std_factor=' num2str(Tresh(2)) ',' lf, ...
    t ' threshold_weak_std_factor=' num2str(Tresh(1)) ',' lf, ...
    t 'detect_spikes=' q SpikePhase q ','  lf, ...
    lf, ...
    t 'connected_component_join_size=1,' lf, ...
    lf, ...
    t 'extract_s_before=' int2str(dN) ',' lf, ...
    t 'extract_s_after=' int2str(dN) ',' lf, ...
    lf, ...
    t 'n_features_per_channel=3,  # Number of features per channel.' lf, ...
    t 'pca_n_waveforms_max=10000,' lf, ...
')' lf lf];

Header5=['klustakwik2 = dict(' lf,...
        t 'num_starting_clusters=' num2str(NClust) ',' lf,...
')'];

%Writing Parameter File
fwrite(fid2,[Header1 Header2 Header3 Header4 Header5],'char');