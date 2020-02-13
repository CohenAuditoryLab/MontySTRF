%
%function [Data]=kwik2mat(fileheader,NSnips,T)
%
%	FILE NAME 	: READ TANK CONT INT 2 KLUSTA
%	DESCRIPTION : Reads a specific block from a data tank file and saves
%                 the data to a KLUSTA formated file. The data is interpolated
%                 prior to saving by a factor of UF. Assumes reading of
%                 all channels. The program outputs a binary 'single' file
%                 along wiht a txt file containing header information
%
%   fileheader  : Filename header 
%   NSnips      : Number of Snips to select randomly (Optional, Default==1000)
%   T           : Amount of time to select before and after spike for
%                 Snips (msec). The total Snip duration is 2*T. 
%                 (Optional, Default==1.5 msec)
%
% RETURNED DATA
%
%   Data        : Structure containing
%
%       .Cluster            - Structured Array containing Cluster data
%       .Cluster(k).Number  - Cluster number
%       .Cluster(k).spet    - Spike event time array (in sample number)
%       .Cluster(k).Snips   - Contains sample Snips
%       .Cluster(k).Stats   - Cluster statistics from Snips
%           .PP             - Snip Peak-to-Peak value array (for all chnanels)
%           .SnipAve        - Average Snip for each channel
%           .SNR            - Signal-to-noise (power, all channels)
%           .SIArray        - Similarity Index array computed for entire
%                             array at once
%           .SI             - Silarity indexz array (each channel separately)
%       .Features           - Feature vector
%       .Masks              - Mask Vector
%       .Param              - Parameters
%           .Fs
%           .NChan          - Number of channels
%           .Filter.f1      - Filter lower cutoff
%           .Filter.f2      - Filter upper cutoff
%           .Filter.LFP_f1  - Local field potential lower cutoff
%           .Filter.LFP_f2  - Local field potential upper cutoff
%           .Filter.Order   - Butterworth filter order
%           .Graph          - Electrode Graph
%           .ChanOrder      - Electrode Channel Order
%           .Treshold       - Threshold ([weak strong])
%           .DetectSpikes   - Detection procedure (negative or possitive)
%       .ClusterStats
%           .CovInd         - Normalized Covariance Matrix (correlation
%                             coefficients) - compares the average Snips
%                             (across all channels) of a cluster with the 
%                             individual snips of a second cluster.
%                             Dimension 1 corresponds to the average snips
%                             (i.e., the reference) and dimension 2 to the 
%                             individual snips
%           .CovAve         - Normalized Covariance Matrix (correlation
%                             coefficients) - Compares the average Snips
%                             (across all channels) between two clusters
%
% (C) Monty A. Escabi, May 2017 (Jul 5, 2018)
%
function [Data]=kwik2mat(fileheader,NSnips,T)

%Input Args
if nargin<2 | isempty(NSnips)
    NSnips=1000;
end
if nargin<3 | isempty(T)
    T=1.5;
end

%Reading SPET and Cluster Data
Spet=hdf5read([fileheader '.kwik'], '/channel_groups/0/spikes/time_samples');
Clusters=hdf5read([fileheader '.kwik'], '/channel_groups/0/spikes/clusters/main');
NClus=max(Clusters)+1;
for k=1:NClus

    %Reading and Storing Cluster Data
    i=find(Clusters==k-1);
    Data.Cluster(k).Number=k-1;
    Data.Cluster(k).spet=Spet(i);
    Data.Cluster(k).Snips=[];
    Data.Cluster(k).Stats=[];
    
end

%Reading Features
FeaturesMasks=hdf5read([fileheader '.kwx'],'/channel_groups/0/features_masks');
Data.Features = squeeze(FeaturesMasks(1,:,:));
Data.Masks = squeeze(FeaturesMasks(1,1:3:end,:)); %should it be 2????    

%Reading Data Parameters
Data.Param.Fs=hdf5read([fileheader '.kwik'],'/application_data/spikedetekt','sample_rate');
Data.Param.NChan=hdf5read([fileheader '.kwik'],'/application_data/spikedetekt','n_channels');
Data.Param.Filter.f1=double(hdf5read([fileheader '.kwik'],'/application_data/spikedetekt','filter_low'));
Data.Param.Filter.f2=double(Data.Param.Fs*hdf5read([fileheader '.kwik'],'/application_data/spikedetekt','filter_high_factor'));
Data.Param.Filter.LFP_f1=double(Data.Param.Fs*hdf5read([fileheader '.kwik'],'/application_data/spikedetekt','filter_lfp_low'));
Data.Param.Filter.LFP_f2=double(Data.Param.Fs*hdf5read([fileheader '.kwik'],'/application_data/spikedetekt','filter_lfp_high'));
Data.Param.Filter.Order=hdf5read([fileheader '.kwik'],'/application_data/spikedetekt','filter_butter_order');
Data.Param.Graph=hdf5read([fileheader '.kwik'],'/channel_groups/0','adjacency_graph');
Data.Param.ChanOrder=hdf5read([fileheader '.kwik'],'/channel_groups/0','channel_order');
Data.Param.Treshold.strong_std=hdf5read([fileheader '.kwik'],'/application_data/spikedetekt','threshold_strong_std_factor');
Data.Param.Treshold.weak_std=hdf5read([fileheader '.kwik'],'/application_data/spikedetekt','threshold_weak_std_factor');
DetectSpikes=hdf5read([fileheader '.kwik'],'/application_data/spikedetekt','detect_spikes');
Data.Param.DetectSpikes=DetectSpikes.Data;

