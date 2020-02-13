%
%function [CovWinDataN]=rastermuashuffledxcovwinfastN(RASN,Fsd,T0,Tw,MaxTau,Mean,Diag,DiagVar)
%
%   FILE NAME       : RASTER MUA SHUFFLED XCOV WIN FAST N
%   DESCRIPTION     : N-Channel shuffled crosscorrelogram obtained from
%                     N-Channel response rastergram. Performs shuffled 
%                     correlograms between the rasters from N recording
%                     channels and normalizes the data as a covariance.
%
%	RASN            : Data structure containing MUA rasters for multi-channel
%                     recording (pre-loaded using "LOADMUARASN")
%   Fsd             : Sampling rate of raster to compute raster-corr (pre-loaded using "LOADMUARASN"). 
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
%  CovWinDataN      : Data structure containing the following elements
%
%                     .CovWinData(k,l)      - Windowed shuffled crosscorrelation
%                                             covariance for a channel pair k and l.
%                     .CovWinMatrixMax_shs  - Matrix of maximum shuffled correlation
%                                             covariance (normalized by shuffled
%                                             variance) for all channel pairs.
%                     .CovWinMatrixMax_sh   - Matrix of maximum shuffled correlation
%                                             covariance (normalized by unshuffled
%                                             variance) for all channel pairs.
%                     .CovWinMatrixMax_ush  - Matrix of maximum auto correlation
%                                             covariance (normalized by unshuffled
%                                             variance) for all channel pairs.
%                     .CovWinMatrix0_shs    - Matrix of zero-delay shuffled correlation
%                                             covariance (normalized by shuffled
%                                             variance) for all channel pairs.
%                     .CovWinMatrix0_sh     - Matrix of zero-delay shuffled correlation
%                                             covariance (normalized by unshuffled
%                                             variance) for all channel pairs.
%                     .CovWinMatrix0_ush    - Matrix of zero-delay auto correlation
%                                             covariance (normalized by unshuffled
%                                             variance) for all channel pairs.
%
% (C) Xiu Zhai & Monty Escabi, Jan 2018
%
function [CovWinDataN]=rastermuashuffledxcovwinfastN(RASN,Fsd,T0,Tw,MaxTau,Mean,Diag,DiagVar)

%Input Arguments
if nargin<6 | isempty(Mean)
    Mean='y';
end
if nargin<7 | isempty(Diag)
    Diag='y';
end
if nargin<8 | isempty(DiagVar)
    DiagVar='n';
end


%Computing Across Channel Covariance
for k=1:length(RASN.RASMUAData)         %channel number
    for l=1:length(RASN.RASMUAData)     %channel number
        [CovWinData(k,l)]=rastermuashuffledxcovwinfast(RASN.RASMUAData(k).RAS,RASN.RASMUAData(l).RAS,Fsd,T0,Tw,MaxTau,Mean,Diag,DiagVar);
        
        CovWinMatrixMax_shs(k,l)=max(CovWinData(k,l).R12_shs);
        if strcmp(DiagVar,'n')
            CovWinMatrixMax_sh(k,l)=max(CovWinData(k,l).R12_sh);
            CovWinMatrixMax_ush(k,l)=max(CovWinData(k,l).R12_ush);
        end
        
        N_shs=(length(CovWinData(k,l).R12_shs)-1)/2;
        if strcmp(DiagVar,'n')
            N_sh=(length(CovWinData(k,l).R12_sh)-1)/2;
            N_ush=(length(CovWinData(k,l).R12_ush)-1)/2;
        end
        CovWinMatrix0_shs(k,l)=CovWinData(k,l).R12_shs(N_shs+1);
        if strcmp(DiagVar,'n')
            CovWinMatrix0_sh(k,l)=CovWinData(k,l).R12_sh(N_sh+1);
            CovWinMatrix0_ush(k,l)=CovWinData(k,l).R12_ush(N_ush+1);
            CovWinMatrix0_noise(k,l)=CovWinData(k,l).R12_noise(N_ush+1);
        end
    end
end

%Adding Covariance Matrix to Data Structure
CovWinDataN.CovWinData=CovWinData;
CovWinDataN.CovWinMatrixMax_shs=CovWinMatrixMax_shs;
if strcmp(DiagVar,'n')
    CovWinDataN.CovWinMatrixMax_sh=CovWinMatrixMax_sh;
    CovWinDataN.CovWinMatrixMax_ush=CovWinMatrixMax_ush;
end
CovWinDataN.CovWinMatrix0_shs=CovWinMatrix0_shs;
if strcmp(DiagVar,'n')
    CovWinDataN.CovWinMatrix0_sh=CovWinMatrix0_sh;
    CovWinDataN.CovWinMatrix0_ush=CovWinMatrix0_ush;
    CovWinDataN.CovWinMatrix0_noise=CovWinMatrix0_noise;
end