%
%function [CorrWinData]=rastermuashuffledxcorrwinfast(RAS1,RAS2,Fsd,T0,Tw,MaxTau,Mean,Diag,DiagVar)
%
%   FILE NAME       : RASTER MUA SHUFFLED XCORR WIN FAST
%   DESCRIPTION     : Windowed shuffled crosscorrelogram using raster data 
%                     of MUA. The correlation is computed only for a
%                     windowed segment of the Raster. The window is
%                     centered at position T0 and has a duration Tw. For
%                     simplicity we are using a square window.
%
%	RAS1            : Rastergram 1 (NTrials x SamplePoints, pre-loaded using "LOADMUARAS")
%   RAS2            : Rastergram 2 (NTrials x SamplePoints, pre-loaded using "LOADMUARAS")
%   Fsd             : Sampling rate of raster to compute raster-corr (Hz, pre-loaded using "LOADMUARAS"). 
%   T0              : Window center time point (msec).
%   Tw              : Window duration in msec. For the winow correlation to
%                     work it is required that the window not overlap the
%                     delay region at the edges (to avoid edge artifacts).
%                     This explicitly requires that
%
%                       T0+TW/2 < T - MaxLag
%                       T0-TW/2 > MaxLag
%
%                     where T is the total raster duration.
%
%   MaxTau          : Max delay (msec)
%   Mean            : Remove mean - 'y' or 'n' (Default=='y')
%   Diag            : Remove diagonal correlations from shuffled correlograms - 'y' or 'n'
%                     (Default=='y'). This option is used if one wants to
%                     compute the correlation between trials (within trials
%                     are removed), and noise correlations.
%   DiagVar         : Remove diagonal correlations for variance estimator 
%                     - 'y' or 'n'  (Default=='n'). This option is used if 
%                     one wants to compute the correlation between trials 
%                     (within trials are removed) when estimating the
%                     response variances. This is done in order to isolate
%                     the signal correlations only (noise correlations
%                     removed).
%
% RETURNED VALUES
%
%   CorrWinData     : Data structure containing the following elements
%
%                     .R12_sh       - Average shuffled crosscorrelogram
%                     .R12_ush      - Average unshuffled (auto) correlogram
%                     .R12_noise    - Noise correlation
%                     .Var1_sh      - Shuffled variance (mostly signal variance) for RAS1
%                     .Var2_sh      - Shuffled variance (mostly signal variance) for RAS2
%                     .M1_sh        - Mean of RAS1
%                     .M2_sh        - Mean of RAS2
%                     .Var1_ush     - Diagonal variance (signal and noise variance) for RAS1
%                     .Var2_ush     - Diagonal variance (signal and noise variance) for RAS2
%                     .M1_ush       - Diagonal mean of RAS1
%                     .M2_ush       - Diagonal mean of RAS2
%                     .E21          - Second moment of PSTH1 for RAS1
%                     .E22          - Second moment of PSTH2 for RAS2
%                     .Tau          - Correlation delay axis (msec)
%                     .Param.Fs     - Raster sampling rate (Hz)
%                     .Param.T0     - See input parameter
%                     .Param.Tw     - See input parameter
%                     .Param.MaxTau - See input parameter
%                     .Param.Mean   - See input parameter
%                     .Param.Diag   - See input parameter
%                     .Param.DiagVar- See input parameter
%
% (C) Xiu Zhai & Monty Escabi, Jan 2018 (Edited on Aug 2018 for single trial analysis)
%
function [CorrWinData]=rastermuashuffledxcorrwinfast(RAS1,RAS2,Fsd,T0,Tw,MaxTau,Mean,Diag,DiagVar)

%Input Arguments
if nargin<7 | isempty(Mean)
    Mean='y';
end
if nargin<8 | isempty(Diag)
    Diag='y';
end
if nargin<9 | isempty(DiagVar)
    DiagVar='n';
end

%Some parameters
NT1=size(RAS1,1);                           %Number of trials for RAS1
NT2=size(RAS2,1);                           %Nunber of trials for RAS2
MaxLag=ceil(MaxTau/1000*Fsd);
N0=round(T0/1000*Fsd);                      %Sample location of window
Nw=floor(Fsd*Tw/1000/2)*2+1;                %Floor and make sure that there are an odd number of samples for centering
Nw2=(Nw-1)/2;                               %1/2 window size

