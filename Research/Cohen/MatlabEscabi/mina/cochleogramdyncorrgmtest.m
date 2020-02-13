%
% function []=cochleogramdyncorrgmtest(Data,PCNum,MaxGMNum)
%   
%   FILE NAME   : COCHLEOGRAM DYN CORR GM TEST
%   DESCRIPTION : Plots Log Likelihood of test & training data vs Number of
%                 Gaussian Components used for modeling. GMNum which gives you 
%                 the maximum Log Likelihood of test data should be used for 
%                 further analysis in Cochleogramdyncorrmodelvaldata.m
%                 It receives Data from cochleogramdyncorrdata2cell.m & PCNum 
%                 from cochleogramdyncorrpctest.
%
%   Data        : Data to be analyzed
%   PCNum       : Number of principal components to be used in analysis
%   MaxGMNum    : Maximum number of Gaussian components fitted to data
%
% (C) Mina, Feb 2017 

function []=cochleogramdyncorrgmtest(Data,PCNum,MaxGMNum)

for GMNum=1:MaxGMNum
    LogLike=[];
    
   %Finding log likelihood for the model(training) data
    eval([ '[Cat_GMNum' int2str(GMNum) ']=cochleogramdyncorrmodelloglike(Data,PCNum,GMNum)' ])
    eval([ 'LogLike=[ Cat_GMNum' int2str(GMNum) '.LogLike ];' ])

   %Finding log likelihood for the validation(test) data
    eval([ '[valloglike_GMNum' int2str(GMNum) ']=cochleogramdyncorrvalloglike(Data,PCNum,GMNum);' ])
    
    plot(GMNum,mean(LogLike),'o')    
    hold on
    eval([ 'plot(GMNum,mean(valloglike_GMNum' int2str(GMNum) '),''*'')' ])
    hold on
    legend('Training','Test')
    xlabel('Number of Gaussian Components')
    ylabel('Log Likelihood')
end