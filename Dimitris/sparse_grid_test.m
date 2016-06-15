% Check sparse grids creation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [S_knots,S_weights,Sr_knots,Sr_weights]=sparse_grid_test(N,w,rule)
% uniform distribution
dist = [0, sqrt(3)];

% knots
if strcmp(rule, 'SM')
    knots = @(n) knots_CC(n, dist(1), dist(2));
else
    knots = @(n) knots_uniform(n, dist(1), dist(2));
end

% level2knots, index set
[lev2knots,idxset] = define_functions_for_rule(rule,N);

% create sparse grid
[S,~] = smolyak_grid(N,w,knots,lev2knots,idxset);
Sr = reduce_sparse_grid(S);
S_knots    = S.knots;
S_weights  = S.weights;
Sr_knots   = Sr.knots;
Sr_weights = Sr.weights;

end
