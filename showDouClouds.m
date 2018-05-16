clc 
clear all
close all
load bunny;
load RotTranB;
shape=bunny(:,1);
for i=1:length(shape)
scan{i}=1000*shape{i};
scan{i}=[scan{i}';ones(1,length(scan{i}))];
end

Rottran=RotTranB;
% showMotion=Motion{4};
toshowModel=4;
toshowData=9;
%% kd-tree
    model=scan{toshowModel}(1:3,1:10:end);
    ns=createns(model','nsmethod','kdtree');
%     MSEs{i}=cal_mMSEs(model); 

%% relativeMotion
    rot1=OulerToRota(Rottran(1:3,toshowModel-1));
    tran1=Rottran(4:6,toshowModel-1);
    Motion1(1:3,1:3)=rot1;
    Motion1(1:3,4)=tran1;
    Motion1(4,4)=1;
    rot2=OulerToRota(Rottran(1:3,toshowData-1));
    tran2=Rottran(4:6,toshowData-1);
    Motion2(1:3,1:3)=rot2;
    Motion2(1:3,4)=tran2;
    Motion2(4,4)=1;
    relativeMotion=(Motion1)\Motion2;
    
%% trimmedICP
    Model=scan{toshowModel}(:,1:10:end);
    Data=scan{toshowData}(:,1:10:end);
    [updatedM, Pe]= myTrimICP(ns,Model, Data,relativeMotion, 20,0.3); % The Trimmed ICP   
    resultD=updatedM*scan{toshowData};
     plot3(resultD(1,:),resultD(2,:),resultD(3,:),'.c');
     hold on
     figure;
    plot3(scan{toshowModel}(1,:),scan{toshowModel}(2,:),scan{toshowModel}(3,:),'.b');
    hold on
    
    