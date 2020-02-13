%
% function  [Cat]=cochleogramdyncorrbayesclassifierbatcherror(SoundCat,M)
%   
%   FILE NAME     : COCHLEOGRAM DYN CORR BAYES CLASSIFIER BATCH ERROR
%   DESCRIPTION   : Calculates the errors for different sound categories at 
%                   different time points. It receives input from 
%                   cochleogramdyncorrmodelvaldata.m
%
%   SoundCat      : Data to be analyzed 
%   M             : Vector containing different number of consecutive samples
%                   used for validation (For instance round(sqrt(2).^(1:11)):
%                   Approximately half octave logarithmic steps here)
%
%   RETURNED VARIABLES
%
%   Cat           : Data structure containing errors for different sound categories         
%                    
%                  .E  : Error or standard deviation of correct decision percentages 
%
% (C) Mina, April 2018 

function [Cat]=cochleogramdyncorrbayesclassifierbatcherror(SoundCat,M)

%Note that .Param is the same for all different SoundCats, so it doesn't 
%matter from which SoundCat you read the parameters, here you grab
%parameters from the 1st SoundCat
if isfield  (SoundCat(1).Param, 'Analysis') && strcmp(SoundCat(1).Param.Analysis,'Temporal') 
    M=M * SoundCat(1).Param.FreqChan;
end

for counter=1:length(M)  
    
    [Data]=cochleogramdyncorrbayesclassifier(SoundCat,M(counter));  %Performs Bayes classification

    CatNum=length(Data.SoundCat);  %Finding number of categories
    
    for count=1:CatNum
        Decision=[];
        TestNum=find(Data.InputCat==count);  
        %Adding 1 to elements of ValidClass for each decision made
        for k=TestNum(1):TestNum(end)
            if Data.InputCat(k)==Data.OutputCat(k)  %Right decision(classification)
               Decision(k)=1;  %Right decisions will gain 1
            else
               Decision(k)=0;  %Wrong decisions will gain 0
            end
        end

        Decisionb=bootstrp(10000,'mean',Decision);  %Bootstraping
        Cat(count).E(counter)=std(Decisionb);  %Finding standard deviation of bootstraped decisions
    end
end