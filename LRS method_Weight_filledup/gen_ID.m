function   [id1,id2]= gen_ID(Pnum,i)

id1= sum(Pnum(1,1:(i-1)))+1;
id2= id1+ Pnum(i)-1;