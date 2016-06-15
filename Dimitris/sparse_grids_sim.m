%% Stochastic Collocation on Sparse Grids 
clear; %clc;
format long;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Preliminaries
% bonding wire length function
bw_lengths = @(delta) 1e-3*[1.60,1.69,0.97,0.90,1.51,1.35,1.32,1.42, ...
                            0.88,0.94,1.7,1.6]./(1-delta);
% num. RVs & choice of distribution 
N = 12;
uniform_dist = [0.17-3*0.048, 0.17+3*0.048];

%% Sparse grid creation                        
% quadrature level, sparse grid rule 
w = 2;
rule = 'SM'  % TP, TD, HC, SM
% create sparse grid
[S, Sr] = sparse_grid_create(N,w,uniform_dist,rule);
% number of collocation points
M_colloc = size(Sr.knots, 2)

%% evaluate on sparse grid, save/load data 
% folder/file to store/load data
folder_id = pwd;
file_id = strcat(folder_id, '\sg_data_w',num2str(w),rule, '.mat');

if(~exist(file_id))
    disp('file does not exist')
    g_eval = zeros(1,M_colloc);  
    for i = 1:M_colloc                     
        i
        g_eval(i) = run_bw_temp(bw_lengths(Sr.knots(:,i)'));
    end
    save(file_id,'g_eval');
else
    disp('file already exists')
    load(file_id,'g_eval');
end

%% surrogate model and original model
% gN = @(z) interpolate_on_sparse_grid(S,Sr,g_eval,z);
% g = @(z) run_bw_temp(bw_lengths(z'));
 
%% compute mean & std values
mean_gN = sum(g_eval.*Sr.weights)
std_gN = sqrt(sum(((g_eval-mean_gN).^2) .* Sr.weights))
