function [X,A] = LRSupdate(A, updatedM, Trss, MID, overlapRate, Trim)

knum= size(updatedM,2);
scannum= size(overlapRate,1);
X= eye(4*scannum);                      % To store the TrICP results for some scan pairs.
for k=1:knum
    i = MID(k,1);
    j = MID(k,2);
    ii= i-1;
    jj= j-1;
    X(4*ii+1:4*ii+4,4*jj+1:4*jj+4)= updatedM{k};                     % Update X      
    A(i,j) = 1;
end

