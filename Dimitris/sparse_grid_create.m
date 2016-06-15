% ATTENTION, only uniform distributions are supported in this script

function [S,Sr] = sparse_grid_create(N,w,dist,rule)

if strcmp(rule, 'SM')
    knots = @(n) knots_CC(n, dist(1), dist(2));
else
    knots = @(n) knots_uniform(n, dist(1), dist(2));
end

[lev2knots,idxset] = define_functions_for_rule(rule, N);
[S,~] = smolyak_grid(N,w,knots,lev2knots,idxset);
Sr = reduce_sparse_grid(S);

end
