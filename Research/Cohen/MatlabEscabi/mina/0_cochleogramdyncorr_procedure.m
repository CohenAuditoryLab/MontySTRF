
% Procedure for Sound Categorization using Cochiogram Dynamic Correlation approach 
% ---------------------------------------
% 1. Generating dynamic correlation blocks
%       cochleogramdyncorrbatch(SoundExcelSheetHeader,FileHeader,N,dx,f1,fN,Fm,OF,TB,Dur,dT,MaxDelay,MaxDisparity,OFc,FsRe,Norm,GDelay,Gain,dis,ATT,ATTc,FilterType)
% 	eg.
 		cochleogramdyncorrbatch('SoundSpreadSheet','/Volumes/TextureData1',13,1/8,100,16000,500,1,5,10,0.1,0.05,57,1,44100,'Amp','n','Lin','n',60,40,'GammaTone') 	
%     
%%
% 2. Sorting correlation blocks into "Data"
%       [Data]=cochleogramdyncorrdata2cell(N,analysis,stat)
% 	eg.
        [Data]=cochleogramdyncorrdata2cell(13,'Spectrotemporal','RxyN');
% 
%% 
% 3. Training the model for each validation test 
%       [SoundCat]=cochleogramdyncorrmodelvaldata(Data,PCNum,GMNum)
% 	eg.
        [SoundCat]=cochleogramdyncorrmodelvaldata(Data,34,13);
%
%% 
% 4. Classification
%       [PercentCorrect,E,ConfusionMatrix,AveConfusionMat]=cochleogramdyncorrbayesclassifierbatch(SoundCat,M)
% 	eg.
		[PercentCorrect,E,ConfusionMatrix,AveConfusionMat]=cochleogramdyncorrbayesclassifierbatch(SoundCat,round(sqrt(2).^(1:14)));
% 	