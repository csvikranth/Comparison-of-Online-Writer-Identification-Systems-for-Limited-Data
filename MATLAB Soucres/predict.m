bc=10;%box constraint of rbf kernel
ks=1;%kernel scale of rbf kernel
%vlad_train = load("E:\Final year Project\vlad.mat",'vlad_train')
vlad_train = vlad_train;
%vlad_test = load("E:\Final year Project\vlad.mat",'vlad_test')
vlad_test = vlad_test;
n_writer_ini = 1;
p=1;
test_classes_svm=multisvm1(vlad_train(:,1:end-2),vlad_train(:,end-1),vlad_test(:,1:end-2),bc,ks);%multi class SVM training and testing function
test_classes_actual=vlad_test(:,end-1);
%Computing top1 top3 and top5 accuracies
accuracy_top111=sum(test_classes_svm(:,1)+n_writer_ini-1==test_classes_actual)/length(test_classes_actual)*100;
accuracy_top333=(sum(test_classes_svm(:,1)+n_writer_ini-1==test_classes_actual)+sum(test_classes_svm(:,2)+n_writer_ini-1==test_classes_actual)+sum(test_classes_svm(:,3)+n_writer_ini-1==test_classes_actual))/length(test_classes_actual)*100;
accuracy_top555=(sum(test_classes_svm(:,1)+n_writer_ini-1==test_classes_actual)+sum(test_classes_svm(:,2)+n_writer_ini-1==test_classes_actual)+sum(test_classes_svm(:,3)+n_writer_ini-1==test_classes_actual)+sum(test_classes_svm(:,4)+n_writer_ini-1==test_classes_actual)+sum(test_classes_svm(:,5)+n_writer_ini-1==test_classes_actual))/length(test_classes_actual)*100;
accuracy_top1(p)=accuracy_top111;
accuracy_top5(p)=accuracy_top555;
accuracy_top3(p)=accuracy_top333;
Accuracy_top1=accuracy_top1(p)
Accuracy_top3=accuracy_top3(p)
Accuracy_top5=accuracy_top5(p)