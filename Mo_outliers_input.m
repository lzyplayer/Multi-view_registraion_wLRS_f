function [ Outlier_Motion ] = Mo_outliers_input( Motion, percentage )
%OUTLIERS_INPUT 此处显示有关此函数的摘要
%   此处显示详细说明
maxX=0;
maxY=0;
maxZ=0;
motionNum=max(size(Motion,1),size(Motion,2));
for i=1:motionNum
curX=abs(Motion{i,1}(1,4));
curY=abs(Motion{i,1}(2,4));
curZ=abs(Motion{i,1}(3,4));
if (curX>maxX)
    maxX=curX;
end
if (curY>maxY)
    maxY=curY;
end
if (curZ>maxZ)
    maxZ=curZ;
end
end

Outlier_Motion=Motion;
for j=1:motionNum*percentage
        i=floor(rand()*(motionNum+1));
        outRot=OulerToRota([(2*rand()-1)*pi;(2*rand()-1)*pi;(2*rand()-1)*pi]);
        outlier_motion=[outRot,[(2*rand()-1)*maxX ; (2*rand()-1)*maxY;(2*rand()-1)*maxZ]];
        outlier_motion=[outlier_motion;0 0 0 1]
        Outlier_Motion{i,1}=outlier_motion;
end

end

