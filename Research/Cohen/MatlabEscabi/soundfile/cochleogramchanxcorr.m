%
%function [XCorrData]=cochleogramchanxcorr(CochData,MaxLag,GDelay)
%	
%	FILE NAME 	: COCHLEOGRAM CHAN XCORR
%	DESCRIPTION : Computes the cochleogram channel normalized crosscorrelation.
%
%	CochData : Output data structure from cochleogram.m
%   MaxLag  : Maximum lag for xcorrelation (msec)
%   GDelay  : Remove group delay of filters prior to computing correlation 
%             (Optional, 'y' or 'n': Default=='n')
%
%RETURNED VARIABLES
%   XCorrData   : Data structure containing xcorrelation data
%     .XCorrMap : Crosscorreleation map
%     .faxis    : Frequency Axis
%     .delay    : Crosscorrelation delay in msec
%
% (C) Monty A. Escabi, July 2015
%
function [XCorrData]=cochleogramchanxcorr(CochData,MaxLag,GDelay)

%Input Parameters
if nargin<3
    GDelay='n';
end

%Removing Group Delay if Desired
if strcmp(GDelay,'y')    %Corrected cochleogram is stored in 'data'
    S=CochData.Sc;
else
    S=CochData.S;
end

%Converting MaxLag to sample numbers
Fs=1/(CochData.taxis(2)-CochData.taxis(1));
N=ceil(MaxLag/1000*Fs);

%Computing Across channel crosscorrelation
for k=1:size(S,1)
    for l=1:size(S,1)
        R=xcorr(S(k,:)-mean(S(k,:)),S(l,:)-mean(S(l,:)),N)/sqrt(var(S(k,:))*var(S(l,:)));
        XCorrMap(k,l,:)=R;
    end
end

%Adding to data structure
XCorrData.XCorrMap=XCorrMap;
XCorrData.faxis=CochData.faxis;
XCorrData.delay=(-N:N)/Fs*1000;