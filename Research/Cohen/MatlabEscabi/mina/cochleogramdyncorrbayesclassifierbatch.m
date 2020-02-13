%
% function  [PercentCorrect,E,ConfusionMatrix,AveConfusionMat]=cochleogramdyncorrbayesclassifierbatch(SoundCat,M)
%   
%   FILE NAME     : COCHLEOGRAM DYN CORR BAYES CLASSIFIER BATCH
%   DESCRIPTION   : Does the classification for different sound
%                   lengths specified in vector M. It receives input from 
%                   cochleogramdyncorrmodelvaldata.m
%
%   SoundCat      : Data to be analyzed 
%   M             : Vector containing different number of consecutive samples
%                   used for validation (For instance round(sqrt(2).^(1:11)):
%                   Approximately half octave logarithmic steps here)
%
%   RETURNED VARIABLES
%
%   PercentCorrect  : Correct decision percentages which describe the
%                     quality of the performance
%   E               : Error or standard deviation of correct decision percentages 
%   ConfusionMatrix : Confusion Matrix
%   AveConfusionMat : Average Confusion Matrix
%
% (C) Mina, Jan 2017 

function [PercentCorrect,E,ConfusionMatrix,AveConfusionMat]=cochleogramdyncorrbayesclassifierbatch(SoundCat,M)

%Note that .Param is the same for all different SoundCats, so it doesn't 
%matter from which SoundCat you read the parameters, here you grab
%parameters from the 1st SoundCat
if isfield  (SoundCat(1).Param, 'Analysis') && strcmp(SoundCat(1).Param.Analysis,'Temporal') 
    M=M * SoundCat(1).Param.FreqChan;
end

AveConfusionMat=zeros(length(SoundCat),length(SoundCat));
for counter=1:length(M)  
    
    [Data]=cochleogramdyncorrbayesclassifier(SoundCat,M(counter));  %Performs Bayes classification
  
    TestNum=length(Data.InputCat);  %Total number of validation tests
    CatNum=length(Data.SoundCat);  %Finding number of categories
    ValidClass=zeros(CatNum,CatNum);  %Assigning a zero matrix to ValidClass

    %Adding 1 to elements of ValidClass for each decision made
    Decision=[];
    for k=1:TestNum
        if Data.InputCat(k)==Data.OutputCat(k)  %Right decision(classification)
           ValidClass(Data.InputCat(k),Data.InputCat(k))=ValidClass(Data.InputCat(k),Data.InputCat(k))+1;
           Decision(k)=1;  %Right decisions will gain 1
        else
           ValidClass(Data.InputCat(k),Data.OutputCat(k))=ValidClass(Data.InputCat(k),Data.OutputCat(k))+1;
           Decision(k)=0;  %Wrong decisions will gain 0
        end
    end
    
    %Taking the average of each row of ValidClass matrix to find confusion matrix
    for k=1:CatNum
        ConfusionMat(k,:)=ValidClass(k,:)./(sum(ValidClass(k,:)));
    end
    
    ConfusionMatrix(counter)={ConfusionMat};
    AveConfusionMat=AveConfusionMat+ConfusionMat;
    
    %Taking the average of diagonal of Confusuin matrix to find Percent Correct for each category
    PercentCorrect(counter)=trace(ConfusionMat)/CatNum;
    
    Decisionb=bootstrp(10000,'mean',Decision);  %Bootstraping
    E(counter)=std(Decisionb);  %Finding standard deviation of bootstraped decisions
end

AveConfusionMat=AveConfusionMat./length(M);