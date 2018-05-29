function [ data_withOutliers ] = PC_outliers_input( data, strongage )
%OUTLIERS_INPUT 此处显示有关此函数的摘要
%   此处显示详细说明
maxX=0;
maxY=0;
maxZ=0;
for i=1:length(data)
curmaxX=max(data{i}(1,:));
curmaxY=max(data{i}(2,:));
curmaxZ=max(data{i}(3,:));
if (curmaxX>maxX)
    maxX=curmaxX;
end
if (curmaxY>maxY)
    maxY=curmaxY;
end
if (curmaxZ>maxZ)
    maxZ=curmaxZ;
end

    for j=1:length(data{i})*strongage
        data{i}=[data{i},[rand()*maxX ; rand()*maxY;rand()*maxZ]];
    end


end
end

