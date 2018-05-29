

function [M,R,T] = SE3_LRS(X,A,method)
%
% Estimate global rigid motions by averaging relative motions in SE(3)
% using Low-rank & Sparse Matrix Decomposition
% Note: each relative/absolute motion is represented as a 4x4 matrix 
%
% Author: Federica Arrigoni, 2016
% Reference:
% F. Arrigoni, B. Rossi, A. Fusiello, Global Registration of 3D point sets
% via LRS Decomposition, European Conference on Computer Vision (ECCV),
% 2016.
%
% OUTPUT
% M = 4x4xn matrix with absolute motions
% R = 3x3xn matrix with absolute rotations
% T = 3xn matrix with absolute translations
%
% INPUT
% X = 4n x 4n matrix with pairwise motions
% A = nxn adjacency matrix of the view-graph
% method = 'rgodec' -> use the R-GoDec Algorithm
% method = 'l1alm' -> use the L1-Alm Algorithm
% method = 'grasta' -> use the Grasta Algorithm
%
% REFERENCES
% R-GoDec
% F. Arrigoni, L. Magri, B. Rossi, P. Fragneto, A. Fusiello. Robust
% absolute rotation estimation via Low-rank and Sparse Matrix
% Decomposition, International Conference on 3D Vision (3DV), 2014.
%
% Grasta
% J. He, L. Balzano, A. Szlam, Incremental gradient on the Grassmannian for
% online foreground and background separation in subsampled video, IEEE
% Conference on Computer Vision and Pattern Recognition, 2012.
%
% L1-Alm
% Y. Zheng, G. Liu, S. Sugimoto, S. Yan, M. Okutomi, Practical low-rank
% matrix approximation under robust L1-norm, IEEE Conference on Computer
% Vision and Pattern Recognition, 2012.
%


nviews = size(X,1)/4; % number of local reference frames (cameras/sensors/scans)
rank_MC = 4;

%A=sparse(A);
%X=sparse(X);
%X=X.*kron(A,ones(4));


% Normalization (so as to bring translation coordinates to have values
% comparable to rotation entries)

[I,J]=find(triu(A,1));
n_pairs=length(I);

factors=zeros(n_pairs,1);
for k=1:n_pairs
    i=I(k); j=J(k);
    tij=X(4*i-3:4*i-1,4*j);
    factors(k)=norm(tij); %每对儿配准平移部分的大小
end

global_scale=max(factors);  
%global_scale=norm(factors)
%global_scale=mean(factors)

X_normalized=X;
for k=1:n_pairs
    i=I(k); j=J(k); 
    X_normalized(4*i-3:4*i-1,4*j)=X(4*i-3:4*i-1,4*j)/global_scale;
    X_normalized(4*j-3:4*j-1,4*i)=X(4*j-3:4*j-1,4*i)/global_scale;
end
X=X_normalized;

% put 1 in position (4,4) in each 4x4 block
X=X+kron(not(A|eye(size(A,1))),[0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 1]);


if strcmp(method,'rgodec') % R-GoDec
    
    % Parameters
    
    power=10;
    iter_max = 100;
    thresh = 1e-5;
    lambda = 0.02* sqrt(2*log(n_pairs*16)); % default value for SE(3)
    
    % LRS Decomposition
    [L,S,status]=R_GoDec_mixed(X,rank_MC,lambda,power,iter_max,thresh);
    
elseif strcmp(method,'grasta') % Grasta
    
    % Parameters
    
    numr = 4*nviews;
    numc = 4*nviews;
    
    OPTIONS.RANK                = rank_MC; % give your estimated rank
    OPTIONS.USE_MEX             = 0;
    OPTIONS.QUIET               = 1;     % suppress the debug information
    OPTIONS.DIM_M               = numr;  % your data's ambient dimension
    
    maxCycles                   = 10;    % the max cycles of robust mc
    
    OPTIONS.MAX_LEVEL           = 20;    % For multi-level step-size,
    OPTIONS.MAX_MU              = 15;    % For multi-level step-size
    OPTIONS.MIN_MU              = 1;     % For multi-level step-size
    
    OPTIONS.ITER_MIN            = 20;    % the min iteration allowed for ADMM at the beginning
    OPTIONS.ITER_MAX            = 20;    % the max iteration allowed for ADMM 20
    OPTIONS.rho                 = 2;     % ADMM penalty parameter for acclerated convergence
    OPTIONS.TOL                 = 1e-8;  % ADMM convergence tolerance
    
    CONVERGE_LEVLE              = 20;    % If status.level >= CONVERGE_LEVLE, robust mc converges
    
    % LRS Decomposition
    [I_MC,J_MC,S_MC] = find(X);
    
    % Compute an initial datum by propagating the relative motions along a
    % spanning tree
    [~,~,~,U0] = initialization_ST(X,A);
    
    % Compute an order in which columns will be processed based on the number
    % of observed entries
    [~,col_order]=sort(sum(X),'descend');

    [Usg, Vsg, Osg] = grasta_mc_initialization(I_MC,J_MC,S_MC,numr,numc,maxCycles,CONVERGE_LEVLE,OPTIONS,U0,col_order);

    %[Usg, Vsg, Osg] = grasta_mc(I_MC,J_MC,S_MC,numr,numc,maxCycles,CONVERGE_LEVLE,OPTIONS);
    
    L=Usg*Vsg';

    
elseif strcmp(method,'l1alm') % L1-ALM
    
    % Parameters
    
    lambda_ALM = 1e-3; % weighting factor of trace-norm regularization
    rho_ALM = 1.2; % increasing ratio of the penalty parameter mu % 1.05 1.2
    maxIterIN = 1; % maximum iteration number of inner loop & 100
    signX = 0; % if X>= 0, then signX = 1, otherwise, signX = 0;
    
    % Compute sampling set
    
    %Omega=spones(X); 
    %Omega=Omega|kron(ones(nviews),[0 0 0 0;0 0 0 0;0 0 0 0;1 1 1 0]);
    %Omega=Omega|kron(eye(nviews),ones(4));
    W=kron(A,ones(4));
    % LRS Decomposition
    
    [L,U,V,err]=RobustApproximation_M_UV_TraceNormReg(X,W,rank_MC,lambda_ALM,rho_ALM,maxIterIN,signX);
   % [L,U,V,err]=RobustApproximation_M_UV_TraceNormReg(X,W,rank_MC,lambda_ALM,rho_ALM,maxIterIN,signX);

else
    error('Unknown method')
end


% Extract absolute motions from the optimal L and project 4x4 blocks onto SE(3)
[M,R,T] = MijtoMi(full(L),nviews);

T=T*global_scale; M(1:3,4,:)=M(1:3,4,:)*global_scale;

end


