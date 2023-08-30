function [LL]=getLikelihood(NoG,Writerfeatures,Writer_Mean,Writer_Var,Writer_W)
for i=1:size(Writerfeatures,1)
x=Writerfeatures(i,:);
    for k=1:NoG
        v=eye(size(Writer_Mean,2));
        for l=1:size(Writer_Mean,2)
            v(l,l)=Writer_Var(k,l);
        end
    Pk(k)=gauss_prob2(x,Writer_Mean(k,:),v);
    if(isnan(Pk(k)))
        flag=1;
    end
    end
    if(sum(Writer_W.*Pk')~=0)
    LL1(i)=log(sum(Writer_W.*Pk'));
    else
     LL1(i)=0;
    end
end
LL=sum(LL1)./length(LL1);
end
function[p]= gauss_prob2(x,m,v)

[D d]=size(x);

p=(1/((2*pi)^(d/2)*(det(v))^.5))*exp(-.5*(x-m)*inv(v)*(x-m)');  
end