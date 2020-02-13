%
%function [F,P]=ModAlpha1Gabor(beta,axis)
%
%       FILE NAME       : Modulation filter bank using alpha fxn 1 model
%                         and gabor model
%
%       DESCRIPTION     : Generate filter banks for modulation
%                         Temporal axis using alpha fxn 1 model 
%                         Spectral axis using gabor model
%
%       beta            : Parameter vector
%                         beta(1): Qt quality factor for temporal
%                         beta(2): Qs quality factor for spectral
%                         beta(3): Fml temporal lower CF
%                         beta(4): Fmu temporal upper CF 
%                         beta(5): RDl spectral lower CF (ripple density)
%                         beta(6): RDu spectral upper CF (ripple density)
%                         beta(7): Dt temporal resolution (octave)
%                         beta(8): Ds spectral resolution (octave)
%                         
%       axis.taxis      : Time axis (msec)
%       axis.X          : Octave frequency axis (octaves)
%
%
%OUTPUT SIGNAL
%
%       F               : Returned filter bank (time domain)
%                         F(i,j).H = filter 
%                         F(i,j).taxis = axis.taxis;
%                         F(i,j).Xaxis = axis.X;
%                         F(i,j).Delay = Delay;
%                         F(i,j).Fm = Fm(i);
%                         F(i,j).BWt = Tb(i);
%                         F(i,j).Tphase = Tphase;
%                         F(i,j).RD = RD(j);
%                         F(i,j).BWs = Sb(j);
%                         F(i,j).Sphase = Sphase;
%                         F(i,j).Amp = Amp;  
%       P               : Parameters 
%                         Qt = beta(1);
%                         Qs = beta(2);
%                         Fml = beta(3);
%                         Fmu = beta(4);
%                         RDl = beta(5);
%                         RDu = beta(6);
%                         Dt = beta(7);
%                         Ds = beta(8);
% %Feb. 2018
%

function [FW,P]=ModAlpha1Gabor(beta,axis)

%Parameters
Qt = beta(1);
Qs = beta(2);
Fml = beta(3);
Fmu = beta(4);
RDl = beta(5);
RDu = beta(6);
Dt = beta(7);
Ds = beta(8);



%Generate character frequency sequence
T1=0;
TN=log2(Fmu/Fml);
L=floor(TN/Dt);
Tc=(.5:L-.5)/L*TN;
Fm=Fml*2.^Tc;

% here are some problems, I didn't check the CF generation last time, and
% seems it has some problems:
% The code upside should be: 

% TN=log2(Fmu/Fml);
% L=floor(TN/Dt);
% Tc=(0:L-1)*Dt;
% Fm=Fml*2.^Tc;

S1=0;
SN=log2(RDu/RDl);
L=floor(SN/Ds);
Sc=(.5:L-.5)/L*SN;
RD=RDl*2.^Sc;

% as for temporal the spectral should be:
% SN=log2(RDu/RDl);
% L=floor(SN/Ds);
% Sc=(0:L-1)*Ds;
% RD=RDl*2.^Sc;


%Generate related parameters
    Delay = 0;
    %Fm = Fm;
    Tb = Fm./Qt; %temporal bandwidth (Hz)
    Tphase = pi/4;
    
    Bof = 0;
    Sb = RD./Qs; %spectral bandwidth (cycyles/octive Hz)
    %RD = RD; 
    Sphase = 0;
    Amp = 1;
    
%Generate filters
nt = length(Fm);
ns = length(RD);

%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%
%Generate constant frequency (DC) filters
FDCT(nt).H = zeros(size(axis));
    SbDC = Sb(1)-RD(1)/2;
    RDDC = 0;
FDCS(ns).H = zeros(size(axis));
    FmDC = 0;
    TbDC = Fm(1)-Tb(1)/2;
FDC.H = strfgaboralpha1model([Delay FmDC TbDC Tphase Bof SbDC RDDC Sphase Amp],axis);
    FDC.taxis = axis.taxis;
    FDC.Xaxis = axis.X;
    FDC.Delay = Delay;
    FDC.Fm = FmDC;
    FDC.BWt = TbDC;
    FDC.Tphase = Tphase;
    FDC.RD = RDDC;
    FDC.BWs = SbDC;
    FDC.Sphase = Sphase;
    FDC.Amp = Amp;

