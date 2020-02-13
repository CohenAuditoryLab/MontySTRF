%
% function [FTC32] = onlineftc32(TankFileName,BlockNumber,T1,T2,ServerName,Order)
%
%	FILE NAME 	: ONLINE FTC 32
%	DESCRIPTION : Computes Tunning Curve Online and Plots Results
%
%	TankFileName	: Data Tank File Name
%	BlockNumber     : Block Number vector
%   T1              : FTC window start time
%   T2              : FTC window end time
%   ServerName      : Tank Server Name (Default=='Puente')
%   Order           : Channel order for plotting (Optional, Default set to
%                     Polytrode 32 arrangment)
%
%RETURNED DATA
%   FTC32           : Frequency Tunning Curve Data Structure for 
%                     all channels
%
%   (C) Monty A. Escabi, May 2018
%
function [FTC32] = onlineftc32(TankFileName,BlockNumber,T1,T2,ServerName,Order)

%Default Tank Serve
if nargin<5
    ServerName='Puente';
end
if nargin<6
    Order=[21 27 1 15 23 25 3 13 18 32 5 11 20 30 7 9 22 28 24 26 19 29 17 31 2 16 4 14 6 12 8 10];
    %Order=[23 25 20 30 22 28 24 26 3 13 5 11 7 9 4 14 6 12 8 10 21 27 19 29 17 31 18 32 1 15 2 16];
end

%Averaging Across Blocks
for chan=1:32
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
    FTC32(chan)=FTC(1);
    clear FTC
end

%Plotting FTC Data
figure
set(gcf,'Position',[1095 46 553 903])
for chan=1:32
    ftcsubplot(FTC32(Order(chan)),[16 2 chan]);
end