function [ Wij ] = deal_weight( weight_list,motion_pairID )
%处理权重得到带权重的指示阵
%   此处显示详细说明


%% weighted indicator matrix
[len]=size(motion_pairID,1);
for i=1:len
    Wij(motion_pairID(i,1),motion_pairID(i,2))=weight_list(i);      %把权重按表填入
end

%% normalise

max_weight=max(max(Wij));
Wij=Wij./max_weight;
%Wij=kron(Wij,ones(4));
%Wij=full(Wij);

%% dia    处理对角线元素
[scannum]=size(Wij,1);
for i=1:scannum
    Wij(i,i)=1;
end


end