for i = 1:nt
    FDCT(i).H = strfgaboralpha1model([Delay Fm(i) Tb(i) Tphase Bof SbDC RDDC Sphase Amp],axis);
    FDCT(i).taxis = axis.taxis;
    FDCT(i).Xaxis = axis.X;
    FDCT(i).Delay = Delay;
    FDCT(i).Fm = Fm(i);
    FDCT(i).BWt = Tb(i);
    FDCT(i).Tphase = Tphase;
    FDCT(i).RD = RDDC;
    FDCT(i).BWs = SbDC;
    FDCT(i).Sphase = Sphase;
    FDCT(i).Amp = Amp;
end
for j = 1:ns
    FDCS(j).H = strfgaboralpha1model([Delay FmDC TbDC Tphase Bof Sb(j) RD(j) Sphase Amp],axis);
    FDCS(j).taxis = axis.taxis;
    FDCS(j).Xaxis = axis.X;
    FDCS(j).Delay = Delay;
    FDCS(j).Fm = FmDC;
    FDCS(j).BWt = TbDC;
    FDCS(j).Tphase = Tphase;
    FDCS(j).RD = RD(j);
    FDCS(j).BWs = Sb(j);
    FDCS(j).Sphase = Sphase;
    FDCS(j).Amp = Amp;
end


%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%
%Generate other filters
F(nt,ns).H = zeros(size(axis));

for i = 1:nt
    for j = 1:ns
        F(i,j).H = strfgaboralpha1model([Delay Fm(i) Tb(i) Tphase Bof Sb(j) RD(j) Sphase Amp],axis);
        F(i,j).taxis = axis.taxis;
        F(i,j).Xaxis = axis.X;
        F(i,j).Delay = Delay;
        F(i,j).Fm = Fm(i);
        F(i,j).BWt = Tb(i);
        F(i,j).Tphase = Tphase;
        F(i,j).RD = RD(j);
        F(i,j).BWs = Sb(j);
        F(i,j).Sphase = Sphase;
        F(i,j).Amp = Amp;      
    end
end

% nf = length(Fm)*length(RD); % number of filters
% strfbeta = zeros(nf,9);
% for i = 1:length(Fm)
%     strfbeta(length(RD)*(i-1)+1:length(RD)*i,:) = [Delay*ones(length(RD),1),...
%                 Fm(i)*ones(length(RD),1),...
%                 Tb(i)*ones(length(RD),1),...
%                 Tphase*ones(length(RD),1),...
%                 Fm(i)*ones(length(RD),1),...
%                 Sb',...
%                 RD',...
%                 Sphase*ones(length(RD),1),...
%                 Amp*ones(length(RD),1)];
% end
% 
% 
% F.H = zeros(nf,length(axis.X),length(axis.taxis));
% for i = 1:nf
%     F.H(i,:,:) = strfgaboralpha1model(strfbeta(i,:),axis);
% end
 
%Store related parameters
% F.strfbeta = strfbeta;
% F.beta = beta;
P.Qt = beta(1);
P.Qs = beta(2);
P.Fml = beta(3);
P.Fmu = beta(4);
P.RDl = beta(5);
P.RDu = beta(6);
P.Dt = beta(7);
P.Ds = beta(8);
FW = [FDC ,FDCS;
      FDCT',F];
  
  
%% image filter banks
% 
% close all
% a = length(Fm);
% b = length(RD);
% for k=1:a
% for l=1:b
% subplot(a,b,l+(k-1)*b)
% imagesc(axis.taxis,axis.X,F(k,l).H);
% set(gca,'Ydir','Normal');
% end
% end
% 
% % image frequency filters (fft)
% imagesc((-2560:2559)/1024/5/(axis.taxis(2)-axis.taxis(1))*1000,(-512:511)/1024/(axis.X(2)-axis.X(1)),abs(fftshift(fft2(F(10).H,1024*5,1024))))
% 
% % generate axis
%  taxis=[0:1:200];
%  X = 0:0.01:0.3;
%  axis.taxis = taxis;
%  axis.X = X;