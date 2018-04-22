

function [M,R,T] = MijtoMi(X,ncams)

% Projection onto SO(3)
M = zeros(4,4,ncams);
R = zeros(3,3,ncams);
T = zeros(3,ncams);

for i=1:ncams
    
    Mi=X(1:4,4*i-3:4*i);
    Mi=Mi/Mi(4,4);
    Mi(4,1:3)=0;
    
    % compute the nearest rotation matrix
    [u,~,v]=svd(Mi(1:3,1:3));
    Mi(1:3,1:3)=u*diag([1,1,det(u*v')])*v';
    
    M(:,:,i)=Mi;
    R(:,:,i)=Mi(1:3,1:3);
    T(:,i)=Mi(1:3,4);
    
end

end