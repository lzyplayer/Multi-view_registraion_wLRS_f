clc
clear
clear GLOBAL 
clear FUNCTIONS
%clear all
close all
%% �ȼ���ģ�ͳ�ʼ������
%crossTime=0;
Trim = 0.4;
res = 10;
lamda=2;
iterationThreshlod= 20;
    load bunny;
    %load dragon;
% load Chicken;
    load RotTranB;
    %load happy;
shape = bunny;
RotTran = RotTranB;
scannum=length(shape);
scan=shape(:,1);
RotTran(1:3,:) = RotTran(1:3,:) + 0.05;%������
for i=1:scannum
    scan{i}=1000*scan{i};
end
Motion = initialiseM(scannum,RotTran);

% scan=shape;
% scannum=size(shape,1);
% for i=1:scannum
% Motion{i} = p(i).M;
% end
[scan,Mshape]=obtainShape(scan,Motion,0);%ʹ�ó�ʼ������ʾ����״�����滯scan

%% ����kd��

for i=1:scannum
    model=scan{i}(1:3,1:10:end);
    ns{i}=createns(model','nsmethod','kdtree');
    MSEs{i}=cal_mMSEs(model); 
end

%% ����
iter=0;
err= 10;
ERROR= (length(scan)-1)*90*10^(-5);
tic
while(iter<iterationThreshlod)&&(err>ERROR)
    iter= iter+1;
    %% calculate  overlap rate
    if (iter<3)     %ֻ��ǰ2��
        overlapRate=overlapRateEveluation(scan,Motion,res,lamda,ns);  % Estimate the overlap between each scans.
    end
    MID=[];
    [MID,A,ac_num]= LRSdecij(overlapRate, scannum, Trim);
    num=ac_num;
    updatedM={};
    weight=[];
    for k=1:ac_num
        i=MID(k,1);
        j=MID(k,2);    %MID����ȷƥ��ĵ��
        relativeMotion=inv(Motion{i})*Motion{j};
        Model=scan{i}(:,1:res:end);
        Data=scan{j}(:,1:res:end);
        [updatedM{k}, Pe]= myTrimICP(ns{i},Model, Data,relativeMotion, iterationThreshlod,Trim); % The Trimmed ICP   
        weight(k)= MSEs{i}/(Pe^2);% Ȩ��      updatedM{k}Ϊ���н���ƥ��ĸ��º������˶�����  ��dragon��91��
    %% ����˶���ԳƲ���
       if A(j,i)~=1
           num=num+1;
           updatedM{num}=inv(updatedM{k});
           A(j,i)=1;
          MID=[MID;[j,i]];
           weight(num)=weight(k);
       end  
    end 
    %% ����Ȩ�ؿ�WIJ
    W=deal_weight(weight,MID); 
    
   
    
    %% lrs
    [X,A]= LRSupdate(A, updatedM, MID, overlapRate);    % Obtain X and A   
     %lrsupdate�ǽ�icp��������µ�����˶�����
    
     %% ��˲�ȫ
    % t1=clock;
   [X,A,W]=CrossCompletion(X,A,W);
    %t2=clock;
   % crossTime=crossTime+etime(t2,t1);
    %  [Imax,X,A]= updata(A, updatedM, Trss, MID, overlapRate, Trim, dTrim);                      
    [M,R,T] = SE3_LRS(X,W,'l1alm');
    preMotion= Motion;
    for i=1:scannum
        Motion{i}=inv(M(:,:,1))*M(:,:,i);
    end
    err=comErr(preMotion,Motion,length(scan));
    
    
end
toc
iter
ObjV= com_objv( Motion, ns, scan,res)/scannum  
[scan,Mshape]=obtainShape( scan,Motion ,1); 
 crosssection(Mshape,1,37.4,37.8);    %chicken
% crosssection(Mshape,2,99.8,100.2);     %dragon      
 %crosssection(Mshape,1,-20.1,-19.8);    %bunny