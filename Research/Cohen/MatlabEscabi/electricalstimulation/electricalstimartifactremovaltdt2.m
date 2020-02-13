%function [DataArtifact] = electricalstimartifactremoval2(Data,filename,Na,f1,f2,TW)
%
%	FILE NAME 	: ELECTRICAL STIMULATION ARTIFACT REMOVAL
%	DESCRIPTION : Generates a Wiener filter to predict and remove artifact
%                 from a multi-channel stimulation and rec ording session
%
%	Data            : Data Structure containing all relevant data. See READTANKSTIM
%                     for details
%   filename        : File name header containing the directory and
%                     filename header ending in string 'Block'. The block
%                     numbers are added automatically by the program.
%   Na
%   f1              : Lower cutoff frequency (in Hz)
%   f2              : Upper cutoff frequency (in Hz)
%   TW              : Transition width (in Hz)
%   OutChan         : Output channel numbers to use for artifact removal
%
% RETURNED DATA
%
%
% (C) Monty A. Escabi, Edit Dec 2011
%
function [DataArtifact] = electricalstimartifactremoval2(Data,filename,Na,f1,f2,TW)

%Extracting data
X=Data.ContWave;

%Bandpass filter output
NChan=size(X,1);
[Hband] = bandpass(f1,f2,TW,Data.Fs,40,'n');
Nb=(length(Hband)-1)/2;
for l=1:NChan
    XC(l,:)=conv(X(l,:),Hband);
end
X=XC(:,Nb+1:end-Nb);
clear XC

%Selecting data during electrical stimulation
N1=round(Data.ElectricalStimTrig(1)*Data.Fs);
N2=round(Data.ElectricalStimTrig(end)*Data.Fs);
Xa=X(:,N1:N2-1);
clear X

%Loading electrical input
load([filename '000' int2str(1) '.mat'])
M=ParamList.NB/4;   %1/4 of a block, each channel receives input for this duration
Fs = Data.Fs;

%Reorganizing electrical input data and removing pulse waveform
Mask=[-1 -1 1 1]/4; %used to find pulses and replace with delta
for k=1:8
    load([filename '000' int2str(k) '.mat'])
    for l=1:2
       chan=l+(k-1)*2;
       
       N1=(l-1)*M+1;
       N2=(l)*M;
       i=find(conv(Mask,full(S(chan,N1:N2)))==1)-3; %Find time of pulses
       Sa(chan,:)=spet2impulse(i,Fs,Fs,M/Fs)/Fs;    %Replace with delta
    end
end

%Detect edge effects
edge = zeros(16,1);
for k = 1:16
    pulses = find(Sa(k,131050:end));
    if isempty(pulses)
        edge(k,:) = 0;
    else
        edge(k,:) = 1;
    end     
end
Sa=full(Sa);

%Finding Artifact Prediction Filters
dt=1/Data.Fs;
for k=1:16  %input channels
    for l=1:16  %output channels
        [H] = wienerfft(Sa(k,:),Xa(l,:),5,Na);
        Ha(l,k,:)=H;
    end
end

%Predicting the artifact
delay = round(Na/2);
Ynext = zeros(1,delay);
Ya = zeros(size(Xa));
for l=1:16  %output channels
    for k=1:16  %input channels
         Y=conv(squeeze(Ha(l,k,:)),Sa(k,:));
         Ya(l,k,:)=Y(1:length(Y)-Na);
         %Ya(l,k,:)=Y(1:length(Xa(k,:)));
         %Ya(l,k,1:delay) = Ya(l,k,1:delay)+Ynext; %add edge effect from previous channel
         %Ynext = Y(length(Xa(k)):delay);
         %if edge(k) == 1
         %    Ynext = Ynext+Y(length(Xa)+1:length(Xa)+delay);
         %end
    end
end
Ya=squeeze(sum(Ya,2));

%Subtracting the artifacts
for k=1:16
    Xclean(k,:)=Xa(k,:)-Ya(k,:);
end

%Organizing Results Into Data Structure
DataArtifact.X=X;
DataArtifact.Xa=Xa;
DataArtifact.Ya=Ya;
DataArtifact.Xclean=Xclean;
DataArtifact.Sa=Sa;
DataArtifact.Fs=Data.Fs;