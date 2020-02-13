



function [B]=snnconnmatrxi121(N1,N2,MU,SIG)

%Generate connectivity matrix
X=repmat((1:N1),N2,1);
MU=repmat(MU,1,N1);
SIG=repmat(SIG,1,N1);
B=exp(-(X-MU).^2./2./SIG.^2)

%Threshold at 3 SD and sparsify
i=find(B<exp(-3.^2/2));
B(i)=zeros(size(i));
B=sparse(B);