%Genearting Square Window amd Selecting Data about T0
N1=N0-ceil(Nw/2)-MaxLag;
N2=N0+ceil(Nw/2)+MaxLag;
RAS1=RAS1(:,N1:N2);
RAS2=RAS2(:,N1:N2);
W=zeros(1,size(RAS1,2));
Ncenter=(length(W)-1)/2+1;
W(Ncenter-Nw2:Ncenter+Nw2)=ones(1,Nw);
WW=repmat(W,NT1,1);
RAS1=RAS1.*WW;                              %Windowed Rastergram 1 - this is the stationary Raster

%Computing Shuffled Correlation - Using PSTH approach for fast Shuffled
%Corr (Zheng & Escabi 2008)
PSTH1=sum(RAS1,1);                      %PSTH1, for windowed data    
PSTH2=sum(RAS2,1);                      %PSTH2, for unwindowed data
R12=xcorr(PSTH1,PSTH2,MaxLag);

%Removing Diagonal if desired - for shuffled correlation (Zheng & Escabi 2008)
%This operation removes within trial correlations but preserves all the 
%across trial correlations. Once removed, the correlogram is effectively a
%shuffled correlogram across trials. Removing the diagonal term effectively r
%emoves the noise correaltion but preserves the signal correlations. If one
%does not remove the diagonal terms, then a fraction of the signal
%correlations are embeded in the correlation calculation.
Rdiag=[];
if strcmp(Diag,'y')
    
    for k=1:NT1
        Rdiag=[Rdiag; xcorr(RAS1(k,:),RAS2(k,:),MaxLag)];
     end
    Rdiag=sum(Rdiag,1);
    R12=R12-Rdiag;                              %Subtracting diagonal terms
    R12noise=Rdiag/NT1/Nw-R12/NT1/(NT1-1)/Nw;   %Noise correlations
    R12=R12/NT1/(NT1-1)/Nw;                     %Normalizing by number of trials - diagonal removed

    R12diag=Rdiag/NT1/Nw;                       %Normalizing Rdiag for single trial analysis
else
    R12=R12/NT1^2/Nw;                           %Normalzing by number of trials
end

