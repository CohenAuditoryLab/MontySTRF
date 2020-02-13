% Main program for 1/f paper  
% 1- Extract all Envelopes
% 2- Extract call segements, extract envelope parameters, generate simulated model
% 3- Compute Power Spectra for all models
% (C) Fatemeh Khatami, Feb. 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
load InitialParameters
load Noise
load Data
fmseg=fm;   %Maximum modulation frequency used during segmentation

%Exract all the envelopes
[DataEnvSeg]=envelopeblocked(Data.X,f1,f2,fm,Data.Fs,dSFactor,FiltType,M,N,wt,z);          % Extract Envelop for segmentation
fm1=500;[DataEnv500]=envelopeblocked(Data.X,f1,f2,fm1,Data.Fs,dSFactor,FiltType,M,N,wt,z); % Extract Envelop for fm=500

%Extract call segements, extract envelope parameters, generate simulated model
ENoise=DataEnvSeg.Enorm(x(1):x(2));
[Emodel1,Emodel1norm,Emodel2,Emodel2norm,DataSeg,Callparameters]= Emodel(DataEnvSeg,dt,ENoise);

%Compute Power Spectra
Pxx500=PowerSpec(DataEnv500.Enorm,Fs,dSFactor); % power Spectra for Fm=500
PxxModel1=PowerSpec(Emodel1norm,Fs,dSFactor);   % power Spectra for Model1, Fm=fmseg   
PxxModel2=PowerSpec(Emodel2norm,Fs,dSFactor);   % power Spectra for Model2, Fm=fmseg
PxxModelTheo=TheoPower(Callparameters,Emodel2); % power Spectra for theoretical model

%Saving Envelope Data / Model to File
% save Rat_analyzedData -v7.3

%% plot 1/f pattern for above models
figure;semilogx(PxxModel2.f,((PxxModel2.P)),'r'); xlim([0.05 500])
hold on
semilogx(Pxx500.f,((Pxx500.P)),'b');
semilogx(PxxModelTheo.f,(PxxModelTheo.P),'--g'); xlim([0.05 500])
set(gca,'fontsize',12);
axis square;box off



