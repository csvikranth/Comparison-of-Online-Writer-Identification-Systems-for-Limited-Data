function[m v w]= ubm_adapt(X, NG, Mean_UBM, Var_UBM, Weights_UBM)
%%%------------------------------------------------------------------------
% Inputs
%%%------------------------------------------------------------------------
% X   -> Feature vector matrix X of dimension Txd where T is the no of feature vectors and d is the dimension of each feature vector
% L   -> No of Iterations  (Recomended to use >10)
% NG  -> No of Gaussians



%     Mean_UBM   Mixture means of UBM, one row per mixture. 
%     Var_UBM    Mixture variances of UBM , one row per mixture. 
%     Weights_UBM   Mixture weights of UBM, one per mixture. The weights will sum to unity. 

% Outputs: 

%%%------------------------------------------------------------------------ 
    [T, d]=size(X);
    n=0;
    Exn=0;
    Ex2n=0;
   for t=1:T 
    xt=X(t,:)';
    
    for j=1:NG
        mi=Mean_UBM(j,:)';
        
        vi=eye(d);
        for k=1:d
          vi(k,k)=Var_UBM(j,k);
        end      
        
        p(j)= gauss_prob(xt,mi,vi);
    end
    
    wjpj=Weights_UBM.*p;
    PrDr=sum(wjpj);
    if(PrDr~=0)
    Prt=wjpj/PrDr;
    else
     Prt=wjpj;
    end
    if(isnan(Prt))
        flag=1;
    end
    n=n+Prt;
    Exn=Exn+ xt*Prt;
    Ex2n=Ex2n+(diag(xt*xt'))*Prt;
   end
   
   for j=1:NG
   Ex(:,j)=Exn(:,j)./n(j);
   Ex2(:,j)=Ex2n(:,j)./n(j);
   end
   
   alpha=n./(n+16);
   w_temp= (alpha.*n)/T+(1-alpha).*Weights_UBM;
   w=w_temp/sum(w_temp);
   
   for j=1:NG
       mu=Mean_UBM(j,:)';
       sigma2=Var_UBM(j,:)';
       
       
       mtemp=alpha(j)*Ex(:,j)+(1-alpha(j))*mu;
       m(:,j)=mtemp;
       
       
       v(:,j)=alpha(j)*Ex2(:,j)+(1-alpha(j))*(sigma2+diag(mu*mu'))- diag(mtemp*mtemp');
   end
   
   
   w=w';
   m=m';
   v=v';
end
 
   
   
   
    
    
    