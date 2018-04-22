function  [M, Trim, MSEi] = TrimmedICP(ns, model,data,initialMotion,id,iterationThreshlod,lamda)
%global ns    %M 是运动矩阵Trim是重叠百分比（裁剪百分比）MSEi是当前目标函数取极小值时的（距离和/点数量
TrMin= 0.3; 
TrMax= 1.0;
PreMSE= 10^5;   CurMSE= 10^6;  step = 1;             %MSE指的是目标函数极值???？
scan=initialMotion*data;
while(step < iterationThreshlod)&(abs(CurMSE-PreMSE)>10^(-6))     %两个限制，迭代周期数与前后两次迭代的目标函数值差距
    [corr,TD] = knnsearch(ns{id},scan(1:3,:)');      % ’是转置      %kd树搜索最近点 前者为模型点云kd树，后者为初始变换后的数据点云
    %knnsearch返回的是2列矩阵 corr是对应最近点 TD是距离？
    SortTD2 = sortrows(TD.^2); % Sort the correspongding points    点排序，这样排了 corr也会同时改变么？
    minTDIndex = floor(TrMin*length(TD)); % Get minimum index of TD
    maxTDIndex = ceil(TrMax*length(TD)); % Get maxmum index of TD    
    TDIndex = [minTDIndex : maxTDIndex]';%选中最小百分比最大百分比间所有点
    mTr = TDIndex./length(TD);
    mCumTD2 = cumsum(SortTD2);  %对点对的距离递加，每个数值表示裁剪到这一点时误差距离和
    mMSE = mCumTD2(minTDIndex : maxTDIndex)./TDIndex;
    mPhi = ObjectiveFunction(mMSE, mTr);  %那个公式
    PreMSE=CurMSE;
    [CurMSE, nIndex] = min(mPhi); 
%     MSEi= mMSE(nIndex);
    MSEi= sqrt(mMSE(nIndex));      % 裁剪ICP目标函数分子部分，使目标函数取最小值的那部分距离和除以距离的个数
    Trim = mTr(nIndex); % Update Tr for next step    是裁剪量么？？
    corr(:,2) = [1 : length(corr)]';%给corr加一列序号在右侧
    % Sort the corresponding points
    corrTD = [corr, TD];%corrTD矩阵  N * 3
    SortCorrTD = sortrows(corrTD, 3);%依据最近点距离排列
    [M, TCorr, scan] = CalRtPhi(model, data, SortCorrTD, Trim);    %M是运动矩阵集合
    step= step+1;
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
