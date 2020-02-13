%
% function  [Data]=cochleogramdyncorrdata2cell(N,analysis,stat)
%   
%   FILE NAME   : COCHLEOGRAM DYN CORR DATA 2 CELL
%   DESCRIPTION : Grabs different categories correlation blocks in the 
%                 current directory & puts them in a cell called X.
%                 X is a cell containing cells.The output is used in 
%                 cochleogramdyncorrpctest.m.
%
%   N           : Number of different sound categories
%   analysis    : Analysis Type (string)
%                 'Spectral': used when only correlation between frequency
%                             channels needs to be analyzed. (Cross correlation with
%                             tau=0) (when MaxDelay=0,MaxDisparity>0 in cochleogramdyncorrbatch.m)  
%                 'Temporal': used when only temporal correlation needs to be
%                             analyzed. (Autocorrelation considering time lags (tau~=0)) 
%                             (when MaxDelay>0,MaxDisparity=0 in cochleogramdyncorrbatch.m) 
%               'Spectrotemporal': used when both spectral & temporal correlation 
%                                  need to be analyzed. (Cross correlation with
%                                  tau~=0) (when MaxDelay>0,MaxDisparity>0 in cochleogramdyncorrbatch.m)  
%  stat         : Statistic which will be used in analysis (string)
%                 
%                 'Rxy' :  Short Term Correlation
%                 'RxyN':  Normalized short term correlation (as a Pearson
%                          correlation coefficient)

%
%   RETURNED VARIABLES
%
%   Data        : Data structure containing X & its parameters
%                 .X      : Contains data (X is a cell containing cells)
%                 .Param  : Data structure containing X parameters
%                           .FreqChan   : Number of frequency channels used for
%                                         analysis (1st & 2nd dim of Rxy or RxyN)
%                           .Tau        : Number of time lag(delay) points (3rd dim of Rxy or RxyN)
%                           .Time       : Number of time points (4th dim of Rxy or RxyN)
%                           .Analysis   : Analysis Type 
%                           .N          : Number of sound categories used
%                           .CorrParam  : Correlation parameters (structure)
%                           .Stat       : Statistic which was used in analysis 
%
% (C) Mina, Jan 2017  

function [Data]=cochleogramdyncorrdata2cell(N,analysis,stat)

Files = dir('.');
%Getting rid of . & .. in MAC machines
if strcmp(Files(1).name,'.') && strcmp(Files(2).name,'..') 
   Files(1).isdir=~Files(1).isdir; 
   Files(2).isdir=~Files(2).isdir;
end
FolderIndex=find([Files.isdir]);  %Finding indices of existing folders in the current directory
CatDir=Files(FolderIndex(1:end));
XData=cell(N,1);

for count=1:N  %Going through different categories
    CatList=dir([CatDir(count).name '/*_DynCorr.mat']);  %Grabbing correlation blocks in the current directory
    X=cell(length(CatList),1);
    
    %Going through different sounds in each category
    for k=1:length(CatList)
        XTemp=[];
        Xtemporary=[];
        XTemporary=[];
        load([CatDir(count).name '/' CatList(k).name]); %Loading Corr blocks
        
        if strcmp(analysis,'Spectral')
           %Going through different blocks of each Corr block
           for n=1:LB
               eval(['[dim1,dim2,dim3,dim4] = size(CorrData' int2str(n) '.' stat ');']);
               Mask=triu(ones(dim1));
              [index]=find(Mask);  %Finding upper triangular indices
            
               %Going through each point of time axis
               for j= 1:dim4
                   eval(['mat=CorrData' int2str(n) '.' stat '(:,:,:,j);']);
                   XTemp=[XTemp; mat(index)'];  %Taking only the upper triangular part of Corr matrix  
               end
           end
           
        elseif strcmp(analysis,'Temporal')
               %Going through different blocks of each Corr block
               for n=1:LB
                   eval(['[dim1,dim2,dim3,dim4] = size(CorrData' int2str(n) '.' stat ');']);
                   Mask=diag(ones(1,dim1));
                  [index]=find(Mask);  %Finding diagonal indices
            
                  %Going through each point of time axis
                  for j= 1:dim4
                      Xtemp=[];
                      %Going through each point of time lag axis
                      for i= 1:dim3
                          eval(['mat=CorrData' int2str(n) '.' stat '(:,:,i,j);']);
                          Xtemp=[Xtemp mat(index)];  %Taking only the diagonal of Corr matrix 
                      end
                      XTemp=[XTemp; Xtemp];
                  end
               end
               
          elseif strcmp(analysis,'Spectrotemporal')
                 %Going through different blocks of each Corr block
                 for n=1:LB
                     eval(['[dim1,dim2,dim3,dim4] = size(CorrData' int2str(n) '.' stat ');']);
                     Mask=triu(ones(dim1));
                    [index]=find(Mask);  %Finding upper triangular indices

                    %Going through each point of time axis
                    for j= 1:dim4
                        eval(['mat=CorrData' int2str(n) '.' stat '(:,:,:,j);']);
                        XTemporary=[XTemporary; mat(index)'];  %Taking only the upper triangular part of Corr matrix  
                    end
                    Mask=diag(ones(1,dim1));
                   [index]=find(Mask);  %Finding diagonal indices
            
                   %Going through each point of time axis
                   for j= 1:dim4
                       Xtemp=[];
                       %Going through each point of time lag axis
                       for i= 1:dim3
                           eval(['mat=CorrData' int2str(n) '.' stat '(:,:,i,j);']);
                           Xtemp=[Xtemp mat(index)'];  %Taking only the diagonal of Corr matrix 
                       end
                       Xtemporary=[Xtemporary; Xtemp];
                    end
                 end
                 XTemp=[XTemp; XTemporary Xtemporary];
        end
        X(k)={XTemp};
    end
    XData(count)={X};  %Putting data in a cell
end

%Storing XData & its Parameters as data structure
Data.X = XData;
Data.Param.FreqChan = dim1;
Data.Param.Tau = dim3;
Data.Param.Time = dim4;
Data.Param.Analysis = analysis;
Data.Param.N = N;
Data.Param.CorrParam = CorrData1.Param;
Data.Param.Stat = stat;