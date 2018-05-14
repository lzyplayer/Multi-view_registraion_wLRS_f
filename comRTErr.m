function [ RotErr, TranErr ] = comRTErr( Motion  )
%COMRTERR 计算和兔子真值的误差比对
%   此处显示详细说明
load BunnySet;
scannum=length(Motion);
RotErr=0;
TranErr=0;
for i=1:scannum
%     rResult=abs(Motion{i}(1:3,1:3)-GrtR{i});
%     Rerr=sum(sum(rResult));
%     RotErr=Rerr+RotErr;
    RotErr=norm((Motion{i}(1:3,1:3)-GrtR{i}),'fro')+RotErr;
    tResult=abs(Motion{i}(1:3,4)./1000-GrtT{i});
    Terr=sum(tResult);
    TranErr=TranErr+Terr;
end


