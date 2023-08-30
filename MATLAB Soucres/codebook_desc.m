clear
clc
features = load('E:\Final year Project\new\features.mat');
Train = load('E:\Final year Project\new\Train.mat');
files = load('E:\Final year Project\new\files.mat');
data_kmeans=Train.train;
feat_norm=features.data;
N_files=files.data;
k=70;

[idx,C]=kmeans(data_kmeans(:,1:end-3),k,'Maxiter',1000);%codebook generation
n_writer_ini=1;
n_writer_fin=43;
n_feat=size(feat_norm,2)-3;

vlad_all=[];
vlad_train=[];
vlad_test=[];

for i=n_writer_ini:n_writer_fin
    train_para=randsample(N_files(i),floor(0.8*N_files(i)));%Choosing enrolment documents at random
    for j=1:N_files(i)
        doc_features=feat_norm(feat_norm(:,end-2)==i&feat_norm(:,end-1)==j,:);%
        if size(doc_features,1)==0
            continue;
        end
        % dist=zeros(size(doc_features,1),size(C,1));
        % for m=1:size(doc_features,1)
        % for n=1:size(C,1)
        % dist(m,n)=norm(doc_features(m,1:end-3)-C(n,:));
        % end
        % end
        % [M,doc_idx]=min(dist,[],2);
        [doc_idx,~]=knnsearch(C,doc_features(:,1:end-3));%Finding nearest neighbour. This one line code is a replacement for the commented code section just above
        vlad=[];
        for l=1:k
            cl_features=doc_features(doc_idx(:)==l,1:end-3);%Feature vectors that fall into the lth clusters
            s=size(cl_features,1);
            if(s~=0)
                D=sign(cl_features-repmat(C(l,:),s,1));
                for o=1:n_feat
                    feat_dis=D(:,o);
                    ind_pos=find(feat_dis>=0);
                    sum_pos(1)=sum((1./(1+abs(cl_features(ind_pos,o)-C(l,o)))));%Computing S~p+ and S~p- scores for each attribute
                    ind_neg=find(feat_dis==-1);
                    sum_pos(2)=sum((-1./(1+abs(cl_features(ind_neg,o)-C(l,o)))));
                    sum_pos1(l,2*o-1)=sum_pos(1);
                    sum_pos1(l,2*o)=sum_pos(2);
                    feat_dis=[];
                    ind_pos=[];
                    ind_neg=[];
                    
                end
                clear D sum_pos
            else
                D1=zeros(1,n_feat);
                D2=zeros(1,n_feat);
                sum_pos1(l,:)=[D1,D2];
                clear D1 D2
            end
            
        end
        acc_sum_pos=sum(sum_pos1);
        for l=1:k-1
            sum_pos1(l,:)=sum_pos1(l,:)./(acc_sum_pos+eps(1));
            vlad=[vlad,sum_pos1(l,:)];
        end
        vlad_all=[vlad_all;vlad double(i) double(j)];
        if(ismember(j,train_para))
            vlad_train=[vlad_train;vlad double(i) double(j)];
        else
            vlad_test=[vlad_test;vlad double(i) double(j)];
        end
    end
    % i
end