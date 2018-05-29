% trimmedModel=Model(1:3,TCorr(:,1));
% trimmedData=scan(1:3,TCorr(:,2));
% 
% plot3(trimmedModel(1,:),trimmedModel(2,:),trimmedModel(3,:),'.b')%在ICP算法中使用得到双视点配准演示图
% hold on
% plot3(trimmedData(1,:)+4,trimmedData(2,:)+4,trimmedData(3,:)+4,'.m')
% hold on
% for i=100:size(TCorr,1)
%     if mod(i,300)==0
%         X1=[trimmedData(1,i)+4,trimmedModel(1,i)];
%         Y1=[trimmedData(2,i)+4,trimmedModel(4,i)];
%         Z1=[trimmedData(3,i)+4,trimmedModel(3,i)];
%        plot3(X1,Y1,Z1,'-.*k');
%     end
% end

        
plot3(curNs.X(:,1)',curNs.X(:,2)',curNs.X(:,3)','.b')%在ICP算法中使用得到双视点配准演示图
hold on

plot3(scan(1,:)+0,scan(2,:)+0,scan(3,:)+0,'.m')
hold on

for i=1:length(corr)
   
        X1=[scan(1,i)+0,curNs.X(corr(i,1),1)'];
        Y1=[scan(2,i)+0,curNs.X(corr(i,1),2)'];
        Z1=[scan(3,i)+0,curNs.X(corr(i,1),3)'];
       plot3(X1,Y1,Z1,'-k');
   
end