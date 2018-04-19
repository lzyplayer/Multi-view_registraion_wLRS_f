[len,~]=size(MID);
for i=1:len
    result(MID(i,1),MID(i,2))=1;
end
result=full(result)