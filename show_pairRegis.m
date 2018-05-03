plot3(curNs.X(:,1)',curNs.X(:,2)',curNs.X(:,3)','.c')
hold on
plot3(scan(1,:)+80,scan(2,:)+80,scan(3,:)+80,'.m')
hold on
for i=100:size(corr,1)
    if mod(i,300)==0
        X1=[scan(1,i)+80,curNs.X(corr(i,1),1)];
        Y1=[scan(2,i)+80,curNs.X(corr(i,1),2)];
        Z1=[scan(3,i)+80,curNs.X(corr(i,1),3)];
       plot3(X1,Y1,Z1,'b');
    end
end