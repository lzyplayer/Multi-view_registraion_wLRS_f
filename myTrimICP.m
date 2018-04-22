function [resultM,Pe]=myTrimICP(curNs,model,data,initialMotion,iterLimit,minTrim)
%myTrimICP  ICP裁剪
%curNS为当前s模型点云KD树
%初始运动集
maxTrim=1;
iter=1;
perMinMSE=1000;
curMinMSE=100;
scan=initialMotion*data;
while(iter<iterLimit) && (perMinMSE-curMinMSE)>10^(-6)
    [corr,distance] = knnsearch(curNs,scan(1:3,:)');
    minLength = floor(minTrim*length(corr));
    maxLength = ceil(maxTrim*length(corr));
    dtNorm2 = sortrows(distance.^2);
    dtNorm2 = cumsum(dtNorm2);
    dtTable = [minLength:maxLength];
    resultMSE = dtNorm2(minLength:maxLength)'./dtTable;
    resultObject = ObjectiveFunction(resultMSE,dtTable./maxLength);
    [minObjectResult,indexNum] = min(resultObject);
    preMinMSE = curMinMSE;
    curMinMSE = minObjectResult;
    Pe=resultMSE(indexNum);
    trim = dtTable(indexNum)/maxLength;
    %把匹配表附上对象距离并按之排列
    sortedCorrDis = sortrows([corr,[1:length(corr)]',distance],3);
    [resultM,~,scan] = CalRtPhi(model,data,sortedCorrDis,trim);
    iter = iter+1;
end
end

%%%%%%%%%%%%%%%%%%%%Integrated Function%%%%%%%%%%%%%%%%%%%%
%% Calculate R,t,Phi based on current overlap parameter
function [M,TCorr,TData] = CalRtPhi(Model, scan, SortCorrTD,Tr)

TrLength = floor(Tr*size(SortCorrTD,1)); % The number of correonding points after trimming
TCorr = SortCorrTD(1:TrLength, 1:2);     % Trim the corresponding points according to overlap parameter Tr
% Register MData with TData
[M] = reg(Model(1:3,:), scan(1:3,:), TCorr);
% To obtain the transformation data
TData = M*scan;

end
%%%%%%%%%%%%%%% Calculate the registration matrix %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% T(TData)->MData %%%%%%%%%%%%%%%%%%%%%%%%%
% SVD solution
function [M] = reg(Model, Data, corr)

n = length(corr); 
M = Model(:,corr(:,1)); 
mm = mean(M,2);
S = Data(:,corr(:,2));
ms = mean(S,2); 
Sshifted = [S(1,:)-ms(1); S(2,:)-ms(2); S(3,:)-ms(3)];
Mshifted = [M(1,:)-mm(1); M(2,:)-mm(2); M(3,:)-mm(3)];
K = Sshifted*Mshifted';
K = K/n;
[U A V] = svd(K);
R1 = V*U';
if det(R1)<0
    B = eye(3);
    B(3,3) = det(V*U');
    R1 = V*B*U';
end
t1 = mm - R1*ms;
M=[];
M(1:3,1:3)=R1;
M(1:3,4)=t1;
M(4,:)=[0,0,0,1];
end
    