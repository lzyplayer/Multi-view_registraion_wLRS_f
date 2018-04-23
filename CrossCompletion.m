function [X,resultA,W]=CrossCompletion(X,A,W)
%CROSSCOMPLETION 相乘补全
%   采用所得尽可能大的权重积作为桥梁
% WtoMin=W;
% WtoMin(WtoMin==0)=1;
% minW=min(min(WtoMin));
scannum=size(A,1);
resultA=A;
for curr=1:scannum
    for tar=curr:scannum
        if (A(curr,tar)==0)
            [bridge,crossWeight]=FindBridge(curr,tar,A,W,scannum);
            if(bridge~=0)
                motion=X((curr*4-3):curr*4,(bridge*4-3):bridge*4)*X((bridge*4-3):bridge*4,(tar*4-3):tar*4);%运动传递
                X((curr*4-3):curr*4,(tar*4-3):tar*4)=motion;
                X((tar*4-3):tar*4,(curr*4-3):curr*4)=inv(motion);
                W(curr,tar)=crossWeight;
                W(tar,curr)=crossWeight;
                %resultA(curr,tar)=1;%
                %resultA(tar,curr)=1;
            end
        end 
    end  
end
end

function [bridge,curMaxW]=FindBridge(curr,tar,A,W,scannum)
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
%     if (curMaxW<minW) 
%         bridge=0;
%     end
    
end