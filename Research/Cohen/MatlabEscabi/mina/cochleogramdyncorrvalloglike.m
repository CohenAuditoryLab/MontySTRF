%
% function [valloglike]=cochleogramdyncorrvalloglike(Data,PCNum,GMNum))
%   
%   FILE NAME   : COCHLEOGRAM DYN CORR VAL LOG LIKE
%   DESCRIPTION : Finds Log likelihood of each validation sound. It receives 
%                 Data from cochleogramdyncorrdata2cell.m & output is used in 
%                 cochleogramdyncorrgmtest.m
%                
%   Data        : Data to be analyzed
%   PCNum       : Number of principal components to be used in analysis
%   GMNum       : Number of Gaussian components fitted to data
%
%   RETURNED VARIABLES
%
%   valloglike  : Log likelihood of validation sounds
%
% (C) Mina, March 2017 

function [valloglike]=cochleogramdyncorrvalloglike(Data,PCNum,GMNum)

XData=Data.X;

%Defining variables
NCat=size(XData,1);  %Finding number of categories 
NSounds=cellfun('length',XData);  %Vector containing the number of sounds in each category
Pprior=NSounds/sum(NSounds);  %Vector containing prior probability 
counter=1;

%Removing one sound at a time from a given category - the sound removed
%is used for validation
for CatCounter=1:NCat %Going through all categories - used for pseudo jackknife for validation
    for SoundCounter=1:NSounds(CatCounter)  %Going through all sounds - pseudo jackknife for validation

        %Removing sound
        X.ValData=cell2mat(XData{CatCounter,1}(SoundCounter));  %Putting the validation sound data in a matrix 
        X.ModelData=XData;
        X.ModelData{CatCounter,1}(SoundCounter)=[];  %Omitting the validation sound from data to make the model

       %Combining Data from different categories in order to take PCA and build category models
       ModelData=[];
       Cat=cell2struct(X.ModelData,'ModelData',NCat);
       for Counter=1:NCat
           xtemp=cell2mat(Cat(Counter).ModelData(:)); 
           ModelNtrial(Counter)=size(xtemp,1);         %Number of trials (rows) of each category's model matrix (needed to find gaussian mixture model for each category)
           ModelData=[ModelData; xtemp];         %Combining model data for different categories, Rows & Columns are corresponding to time points & features respectively
       end

       %Normalizing data for zero mean - Finding the mean of model data & subtracting it from model & validation data
       ModelDataMean=mean(ModelData,1);  %Vector containing mean of columns (features) of Model data 
       X.ValData=X.ValData-repmat(ModelDataMean,size(X.ValData,1),1);  %Subtracting the mean of model data from validation data
       ModelData=ModelData-repmat(ModelDataMean,size(ModelData,1),1);  %Subtracting the mean of model data from model data

       %Computing PCA on model data
       [Modelcoeff,ModelScore]=pca(ModelData,'Algorithm','svd','Centered',false);  %Performing principal component analysis on model data

       %Fitting data from each category to gaussian mixture model
       %Also compute Log-Likelihood for the model data
        for count=1:NCat
            index=(1:ModelNtrial(count)) + sum(ModelNtrial(1:count-1));         %Finding indices for data from each category - note that there may be multiple sounds per category
            %TRY / CATCH in case of convergence problems
            try 
               Cat(count).GMModel = fitgmdist(ModelScore(index,1:PCNum),GMNum,'CovarianceType','diagonal','Options',statset('MaxIter',1000)); %Fitting Gaussian mixture dist to each category's principal component scores 
               Cat(count).flag=1;
               SoundCat(CatCounter).Sound(SoundCounter).OutputCat(count).Flag=1;
            catch
               Cat(count).flag=-9999;
               SoundCat(CatCounter).Sound(SoundCounter).OutputCat(count).Flag=-9999;
            end
        end

        %Finding PC scores of the Validation Sound in each category
        %Also compute log-likelihood on validation data
        SoundCat(CatCounter).Sound(SoundCounter).XScore=X.ValData/(Modelcoeff');  
        %Finding Posteriori probability of the Validation Sound belonging to its category
        if Cat(CatCounter).flag == 1
           SoundCat(CatCounter).Sound(SoundCounter).P = pdf(Cat(CatCounter).GMModel,SoundCat(CatCounter).Sound(SoundCounter).XScore(:,1:PCNum)); 
           SoundCat(CatCounter).Sound(SoundCounter).LogLike = log10(Pprior(CatCounter)) + sum(log10(SoundCat(CatCounter).Sound(SoundCounter).P));
           valloglike(counter) = SoundCat(CatCounter).Sound(SoundCounter).LogLike;
        end
        counter=counter+1;
    end
end
