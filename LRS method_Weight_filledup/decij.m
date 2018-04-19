function [A,MID,num]= decij(overlapRate, scannum, Trim, dTrim)

A = eye(scannum);
num= 0;
for i=1: scannum
    for j= (i+1): scannum
        Over= [overlapRate(i,j),overlapRate(j,i)];
        [val,id]= max(Over);
        if (val>Trim)
            ids=[i,j;j,i];
            num= num+1;
            MID(num,1)=ids(id,1);
            MID(num,2)=ids(id,2);
            a = ids(id,1);    b = ids(id,2);
            A(a,b) = 1;
        else
            if (Over(1)>(Trim-dTrim))
                num= num+1;
                MID(num,1)= i;
                MID(num,2)= j;
                A(i,j) = 1;
            end
            if ( Over(2)>(Trim-dTrim))
                num= num+1;
                MID(num,1)= j;
                MID(num,2)= i;
                A(j,i) = 1;
            end
        end
    end
end

