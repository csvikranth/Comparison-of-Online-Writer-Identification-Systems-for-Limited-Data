function [result] = multisvm1(TrainingSet,GroupTrain,TestSet,bc,ks)
%Models a given training set with a corresponding group vector and 
%classifies a given test set using an SVM classifier according to a 
%one vs. all relation. 

u=unique(GroupTrain);
numClasses=length(u);

%build SVM models
for k=1:numClasses
    %Vectorized statement that binarizes Group
    %where 1 is the current class and 0 is all other classes
    G1vAll=(GroupTrain==u(k));
    models{k} = fitcsvm(TrainingSet,G1vAll,'KernelFunction','rbf','BoxConstraint',bc,'KernelScale',ks);
end

%Computing the classification scores for all the test samples across all
%the SVMs
scores_all=[];
for k=1:numClasses
        [label,score]=predict(models{k},TestSet);
        scores_all=[scores_all score(:,2)];
end
%Predicting the label
[m,result]=sort(scores_all','descend');
result=result';