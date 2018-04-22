function mMSEs= cal_mMSEs(scan)

Model= scan;
NS = createns(Model');
[corr,TD] = knnsearch(NS,Model','k',2);%k=2自己和自己比,保留最近两个点
mMSEs=(mean(TD(:,2).^2));  %和自己最近的点距离的平均值
% mMSEs=sqrt(mean(TD(:,2)))*2;
