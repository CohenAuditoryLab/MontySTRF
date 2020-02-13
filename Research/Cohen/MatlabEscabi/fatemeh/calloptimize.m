%
%function [CallModelData] = calloptimize(CallSegData,CallSegParam,L)
%
%   FILE NAME   : CALL OPTIMIZE
%   DESCRIPTION : Find the optimal pulse model fits to a call data sequence
%
%   CallSegData     : Segmented call data. Obtained using callsegment.m.
%   CallSegParam    : Segment parameter information. Obtained using callsegment.m.
%   L               : Number of iterations for optimization
%
%RETURNED OUTPUTS
%
%   CallModelData(k)   - Array of Data Structure containgin optimal model results
%
%       .PulseModel - vector containg pulse model for kth call
%       .A1         - lower call amplitude - usually the envelope noise level
%       .A2         - Call amplitude
%       .T1         - Call start time
%       .T2         - Call end time
%
% (C) Monty A. Escabi, Edit Oct 2017
%
function [CallModelData] = calloptimize(CallSegData,CallSegParam,L)

for k=1:length(CallSegData)

    %Selecting some Initial Parameteras for each call
    Fs=CallSegParam.Fs;
    MuNoise=CallSegParam(1).MuNoise;
    Time=(0:length(CallSegData(k).ECall)-1)/Fs;
    LB=[ 0*max(Time) 0.05*max(Time) MuNoise ];
    UB=[ .95*max(Time) max(Time) max(CallSegData(k).ECall) ];
    Beta0= [ max(Time)*0.05 max(Time)*0.95 max(CallSegData(k).ECall)];
    
    %Defining Optimization MultiStart Problem
    problem = createOptimProblem('lsqcurvefit','objective',@(Beta,Time) rectwinmodel3(Beta,Time,MuNoise),'x0',Beta0,'xdata',Time,'ydata',CallSegData(k).ECall,'lb',LB,'ub',UB);
    ms = MultiStart;
    [Beta, Err] = run(ms, problem,L);
    
    
    CallModelData(k).PulseModel=rectwinmodel3(Beta,Time,MuNoise);
    CallModelData(k).A2=max(CallModelData(k).PulseModel);
    CallModelData(k).A1=min(CallModelData(k).PulseModel);
    CallModelData(k).T1=Beta(1) + CallSegParam.StartTimeSig(k)/Fs;
    CallModelData(k).T2=Beta(2) + CallSegParam.StartTimeSig(k)/Fs;

    %Plotting Results
     hold off
     plot(Time,CallSegData(k).ECall,'r')
     hold on
     plot(Time,CallModelData(k).PulseModel,'k')
%     pause
end