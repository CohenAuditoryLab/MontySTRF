%
% function [FTC64] = onlineftc64(TankFileName,BlockNumber,T1,T2,ServerName,Order)
%
%	FILE NAME 	: ONLINE FTC 64
%	DESCRIPTION : Computes Tunning Curve Online and Plots Results
%
%	TankFileName	: Data Tank File Name
%	BlockNumber     : Block Number vector
%   T1              : FTC window start time
%   T2              : FTC window end time
%   ServerName      : Tank Server Name (Default=='Puente')
%   Order           : Channel order for plotting (Optional, Default set to
%                     Polytrode 64 arrangment)
%
%RETURNED DATA
%   FTC             : Frequency Tunning Curve Data Structure for 
%                     all channels
%
% (C) Monty A. Escabi, Feb 2019
%
function [FTC64] = onlineftc64(TankFileName,BlockNumber,T1,T2,ServerName,Order)

%Default Tank Serve
if nargin<5
    ServerName='Puente';
end
if nargin<6
    %Polytrode 64 ordering
    Order=[2 19 14 32 16 20 4 18 12 30 15 22 10 17 9 24 8 23 7 26 6 25 5 28 34 27 3 64 45 29 1 51 46 31 36 50 39 62 47 57 35 49 43 61 48 53 41 52 42 55 37 56 33 59 13 63 11 21 40 58 38 60 44 54];
end

%Averaging Across Blocks
for chan=1:64
    for k=1:length(BlockNumber)
    
    %Reading Tank Data
    [Data] = readtankv66(TankFileName,BlockNumber(k),chan,ServerName);

    %Generating FTC
    [FTCtemp] = ftcgenerate(Data,T1,T2);
            
            if ~exist('FTC','var')
                %Averaging Across Units
                for l=1:length(FTCtemp)
                    FTC(l).data=FTCtemp(l).data;
                    FTC(l).Freq=FTCtemp(l).Freq;
                    FTC(l).Level=FTCtemp(l).Level;
                    FTC(l).NFTC=FTCtemp(l).NFTC;
                    FTC(l).T1=FTCtemp(l).T1;
                    FTC(l).T2=FTCtemp(l).T2;
                end
            else
                for l=1:length(FTCtemp)
                    %Averaging Across Units
                    FTC(l).data=FTC(l).data+FTCtemp(l).data;
                    FTC(l).Freq=FTCtemp(l).Freq;
                    FTC(l).Level=FTCtemp(l).Level;
                    FTC(l).NFTC=FTCtemp(l).NFTC;
                    FTC(l).T1=FTCtemp(l).T1;
                    FTC(l).T2=FTCtemp(l).T2;
                end
            end
    end
    FTC64(chan)=FTC(1);
    clear FTC
end

%Plotting FTC Data
figure
set(gcf,'Position',[1095 46 553 903])
for chan=1:64
    ftcsubplot(FTC64(Order(chan)),[32 2 chan]);
end