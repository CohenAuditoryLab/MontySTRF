%
%function [CovWinData]=rastermuashuffledxcovwinfast(RAS1,RAS2,Fsd,T0,Tw,MaxTau,Mean,Diag,DiagVar)
%
%   FILE NAME       : RASTER MUA SHUFFLED XCOV WIN FAST
%   DESCRIPTION     : Windowed shuffled crosscorrelation covariance using raster data 
%                     of MUA. The correlation is computed only for a
%                     windowed segment of the Raster. The window is
%                     centered at position T0 and has a duration Tw. For
%                     simplicity we are using a square window.
%
%   RAS1            : Rastergram 1 (NTrials x SamplePoints, pre-loaded using "LOADMUARAS")
%   RAS2            : Rastergram 2 (NTrials x SamplePoints, pre-loaded using "LOADMUARAS")
%   Fsd             : Sampling rate of raster to compute raster-corr (pre-loaded using "LOADMUARAS"). 
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
%                     are removed).
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
%   CovWinData      : Data structure containing the following elements
%
%                     .R12_shs      - Average shuffled crosscorrelogram
%                                     normalized using the shuffled (signal) variance
%                     .R12_sh       - Average shuffled crosscorrelogram
%                                     normalized using the unshuffled (signal+noise) variance
%                     .R12_ush      - Average unshuffled (auto) correlogram
%                                     normalized using the unshuffled (signal+noise) variance
%                     .R12_noise    - Average noise correlogram
%                                     normalized using the unshuffled (signal+noise) variance
%                     .Tau          - Correlation delay axis (msec)
%                     .M1_sh        - Mean of RAS1
%                     .M2_sh        - Mean of RAS2
%                     .M1_ush       - Diagonal mean of RAS1
%                     .M2_ush       - Diagonal mean of RAS2
%                     .Param.Fs     - Raster sampling rate (Hz)
%                     .Param.T0     - See input parameter
%                     .Param.Tw     - See input parameter
%                     .Param.MaxTau - See input parameter
%                     .Param.Mean   - See input parameter
%                     .Param.Diag   - See input parameter
%                     .Param.DiagVar- See input parameter
%
% (C) Xiu Zhai & Monty Escabi, Jan 2018
%
function [CovWinData]=rastermuashuffledxcovwinfast(RAS1,RAS2,Fsd,T0,Tw,MaxTau,Mean,Diag,DiagVar)

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

%Computing shuffled cross and autocovariance
[CorrWinData12]=rastermuashuffledxcorrwinfast(RAS1,RAS2,Fsd,T0,Tw,MaxTau,Mean,Diag,DiagVar);

%Sorting data in structure
CovWinData.R12_shs=CorrWinData12.R12_sh./sqrt(CorrWinData12.Var2_sh.*CorrWinData12.Var1_sh);            %normalized by signal (shuffled) var only
if strcmp(DiagVar,'n')
    CovWinData.R12_sh=CorrWinData12.R12_sh./sqrt(CorrWinData12.Var2_ush.*CorrWinData12.Var1_ush);       %normalized by signal+noise var
    CovWinData.R12_ush=CorrWinData12.R12_ush./sqrt(CorrWinData12.Var2_ush.*CorrWinData12.Var1_ush);     %normalized by signal+noise var
    CovWinData.R12_noise=CorrWinData12.R12_noise./sqrt(CorrWinData12.Var2_ush.*CorrWinData12.Var1_ush); %normalized by signal+noise var
end
CovWinData.Tau=CorrWinData12.Tau;
CovWinData.M1_sh=CorrWinData12.M1_sh;
CovWinData.M2_sh=CorrWinData12.M2_sh;
if strcmp(DiagVar,'n')
    CovWinData.M1_ush=CorrWinData12.M1_ush;
    CovWinData.M2_ush=CorrWinData12.M2_ush;
end
CovWinData.Param.Fs=Fsd;
CovWinData.Param.T0=T0;
CovWinData.Param.Tw=Tw;
CovWinData.Param.MaxTau=MaxTau;
CovWinData.Param.Mean=Mean;
CovWinData.Param.Diag=Diag;
CovWinData.Param.DiagVar=DiagVar;