function  err= comErr(preMotion,Motion,N)
err= 0;
for i=1:N
    R0= preMotion{i}(1:3,1:3);
    R= Motion{i}(1:3,1:3);
    err= sum(sum(abs(R-R0))')+err;
end
end