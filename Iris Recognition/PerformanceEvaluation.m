function crr=PerformanceEvaluation(pred_y,y_test)

crr=accuracy(pred_y,y_test);
      
function p=accuracy(data1,data2)
    n2=length(data1);
    for i=1:n2
        is_equal(i)=isequal(data1(i),data2(i)); %compare two dataset, return 1 if match, 0 if not match
    end
    correct_idx = find(is_equal()==1);%find matches data indices
    N = length(correct_idx); %number of matched data
    N_total = length(is_equal); %number of total data
    p = N/N_total; %accuracy
end
end
