function [ noisy_RotTran ] = noisy_input( RotTran ,noisyRate )
%NOSIY_INPUT ÃÉÌØ¿¨ÂŞÌí¼ÓÔëÉù
%   noise Rot only (for now)

column=size(RotTran,2);
indicator=(rand(3,column).*2-1).*noisyRate+1;
noisy_RotTran=[indicator.*RotTran(1:3,:);RotTran(4:6,:)];
end

