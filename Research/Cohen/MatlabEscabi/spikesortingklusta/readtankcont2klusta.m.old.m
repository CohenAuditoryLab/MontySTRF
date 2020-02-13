%
%function [] = readtankcont2klusta(TankFileName,BlockNumber,f1,f2,Thresh,SpikePhase,TBlock,ProbeFile)
%
%	FILE NAME 	: READ TANK CONT 2 KLUSTA
%	DESCRIPTION : Reads a specific block from a data tank file and saves
%                 the data to a KLUSTA formated file. Assumes reading of
%                 all channels. The program outputs a binary 'single' file
%                 along wiht a txt file containing header information
%
%   DataTank    : Data tank file name
%   BlockNumber : Block Number
%   f1          : High pass filter cutoff frequency (Default == 300 Hz)
%   f2          : Lowpass filter cutoff frequency (Default == 5000 Hz)
%   Thresh      : Threshold for spike detection. The threshold is expressed
%                 as a vector [T1 T2] where T1 is the number of standard
%                 deviations for a weak threshold and T2 is the number of
%                 standard deviations for a strong threshold. (Optional,
%                 Default == [2 4.5])
%   SpikePhase  : Spike Waveform Phase - either 'possitive' or 'negative'.
%                 (Optional, Default == 'negative')
%   TBlock      : Duration for read block buffer size in seconds (Optional,
%                 Default == 30 sec)
%   ProbeFile   : File containg information for the recording probe.
%                 Default == 'Linear16.prb'
%
% RETURNED DATA
%
% (C) Monty A. Escabi, February 2017
%
function [] = readtankcont2klusta(TankFileName,BlockNumber,f1,f2,Thresh,SpikePhase,TBlock,ProbeFile)

%Input Args
if nargin<3 | ~exist('f1')
    f1=300;
end
if nargin<4 | ~exist('f2')
    f2=5000;
end
if nargin<5 | ~exist('Thresh')
    Tresh=[2 4.5];
end
if nargin<6 | ~exist('SpikePhase')
    SpikePhase='negative';
end
if nargin<7 | ~exist('TBlock')
   TBlock=30;
end
if nargin<8 | ~exist('ProbeType')
   ProbeFile='Linear16.prb';
end

%Reading Data Information
Block=['block-' int2str(BlockNumber)];
[data] = TDT2mat(TankFileName,Block,'T1',0,'T2',1);  %short 1-sec segment
T=data.info.duration;   %Recording duaration
[Y, M, D, H, MN, S] = datevec(T);
T=H*3600+MN*60+S;       %Recording duration in seconds
NChan=size(data.streams.sWav.data,1);   %Number of electrode channels

%Opening Output Files
fid1=fopen([TankFileName 'Block' num2str(BlockNumber) '.dat'],'wb');
fid2=fopen([TankFileName 'Block' num2str(BlockNumber) '.prm'],'w');

%Reading Data in 30 second blocks
L=floor(T/TBlock);
for k=1:L
   [data] = TDT2mat(TankFileName,Block,'T1',(k-1)*TBlock,'T2',k*TBlock,'Type',4);  %Only read the streams
   X=reshape(data.streams.sWav.data,1,numel(data.streams.sWav.data));
   fwrite(fid1,X,'single');
end
[data] = TDT2mat(TankFileName,Block,'T1',k*TBlock,'T2',T,'Type',4);      %Read last incomplete block
X=reshape(data.streams.sWav.data,1,numel(data.streams.sWav.data));
fwrite(fid1,X,'single');

%Data Parameters
Fs=data.streams.sWav.fs;

%Saving Parameter File Information
NClust=100;
q=setstr(39);   %Quote
lf=setstr(10);  %Line Feed
t='    ';       %Simple Tab
Header1=['experiment_name = ' q TankFileName 'Block' num2str(BlockNumber) q lf];
Header2=['prb_file = ' q ProbeFile q lf lf];
Header3=['traces = dict(' lf,...
    t 'raw_data_files=' q TankFileName 'Block' num2str(BlockNumber) '.dat' q ',' lf ,...
    t 'voltage_gain=1,' lf,...
    t 'sample_rate=' num2str(Fs) ',' lf,...
    t 'n_channels=' int2str(NChan) ',' lf,...
    t 'dtype=' q 'single' q ',' lf,...
    ')' lf lf];
Header4=['spikedetekt = dict(' lf, ...
    t 'filter_low=' num2str(f1) ',  # Low pass frequency (Hz)' lf, ...
    t 'filter_high_factor=' num2str(f2/Fs) ',' lf, ...
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
    t 'extract_s_before=16,' lf, ...
    t 'extract_s_after=16,' lf, ...
    lf, ...
    t 'n_features_per_channel=3,  # Number of features per channel.' lf, ...
    t 'pca_n_waveforms_max=10000,' lf, ...
')' lf lf];

Header5=['klustakwik2 = dict(' lf,...
        t 'num_starting_clusters=' num2str(NClust) ',' lf,...
')'];

%Writing Parameter File
fwrite(fid2,[Header1 Header2 Header3 Header4 Header5],'char');