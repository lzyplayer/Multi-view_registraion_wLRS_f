function [Imax,X,A]= updata(A, updatedM, Trs, MID, overlapRate, Trim, dTrim)

knum= size(updatedM,2);
scannum= size(overlapRate,1);
X= eye(4*scannum);                      % To store the TrICP results for some scan pairs.
for k=1:knum  
    i=MID(k,1);
    j=MID(k,2);
    Motion= updatedM{k};
    ii= i-1;
    jj= j-1;
    X(4*ii+1:4*ii+4,4*jj+1:4*jj+4)= Motion;                     % Update X
    A(i,j)= Trs(k);
%     if ((A(j,i)==0)&(overlapRate(j,i)>Trim-dTrim))
%         A(j,i)= Trs(k);
%         X(4*jj+1:4*jj+4,4*ii+1:4*ii+4)= inv(Motion);
%     end  
end

Imax = max(max(A));
A = A/Imax;
% for i=1:scannum
%     A(i,i) = 1;
% end