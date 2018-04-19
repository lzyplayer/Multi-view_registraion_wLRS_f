function [X,A]= filling(updatedM, MID, A, scannum)

knum0= size(updatedM,2);
knum= knum0;

% %-----------------related element filling-------------- 
ids= MID(:,1);
for i=1:knum0
    id= MID(i,2);
    ii= MID(i,1);
    js= find(ids==id);
    for k=1:length(js);
        jj= MID(js(k),2);
        if (A(ii,jj)==0)
            A(ii,jj)= 1;
            knum= knum+1;
            j= js(k);
            updatedM{knum}= updatedM{i}*updatedM{j};
            MID(knum,:)=[ii,jj];
        end
    end
end
%-----------------related element filling-------------- 

% % --------------Symmetry filling--------------- 
% knum0= knum;
for i=1:knum0
    ii=MID(i,1);
    jj=MID(i,2);
    if ((A(jj,ii)==0))
        knum= knum+1;
        A(jj,ii)= 1;
        updatedM{knum}= inv(updatedM{i});
        MID(knum,:)=[jj,ii];
    end
end
% % --------------Symmetry filling---------------   
    
X= eye(4*scannum);                                             % To store the TrICP results for some scan pairs.
for k=1:knum  
    i=MID(k,1);
    j=MID(k,2);
    ii= i-1;
    jj= j-1;
    X(4*ii+1:4*ii+4,4*jj+1:4*jj+4)= updatedM{k};                     % Update X
end
