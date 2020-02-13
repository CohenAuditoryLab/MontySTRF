function [SI1,SI2,SI3]=stationarityindex(Corr)

%Reshaping Short-Term Spectrotemproal Correlation Matrix
NDims=ndims(Corr);
N2=size(Corr,NDims);
N1=numel(Corr)/N2;
Corr=reshape(Corr,N1,N2);
 
%Computing Residual Norm at each Time point
MeanCorr=mean(Corr,2);
MeanCorr=repmat(MeanCorr,1,N2);
Res=Corr-MeanCorr;
 
%Estimating Time-Averaged Norm and Normalizing by Norm of the Mean Corr
ResNorm=mean(sqrt(diag(Res'*Res)));
SI1=ResNorm/mean(sqrt(diag(MeanCorr'*MeanCorr)));
 
%Estimating Time-Averaged Norm and Normalizing by Norm of the Corr
ResNorm=mean(sqrt(diag(Res'*Res)));
SI2=ResNorm/mean(sqrt(diag(Corr'*Corr)));
 
%Uses law of total variance applied to residuals
SI3=var(mean(Res,1))/var(reshape(Res,1,numel(Res)));