%
% function [Cat]=cochleogramdyncorrmodelloglike(Data,PCNum,GMNum))
%   
%   FILE NAME   : COCHLEOGRAM DYN CORR MODEL LOG LIKE
%   DESCRIPTION : Fits PCA scores of each category to Gaussian mixture model & 
%                 finds Log likelihood of each category. It receives Data from 
%                 cochleogramdyncorrdata2cell.m and output is used in 
%                 cochleogramdyncorrgmtest.m
%                
%   Data        : Data to be analyzed
%   PCNum       : Number of principal components to be used in analysis
%   GMNum       : Number of Gaussian components fitted to data
%
%   RETURNED VARIABLES
%
%   Cat         : Data structure containing each category's information
%                 .GMModel:  Data structure containing each category's 
%                            gmdistribution fit (refer to fitgmdist function 
%                            for more info)
%                 .flag   :  Shows if fitgmdist function converges or not 
%                            1   : gm fitting converges 
%                           -9999: gm fitting doesn't converge                           
%                 .LogLike:  Log likelihood for each category
%
% (C) Mina, March 2017 

function [Cat]=cochleogramdyncorrmodelloglike(Data,PCNum,GMNum)

XData=Data.X;

%Defining variables
NCat=size(XData,1);  %Finding number of categories 
NSounds=cellfun('length',XData);  %Vector containing the number of sounds in each category
Pprior=NSounds/sum(NSounds);  %Vector containing prior probability 

%Combining Data from different categories in order to take PCA and build category models
X.ModelData=XData;
ModelData=[];
Category=cell2struct(X.ModelData,'ModelData',NCat);
for Counter=1:NCat
    xtemp=cell2mat(Category(Counter).ModelData(:)); 
    ModelNtrial(Counter)=size(xtemp,1);         %Number of trials (rows) of each category's model matrix (needed to find gaussian mixture model for each category)
    ModelData=[ModelData; xtemp];         %Combining model data for different categories, Rows & Columns are corresponding to time points & features respectively
end

%Normalizing data for zero mean - Finding the mean of model data & subtracting it from model data
ModelDataMean=mean(ModelData,1);  %Vector containing mean of columns (features) of Model data 
ModelData=ModelData-repmat(ModelDataMean,size(ModelData,1),1);  %Subtracting the mean of model data from model data

%Computing PCA on model data
[~,ModelScore]=pca(ModelData,'Algorithm','svd','Centered',false);  %Performing principal component analysis on model data

%Fitting data from each category to gaussian mixture model
%Also compute Log-Likelihood for the model data
for count=1:NCat
    index=(1:ModelNtrial(count)) + sum(ModelNtrial(1:count-1));   %Finding indices for data from each category - note that there may be multiple sounds per category
    %TRY / CATCH in case of convergence problems
    try 
       Cat(count).GMModel = fitgmdist(ModelScore(index,1:PCNum),GMNum,'CovarianceType','diagonal','Options',statset('MaxIter',1000)); %Fitting Gaussian mixture dist to each category's principal component scores 
       Cat(count).flag=1;
    catch
       Cat(count).flag=-9999;
    end
    %Finding Posteriori probability of training Sounds belonging to their category
    if Cat(count).flag == 1
       Category(count).P = pdf(Cat(count).GMModel,ModelScore(index,1:PCNum));
       Cat(count).LogLike= log10(Pprior(count)) + (sum(log10(Category(count).P))/(NSounds(count)));
    end
end