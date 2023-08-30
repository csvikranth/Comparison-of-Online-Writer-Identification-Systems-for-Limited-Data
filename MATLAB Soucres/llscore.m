clear
clc
correct=0;
wrong=0;
data_path = 'D:\NEW_DOWNLOADS\3_2200-20220411T110418Z-001\3_2200';
files=dir(data_path); 
parameters_path = 'D:\NEW_DOWNLOADS\drive-download-20220429T103850Z-001\3 Adapted Parameters_35';
parameters=dir(parameters_path);
p=0;
c=0;
for k=3:length(files)
    filename=[data_path '\' files(k).name];
    label=files(k).name;
    if label(2:2)=='_'
        True_label=label(1:1);
    else
        True_label=label(1:2);
    end
    disp(True_label)
    disp(filename)
    c=c+1;
    x=readmatrix(filename);
    maxscore=[]
    predicted_label=''
    for j=3:length(parameters)
        parameter=[parameters_path '\' parameters(j).name];
        plabel=parameters(j).name;
        if plabel(2:2)=='.'
            parameter_label=plabel(1:1)
        else
            parameter_label=plabel(1:2)
        end
        disp(parameter)
        p=p+1;
        params=load(parameter);
        lls=getLikelihood(35,x',params.m,params.v,params.w)
        maxscore(str2num(parameter_label))=lls;

    end
    predicted_label=find(maxscore==max(maxscore))
    if (str2num(True_label)-predicted_label)==0
        correct=correct+1
    else
        wrong=wrong+1
    end
    disp(strcat('correct:',num2str(correct),"/",num2str(length(files)-2)))
    disp(strcat('wrong:',num2str(wrong),"/",num2str(length(files)-2)))
    disp(strcat('Total:',num2str(correct+wrong),"/",num2str(length(files)-2)))
end

