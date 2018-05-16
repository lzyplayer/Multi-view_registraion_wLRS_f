function  [ RotErr, TranErr ] = com_realRT( real_data,cur_data,Motion ,GrtR,GrtT)
% com_realRT 按真值结果排列运动结果，zai比对真值
%   此处显示详细说明
scannum=size(real_data,2);
regroup={};
for i=1:scannum
    tarNum=size(real_data{i},2);
    for j=1:scannum
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

RotErr=0;
TranErr=0;
for i=1:scannum
%     rResult=abs(Motion{i}(1:3,1:3)-GrtR{i});
%     Rerr=sum(sum(rResult));
%     RotErr=Rerr+RotErr;
    RotErr=norm((regroup{i}(1:3,1:3)-GrtR{i}),'fro')+RotErr;
    TranErr=norm((regroup{i}(1:3,4)./1000-GrtT{i}),2)+TranErr;
%     Terr=sum(tResult);
%     TranErr=TranErr+Terr;
end
RotErr=RotErr/scannum;
TranErr=(TranErr/scannum)*1000; %zoom


end

