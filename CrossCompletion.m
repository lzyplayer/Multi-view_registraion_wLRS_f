function [resultA,updatedM,weight,MID]=CrossCompletion(X,A,W)
%CROSSCOMPLETION 相乘补全
%   采用所得尽可能大的权重积作为桥梁
scannum=size(A,1);
resultA=A;
for curr=1:scannum
    for tar=curr:scannum
        if (A(curr,tar)==0)
            [bridge,crossWeight]=FindBridge(curr,tar,W,scannum);
            if(bridge~=0)
                motion=X[]%%%%%%edit  here
            end
        end 
    end  
end
end

function [bridge,curMaxW]=FindBridge(curr,tar,W,scannum)
    bridge=0;
    curMaxW=0;
    for  bridgeTry=1:scannum
        if(bridgeTry~=curr&&bridgeTry~=tar)
            if(W(curr,bridgeTry)~=0&&W(bridgeTry,tar)~=0)
               currWeight =W(curr,bridgeTry)*W(bridgeTry,tar);
               if(currWeight>curMaxW)
                    bridge=bridgeTry;
                    curMaxW=currWeight;
               end
            end
        end
    end
    
end