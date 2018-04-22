function  ObjV= com_objv( Motion, ns, scan,res)
%计算 一种目标函数值的和
N= length(scan);
Model= [];
Pnum= [];
for i=1:N
  TData = Motion{i}*scan{i}(:,1:res:end);
  num= size(TData,2);
  Pnum= [Pnum,num];
  Model=[Model,TData];
end

ObjV= 0;
for i=1:N
    if (i==1)
        id1= 1;
        id2= Pnum(1);
    else
        [id1,id2]= gen_ID(Pnum,i);
    end
    Data=  Model(:,id1:id2);
    Model(:,id1:id2)= [];   %  删除后再拼到队尾，方便取下一点云
    objvi= obj_i(Model,Data);
    ObjV= ObjV+ objvi;
    Model= assemble(id1,Model, Data);
end
 

function  minPhi= obj_i(Model,TData)
TrMin= 0.35;
TrMax= 1;
NS = createns(Model');
[corr,TD] = knnsearch(NS,TData');%这比较的是什么呢？
%[corr,TD] = knnsearch(ns,TData);
SortTD2 = sortrows(TD.^2); % Sort the correspongding points
minTDIndex = floor(TrMin*length(TD)); % Get minismum index of TD
maxTDIndex = ceil(TrMax*length(TD)); % Get maxmum index of TD
TDIndex = [minTDIndex : maxTDIndex]';
mTr = TDIndex./length(TD);
mCumTD2 = cumsum(SortTD2); % Get accumulative sum of sorted TD.^2
mMSE = mCumTD2(minTDIndex : maxTDIndex)./TDIndex; % Compute all MSE
mPhi = ObjectiveFunction(mMSE, mTr);
[minPhi, nIndex] = min(mPhi);