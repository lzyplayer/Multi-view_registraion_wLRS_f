function [X,resultA,W]=CrossCompletion(X,A,W)
%CROSSCOMPLETION 相乘补全
%   采用所得尽可能大的权重积作为桥梁
% WtoMin=W;
% WtoMin(WtoMin==0)=1;
% minW=min(min(WtoMin));  设置相乘补全阈值，效果不佳未使用
scannum=size(A,1);
resultA=A;
for curr=1:scannum
    for tar=curr:scannum%修改curr为1来进行相乘补全后不对称补全的方法
        if (A(curr,tar)==0)
            [bridge,crossWeight]=FindBridge(curr,tar,A,W,scannum);
%           [bridge,crossWeight]=FindBridge(curr,tar,A,W,scannum，minW);
            if(bridge~=0)
                motion=X((curr*4-3):curr*4,(bridge*4-3):bridge*4)*X((bridge*4-3):bridge*4,(tar*4-3):tar*4);%运动传递
                X((curr*4-3):curr*4,(tar*4-3):tar*4)=motion;
                X((tar*4-3):tar*4,(curr*4-3):curr*4)=inv(motion);%使用了对称补全
                W(curr,tar)=crossWeight;
                W(tar,curr)=crossWeight;%使用了对称补全
                %resultA(curr,tar)=1;%
                %resultA(tar,curr)=1;
            end
        end 
    end  
end
end

function [bridge,curMaxW]=FindBridge(curr,tar,A,W,scannum)
% function [bridge,curMaxW]=FindBridge(curr,tar,A,W,scannum，minWeight) %带阈值
    bridge=0;
    curMaxW=0;
    for  bridgeTry=1:scannum
        if(bridgeTry~=curr&&bridgeTry~=tar)
            if(A(curr,bridgeTry)==1&&A(bridgeTry,tar)==1)
               currWeight =W(curr,bridgeTry)*W(bridgeTry,tar);
               if(currWeight>curMaxW)
                    bridge=bridgeTry;
                    curMaxW=currWeight;
               end
            end
        end
    end
%     if (curMaxW<minWeight) 
%         bridge=0;
%     end
    
end