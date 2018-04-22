function [MID, A, num] = LRSdecij(overlapRate, scannum, Trim, dTrim)

A = eye(scannum);
num = 0;
for i=1: scannum
    for j= 1: scannum
        if ((i~=j)&(overlapRate(i,j)>Trim))%大于裁剪比率的就记为正确匹配
           num= num+1;
           MID(num,1)=i;
           MID(num,2)=j;   %所有认为成功匹配的对
           A(i,j) = 1;
        end
    end
end