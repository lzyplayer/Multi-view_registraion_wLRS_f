function [ regroup ] = compare_helping( real_data,cur_data,Motion )
%COMPARE_HELPING 按真值结果排列运动结果，以便后续比对真值
%   此处显示详细说明
length=size(real_data,2);
regroup={};
for i=1:length
    tarNum=size(real_data{i},2);
    for j=1:length
        curNum=size(cur_data{j,1},1);
        if tarNum==curNum
            break;
        end    
    end
    if tarNum~=curNum
        error('ERROR: wrong pair!');
    end
    regroup{i}=Motion{j};
end



end

