function   Model=assemble(id1,Model,TData)

MData= Model(:,id1:end);
Model(:,id1:end)= [];
Model= [Model,TData,MData];