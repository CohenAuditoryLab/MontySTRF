%
% function []=cochleogramdynspecbatch(SoundExcelSheetHeader,N,dT,OFc,ATTc)
%
%	FILE NAME 	  : COCHLEOGRAM DYN SPEC BATCH
%	DESCRIPTION   : Computes short-term spectrum of sounds specified 
%                   in the Excel sheet. It receives the list of sounds from 
%                   SoundExcelSheetHeader.
% 
%   SoundExcelSheetHeader : Sound Excel Sheet Header
%   N        : Number of different sound categories
%   dT       : Temporal Window Resolution (sec) - defined according to
%              uncertainty principle so that dT = 2 * std(Wt) where Wt is a
%              temporal Kaiser Window
%   OFc      : Oversampling Factor for spectrum calculation
%   ATTc     : Attenuation / Sidelobe error for temporal window used to compute 
%             dynamic spectrum (Optional, Default == 40dB)
%
% (C) Mina, Oct 2018

function []=cochleogramdynspecbatch(SoundExcelSheetHeader,N,dT,OFc,ATTc)

%Input Parameters
if nargin<5
	ATTc=40;
end
for k=1:N
    %Reading Sound Excel Sheet
    [~,TXT,~]= xlsread(SoundExcelSheetHeader,['Category' int2str(k)]);
    CatName=cell2mat(TXT(3,2));
    mkdir(CatName);
    
    for n=4:size(TXT,1)
       
       OutFileHeader=['Sound' int2strconvert(n-3,3)];
       %Loads previously generated cochleograms
       load(['/Users/mina/Desktop/CorrSpectral/CorrSpectral141/' CatName '/' OutFileHeader '_AGram'])
       count=1;
       
       for counter=1:LB
           %Generating Window
            Fsa=1/(CochData1.taxis(2)-CochData1.taxis(1));
            [Beta,dN] = fdesignkdt(ATTc,dT,Fsa);    %Fix ATT = 40 dB; Use Kaiser window to select data in time; dN is the window size to compute dynamic spectrum
            W=kaiser(dN,Beta)';                    % Temporal Kaiser Window

            %Take square root of window
            W=sqrt(W);
            %Window Length
            L=(length(W)-1)/2;

            %Find window bandwidth and determine step size to achieve desired
            %oversampling factor
            NFFT=2^(nextpow2(2*L+1)+4);
            [~,~,~,dF3dB]=finddtdfw(W,Fsa,NFFT);
            Fst=OFc*4*dF3dB;         %Note that dF3dB/2 is the actual cutoff frequency. Choose 4*dF3dB (four times as much) to be conservative.
            Nstep=floor(Fsa/Fst);    %Floor to make sure step size is integer value
            Fst=Fsa/Nstep;           %This is the actual sampling rate after the floor() operation

            %Blocking the data and taking the average over time
            for m=2*L+1:Nstep:length(CochData1.S)-2*L       %Estimating short-term spectrum for different time points - remove N points at edges to avoid edge effects

                %Selecting and Windowing data
                eval([ 'Xt=CochData' int2str(counter) '.S(:,m-L:m+L).*repmat(W.^2,size(CochData1.S,1),1);'])

                DynSpectrum(count,:) = mean(Xt,2);

                %Iteration Counter
                count=count+1;    
            end
       end
        
       %Saving Dynamic Spectrums
       save ([CatName '/' OutFileHeader '_DynSpec'],'DynSpectrum');
    end
end