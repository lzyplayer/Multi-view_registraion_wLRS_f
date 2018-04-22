function [ Motion ] = initialiseM( num,RotTran )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Motion{1}=eye(4);
for i=2:num
    R= OulerToRota(RotTran(1:3,i-1));
    t= RotTran(4:6,i-1);
    Motion{i}=Rt2M(R,t);      
end