%Variance calculation - used to normalize as correlation coefficient
%We employ the same approach used for the fast shuffled correaltion where 
%we remove the diagonal terms. This assures that the diagonal terms (same
%response trials) dont contribute to the variance calculation in the
%shuffled case. Removing the diagonal term effectively removes the noise 
%correaltion but preserves the signal correlation. For the non-shuffled 
%(Diag=='n'), the diagonal terms are not removed.
M=length(PSTH1);
M1=sum(PSTH1)/Nw;
E21=(PSTH1*PSTH1')/(Nw-1);
E21diag=sum(sum(RAS1.^2))/(Nw-1);                   %Used for noise correlation variance
M2=xcorr(W,PSTH2,MaxLag)/Nw;                        %First Moment of PSTH2 - delay depdendent 
E22=xcorr(W.^2,PSTH2.^2,MaxLag)/(Nw-1);             %Second Moment of PSTH2 - delay dependent 
for k=1:NT1
    E22diag(k,:)=xcorr(W.^2,RAS2(k,:).^2,MaxLag)/(Nw-1);     %Used for noise corr - Second Moment of PSTH2 - delay dependent 
end
E22diag=sum(E22diag,1);

for k=1:NT1                                         %Mean of diagonal terms
    M1diag(k,:)=sum(RAS1(k,:))/Nw;
    M2diag(k,:)=xcorr(W,RAS2(k,:),MaxLag)/Nw;
end
M1diag=sum(M1diag,1);
M2diag=sum(M2diag,1);

%Computing Diagonal terms to remove for the variance calculation
if strcmp(DiagVar,'y')                                 %Shuffled variance calculation - requires removal of diagonal terms
    M2Diag1=0;
    MDiag1=0;
    VarDiag1=0;
    E2Diag1=0;
    M2Diag2=zeros(size(E22));
    MDiag2=zeros(size(E22));
    VarDiag2=zeros(size(E22));
    E2Diag2=zeros(size(E22));
    for k=1:NT1
         M2Diag1 = M2Diag1 + (sum(RAS1(k,:))).^2/Nw/(Nw-1);                 %Mean squared diagonals for RAS1
         M2Diag2 = M2Diag2 + (xcorr(W,RAS2(k,:),MaxLag)).^2/Nw/(Nw-1);      %Mean squared diagonals for RAS2 - delay depdendent 
         E2Diag1 = E2Diag1 + RAS1(k,:)*RAS1(k,:)'/(Nw-1);                   %Diagonal terms for RAS1
         E2Diag2 = E2Diag2 + xcorr(W.^2,RAS2(k,:).^2,MaxLag)/(Nw-1);        %Diagonal terms for RAS2, delay dependent
    end
    Var1 = E21 - M1.^2 - (E2Diag1 - M2Diag1);
    Var2 = E22 - M2.^2 - (E2Diag2 - M2Diag2);
    
    Var1 = Var1/NT1/(NT1-1);                  %Normalizing by number of trials - diagonal removed
    Var2 = Var2/NT1/(NT1-1);                  %Normalizing by number of trials - diagonal removed
    E21  = E21/NT1/(NT1-1); 
    E22  = E22/NT1/(NT1-1);
    M1=M1/NT1;
    M2=M2/NT1;
else
    Var1= (E21-M1^2)/NT1^2;                     %Normalizing by number of trials - variance from diagonal and nondiagonal terms - nondiagonal contribute most (N*(N-1) versus N)
    Var1diag= (E21diag*NT1-M1^2)/NT1^2;         %Normalizing by number of trials - variance of diagonal terms - contains both singal and noise correlations for a given trial
    Var2= (E22-M2.^2)/NT1^2;                    %Normalizing by number of trials - variance from diagonal and nondiagonal terms - nondiagonal contribute most (N*(N-1) versus N)
    Var2diag= (E22diag*NT1-M2.^2)/NT1^2;        %Normalizing by number of trials - variance of diagonal terms - contains both singal and noise correlations for a given trial
    E21 = E21/NT1^2; 
    E22 = E22/NT1^2;
    M1=M1/NT1;
    M2=M2/NT1;
    M1diag=M1diag/NT1;
    M2diag=M2diag/NT1;
end

%Mean Removal - this removes the DC term
if strcmp(Mean,'y')
    R12=R12-M1*M2;
    R12diag=R12diag-M1diag*M2diag;
end

%Converting to data structure
CorrWinData.R12_sh=R12;             %Shuffled crosscorrelogram
CorrWinData.R12_ush=R12diag;        %Unshuffled (auto) correlogram
if exist('R12noise')
   CorrWinData.R12_noise=R12noise;	%Noise correlation
end
CorrWinData.Var1_sh=Var1;           %Contains mostly signal variance with a small contributoin of noise from diagonal
CorrWinData.Var2_sh=Var2;           %Contains mostly signal variance with a small contributoin of noise from diagonal
CorrWinData.M1_sh=M1;               %Mean of RAS1
CorrWinData.M2_sh=M2;               %Mean of RAS2
if strcmp(DiagVar,'n')
    CorrWinData.Var1_ush=Var1diag;	%Contains noise and signal variance
    CorrWinData.Var2_ush=Var2diag;	%Contains noise and signal variance
    CorrWinData.M1_ush=M1diag;      %Diagonal mean of RAS1
    CorrWinData.M2_ush=M2diag;      %Diagonal mean of RAS2
end
CorrWinData.E21=E21;
CorrWinData.E22=E22;
CorrWinData.Tau=(-MaxLag:MaxLag)/Fsd*1000;     %Delay Axis
CorrWinData.Param.Fs=Fsd;           %Sampling rate
CorrWinData.Param.T0=T0;            %Window center position
CorrWinData.Param.Tw=Tw;            %Window duration
CorrWinData.Param.MaxTau=MaxTau;    %Max delay
CorrWinData.Param.Mean=Mean;        %Mean removal
CorrWinData.Param.Diag=Diag;        %Diagonal removal
CorrWinData.Param.DiagVar=DiagVar;  %Variance of diagonal terms (signal+noise)