%Generating Butterworth Filter
Fs=Data.Param.Fs;
f1=Data.Param.Filter.f1;
NB=uint64(Data.Param.Filter.Order);
NF=uint64(ceil(0.020*Fs));  %Number of extra samples to etract to account for filter edge artifact
if isfield(Data.Param.Filter,'f2')
    f2=Data.Param.Filter.f2;
    Wn=[f1 f2]/(Fs/2);
    [B,A]=butter(NB,Wn);
else
    Wn=f1/(Fs/2);
    [B,A]=butter(NB,Wn,'high');
end

%Reading and storing spike Snips
NWave=uint64(ceil(T/1000*Data.Param.Fs));
NChan=uint64(Data.Param.NChan);
fid=fopen([fileheader '.dat'],'r');
for n=1:NClus
    
    %Finding random sample spike times
    spet=Data.Cluster(n).spet;
    i=find(spet>2*NF+NB & spet<max(Spet)-2*NF-NB);      %Make sure selected spike window is in bounds of data
    spet=spet(i);
    if length(i)>NSnips                                 %If there are more spets than NSnips; otherwise keep all
        i=randsample(length(i),NSnips);
        spet=spet(i);  
    end
    
    %Reading Sample Snips from Data File
    for k=1:length(spet)

            %Seeking Spike Times and Extracting Snip Data
            fseek(fid,(spet(k)-NWave-NF)*NChan*4,-1);
            X=reshape(fread(fid,(NWave+NF)*2*NChan,'single'),NChan,(NWave+NF)*2);
            
            %Filtering Snips and Truncating
            X=filter(B,A,X')';
            Snips(k,:,:)=X(:,NF+1:NF+1+2*NWave)';

    end
    
    %Saving Snips for each Cluster
    Data.Cluster(n).Snips=Snips;
end

%Computing Cluster Statistics
for k=1:NClus
    
    %Amplitude Statistics
    Snips=Data.Cluster(k).Snips;
    Data.Cluster(k).Stats.PP=max(squeeze(mean(Snips(:,:,:),1)))-min(squeeze(mean(Snips(:,:,:),1)));   %Average peak-to-peak valeu from each electrode
    Data.Cluster(k).Stats.SnipAve=squeeze(mean(squeeze(Snips(:,:,:)),1));    %Average Snips for each channel
    
    %Signal-to-Noise Ratio
    PS=sum(Data.Cluster(k).Stats.SnipAve.^2);   %Signal Power for each channel
    PN=0;
    for l=1:size(Data.Cluster(k).Snips,1)       %Noise Power for each channel
        PN=PN+sum((Data.Cluster(k).Stats.SnipAve-squeeze(Data.Cluster(k).Snips(l,:,:))).^2)/size(Data.Cluster(k).Snips,1);
    end
    Data.Cluster(k).Stats.SNR=PS./PN;
    
    %Snip & Array Similarity Index
    X1=reshape(Data.Cluster(k).Stats.SnipAve,1,numel(Data.Cluster(k).Stats.SnipAve));
    for n=1:size(Snips,1)
        X2=reshape(squeeze(Snips(n,:,:)),1,numel(squeeze(Snips(n,:,:))));
        R=corrcoef(X1,X2);
        SIArray(n)=R(1,2);  %SI Considering all Snips across entire array
        
        %Finding SI for each channel
        for l=1:NChan
            R=corrcoef(squeeze(Data.Cluster(k).Stats.SnipAve(:,l)),squeeze(Data.Cluster(k).Snips(n,:,l)));
            SI(l,n)=R(1,2);
        end
    end
    Data.Cluster(k).Stats.SIArray=SIArray;          %Simiularity index for the Snips across the entire Array
    Data.Cluster(k).Stats.SI=mean(SI,2);            %Average Similarity Index between each Snip and the Average
end

%Comparing Clusters -   compares individual cluster snips to avearge cluster snip
for k=1:NClus           %Average Snip from k-th Cluster - Reference
    for l=1:NClus       %Snips for l-th Cluster 

        X1=reshape(Data.Cluster(k).Stats.SnipAve,1,numel(Data.Cluster(k).Stats.SnipAve));
        for n=1:size(Data.Cluster(l).Snips,1)
            X2=reshape(squeeze(Data.Cluster(l).Snips(n,:,:)),1,numel(squeeze(Data.Cluster(l).Snips(n,:,:))));
            R=corrcoef(X1,X2);
            RR(n)=R(1,2);
        end
        Data.ClusterStats.CovInd(k,l)=mean(RR);  %Comparison between Snips from l-th cluster and avearge Snip from k-th cluster
        
    end
end

%Comparing Clusters - compares average cluster snips
for k=1:NClus
    for l=1:NClus

        X1=reshape(Data.Cluster(k).Stats.SnipAve,1,numel(Data.Cluster(k).Stats.SnipAve));
        X2=reshape(Data.Cluster(l).Stats.SnipAve,1,numel(Data.Cluster(l).Stats.SnipAve));
        R=corrcoef(X1,X2);
        Data.ClusterStats.CovAve(k,l)=R(1,2);
        
    end
end