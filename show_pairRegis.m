% clear all
% close all
% load temp
%% 用以展示overlapRate算法 runin Overlap->TD= [TD;TDi];  
pointList=[corr,(1:length(corr))',TD(length(TD)-size(TData,2)+1:end,:)];
pointList=sortrows(pointList,3);
maxDist=3.6790;
for count=1:length(corr)
    if pointList(count,3)>=maxDist;
        break;
    end
end
accecptDots=count;
correct=[];
for count=1:accecptDots
    correct=[correct,TData(1:4,pointList(count,2))];
end
plot3(TData(1,:),TData(2,:),TData(3,:),'.b')%在ICP算法中使用得到双视点配准演示图
hold on
plot3(correct(1,:),correct(2,:),correct(3,:),'.c')%在ICP算法中使用得到双视点配准演示图
hold on
plot3(model(1,:),model(2,:),model(3,:)+50,'.m')%在ICP算法中使用得到双视点配准演示图
hold on
% trimmedModel=Model(1:3,TCorr(:,1));
% trimmedData=scan(1:3,TCorr(:,2));
% 
% plot3(trimmedModel(1,:),trimmedModel(2,:),trimmedModel(3,:),'.b')%在ICP算法中使用得到双视点配准演示图
% hold on
% plot3(trimmedData(1,:)+80,trimmedData(2,:)+80,trimmedData(3,:)+80,'.m')
% hold on
% for i=100:size(TCorr,1)
%     if mod(i,300)==0
%         X1=[trimmedData(1,i)+80,trimmedModel(1,i)];
%         Y1=[trimmedData(2,i)+80,trimmedModel(2,i)];
%         Z1=[trimmedData(3,i)+80,trimmedModel(3,i)];
%        plot3(X1,Y1,Z1,'-.*k');
%     end
% end

        
%     plot3(curNs.X(:,1)',curNs.X(:,2)',curNs.X(:,3)','.b')%在ICP算法中使用得到双视点配准演示图
%     hold on

% plot3(scan(1,:)+80,scan(2,:)+80,scan(3,:)+80,'.m')
% hold on
errorList=pointList(accecptDots:5:end,:);
for count=1:size(errorList,1)
     if mod(count,2)==0
        X1=[model(1,errorList(count,1)),TData(1,errorList(count,2))];
        Y1=[model(2,errorList(count,1)),TData(2,errorList(count,2))];
        Z1=[model(3,errorList(count,1))+50,TData(3,errorList(count,2))];
       plot3(X1,Y1,Z1,'--k');
    end
end