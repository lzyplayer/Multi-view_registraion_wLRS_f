function [ noisy_RotTran ] = noisy_input( RotTran ,noisyRate )
%NOSIY_INPUT 蒙特卡罗添加噪声
%   此处显示详细说明
row=size(RotTran,1);
column=size(RotTran,2);
indicator=(rand(row,column).*2-1).*noisyRate+1;
noisy_RotTran=indicator.*RotTran;
end

