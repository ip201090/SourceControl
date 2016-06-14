% Copyright (c) 2015 Andreas Pels

function [uFinal, sp, geometry, gnum, msh] = solveGeoPDEsFieldCircuitCoupling( geometryAddress, current )
%SOLVEGEOPDESFIELDCIRCUITCOUPLING Summary of this function goes here
%   Detailed explanation goes here

drchlt_sides = [3];
couplingSide = [4];

% Neumann boundary sides are zero ==> Directly set to zero, see below
%nmnn_sides   = [1 2];
% B_color_vector = [0 1.2];

% Build geometry for the laplace solver
problem_data.geo_name=geometryAddress;
%problem_data.nmnn_sides=nmnn_sides;
problem_data.drchlt_sides=drchlt_sides;
problem_data.c_diff=@(x, y, patch, iel, npatch, nel_dir) inversePermeability(x,y, patch, iel, npatch, nel_dir);
%problem_data.f=@(x, y) zeros(size(x));
%problem_data.g=@(x, y, ind) zeros(size(x));
problem_data.hUpper=@(x, y, ind, bnd_side, max_side) readBCFromFEMM(x, y, bnd_side, max_side);
problem_data.hLower=@(x, y, ind, bnd_side, max_side) zeros(size(x));

% Construct geometry structure, and information for interfaces and boundaries
[geometry, boundaries, interfaces] = mp_geo_load (problem_data.geo_name);
npatch = numel (geometry);

method_data.nquad=[5 5]; 
%method_data.nquad=[3 3]; 
method_data.nsub=[1 1];
method_data.regularity=method_data.nquad-2;
method_data.degree=method_data.nquad-1;

msh = cell (1, npatch);
sp = cell (1, npatch);
for iptc = 1:npatch
    
    % Define the refined mesh, with tensor product structure
    [knots{iptc}, zeta{iptc}] = ...
        kntrefine (geometry(iptc).nurbs.knots, method_data.nsub-1, method_data.degree, method_data.regularity);
    
    % Compute the quadrature rule
    rule      = msh_gauss_nodes (method_data.nquad);
    [qn, qw]  = msh_set_quad_nodes (zeta{iptc}, rule);
    msh{iptc} = msh_2d (zeta{iptc}, qn, qw, geometry(iptc));
    
    % Evaluate the discrete space basis functions in the quadrature points
    sp{iptc} = sp_bspline_2d (knots{iptc}, method_data.degree, msh{iptc});
    %createDegree1Space;
    
    %sp{iptc} = sp_bspline_2d(unique(knots(iptc)))
end

% Create a correspondence between patches on the interfaces
[gnum, ndof] = mp_interface_2d (interfaces, sp);

% Compute and assemble the matrices
rhs = zeros (ndof, 1);

ncounter = 0;
for iptc = 1:npatch
    [rs, cs, vs] = mp_op_gradu_gradv_tp (sp{iptc}, sp{iptc}, msh{iptc}, problem_data.c_diff, iptc, npatch);
    
    rows(ncounter+(1:numel (rs))) = gnum{iptc}(rs);
    cols(ncounter+(1:numel (rs))) = gnum{iptc}(cs);
    vals(ncounter+(1:numel (rs))) = vs;
    ncounter = ncounter + numel (rs);
    
    % No current is flowing in model ==> Right hand-side is zero
    %rhs_loc = op_f_v_tp (sp{iptc}, msh{iptc}, problem_data.f);
    %rhs(gnum{iptc}) = rhs(gnum{iptc}) + rhs_loc;
end

stiff_mat = sparse (rows, cols, vals, ndof, ndof);

% Neumann boundary part is zero ==> There is no treatment needed.
% for iref = problem_data.nmnn_sides
%   for bnd_side = 1:boundaries(iref).nsides
%     iptc = boundaries(iref).patches(bnd_side);
%     iside = boundaries(iref).faces(bnd_side);
%     msh_side = msh_eval_boundary_side (msh{iptc}, iside);
%     sp_side  = sp_eval_boundary_side (sp{iptc}, msh_side);
%
%     x = squeeze (msh_side.geo_map(1,:,:));
%     y = squeeze (msh_side.geo_map(2,:,:));
%
%     gval = reshape (problem_data.g (x, y, iref), msh_side.nqn, msh_side.nel);
%     rhs_nmnn = op_f_v (sp_side, msh_side, gval);
%
%     global_dofs = gnum{iptc}(sp_side.dofs);
%     rhs(global_dofs) = rhs(global_dofs) + rhs_nmnn;
%   end
% end

% Apply Dirichlet boundary conditions
u = zeros (ndof, 1);
[u_drchlt, drchlt_dofs] = mp_sp_drchlt_l2_proj (sp, msh, problem_data.hLower, gnum, boundaries, problem_data.drchlt_sides);
u(drchlt_dofs) = u_drchlt;

int_dofs = setdiff (1:ndof, drchlt_dofs);
rhs(int_dofs) = rhs(int_dofs) - stiff_mat(int_dofs, drchlt_dofs)*u_drchlt;

% Find indices of the DOFs on the top boundary and find their values to
% obtain the desired boundary condition
[u_Top, Top_dofs] = mp_sp_drchlt_l2_proj (sp, msh, problem_data.hUpper, gnum, boundaries, couplingSide);

% Calculate flux running "into" the partial model and "norm" the boundary
% condition to that

load BCReadFluxFromFEMM.mat;
lz=0.200;
u_Top=u_Top*lz./abs(flux(1));

% Apply field-circuit coupling
% boundary4Drchlt_dofs=[];
% for iptc=1:npatch
%     boundary4Drchlt_dofs=[boundary4Drchlt_dofs,gnum{iptc}(sp{iptc}.boundary(3).dofs)];
% end
% [boundary4Drchlt_dofs, IA, IC]=unique(boundary4Drchlt_dofs);
% 
% % Boundary values
% boundaryDOFValues=setBoundaryDOFValues(geometry, boundaryCondition.x, boundaryCondition.A);
% boundaryDOFValues=boundaryDOFValues(IA);


%Value for 40 amp
RmValue=11400;
N=65;
I=current;

% Rm=zeros(space.ndof,space.ndof);
% ICoil=zeros(space.ndof,1);
% for n=1:length(boundary4Drchlt_dofs)
%     Rm(boundary4Drchlt_dofs(n),boundary4Drchlt_dofs(n))=RmValue;
%     ICoil(boundary4Drchlt_dofs(n),1)=N*I;
% end
%Rm(boundary4Drchlt_dofs,boundary4Drchlt_dofs)=RmValue;

lz=0.200;
bdry4Drchlt_ndofs=length(Top_dofs);

% Create diagonal matrix as left matrix, add column in the end for coupling
% to flux
%addMatRight=[diag(ones(ndof-bdry4Drchlt_ndofs,1)), zeros(ndof-bdry4Drchlt_ndofs,1)];
addMatRight=spalloc(ndof,ndof-bdry4Drchlt_ndofs+1,ndof);
addMatRightUniform=spalloc(ndof,ndof-bdry4Drchlt_ndofs+1,ndof);

% Insert rows where necessary
newInt_dofs=setdiff(int_dofs, Top_dofs);

counter=1;
for i=1:ndof
    index=find(Top_dofs==i, 1);
    if(~isempty(index))
        %addMatRight=[addMatRight(1:boundary4Drchlt_dofs(i)-1,:); [zeros(1, ndof-bdry4Drchlt_ndofs),1./lz]; addMatRight(boundary4Drchlt_dofs(i):end,:)];
        addMatRight(i,end)=u_Top(index);
        addMatRightUniform(i,end)=1;
    else
        addMatRight(i,counter)=1;
        addMatRightUniform(i,counter)=1;
        counter=counter+1;
    end
end

% Rebuild degrees of freedom taking into account the missing lines in the
% equation system
for i=bdry4Drchlt_ndofs:-1:1
    indize=newInt_dofs>Top_dofs(i);
    newInt_dofs(indize)=newInt_dofs(indize)-1;
end
newInt_dofs(end+1)=ndof-bdry4Drchlt_ndofs+1;


addMatLeft=addMatRightUniform.';
%addMatLeft(end,[7 8 9])=lz;

matrix=addMatLeft*stiff_mat*addMatRight;

Rm=spalloc(size(matrix,1), size(matrix,2), 1);
Rm(end, end)=RmValue*lz;
ICoil=zeros(size(matrix,1),1);
ICoil(end)=N*I;
% teta=0.054*1./(relPerme*4*pi*1e-7)*1./(0.200*0.020);
% tetaThird=teta./3;


%matrix=[matrix(1:6,:); 0 0 0 0 0 0 tetaThird tetaThird tetaThird; 0 0 0 0 0 0 tetaThird tetaThird tetaThird; 0 0 0 0 0 0 tetaThird tetaThird tetaThird];
% matrix=[matrix(1:6,:); 0 0 0 0 0 0 tetaThird tetaThird tetaThird; 0 0 0 0 0 0 tetaThird tetaThird tetaThird; 0 0 0 0 0 0 tetaThird tetaThird tetaThird]
matrix=matrix+Rm;
% matrix(1:6,8)=matrix(1:6,8)*2;
% matrix(1:6,9)=matrix(1:6,9)*3;

% Reduce system of equations
% columns=sum(matrix(:, boundary4Drchlt_dofs),2);
% finalBoundary_dofs=boundary4Drchlt_dofs(1);
% restBoundary_dofs=boundary4Drchlt_dofs(2:end);
%
% newMatrix=matrix;
% newMatrix(:,finalBoundary_dofs)=columns;
u=zeros(size(matrix,2), 1);
u(newInt_dofs)=matrix(newInt_dofs, newInt_dofs)\ICoil(newInt_dofs);
% u(int_dofs)=matrix(int_dofs, int_dofs)\ICoil(int_dofs);
%u=matrix\ICoil;
% u(restBoundary_dofs)=u(finalBoundary_dofs);
uFinal=addMatRight*u;



% B_color_vector = [0 1.2];
%
% figure
% title('B-field, X direction');
% hold on;
%
% % Left patch
% [euL, FL]=sp_eval(uFinal(gnum{1}), sp{1}, geometry(1), [80 80], 'gradient');
% [X, Y]  = deal(squeeze(FL(1,:,:)), squeeze(FL(2,:,:)));
% gradientXL(:,:)=euL(1,:,:);
% surf(X, Y, abs(gradientXL)*1000, 'EdgeColor', 'none','FaceColor','interp'); % *1000 to get Wb/m^2
% view(2);
%
% % Right patch
% [euM, FM]=sp_eval(uFinal(gnum{2}), sp{2}, geometry(2), [80 80], 'gradient');
% [X, Y]  = deal(squeeze(FM(1,:,:)), squeeze(FM(2,:,:)));
% gradientXM(:,:)=euM(1,:,:);
% surf(X, Y, abs(gradientXM)*1000, 'EdgeColor', 'none','FaceColor','interp'); % *1000 to get Wb/m^2
% view(2);
%
% % Middle patch
% [euR, FR]=sp_eval(uFinal(gnum{3}), sp{3}, geometry(3), [80 80], 'gradient');
% [X, Y]  = deal(squeeze(FR(1,:,:)), squeeze(FR(2,:,:)));
% gradientXR(:,:)=euR(1,:,:);
% surf(X, Y, abs(gradientXR)*1000, 'EdgeColor', 'none','FaceColor','interp'); % *1000 to get Wb/m^2
% view(2);
% caxis(B_color_vector);
%
%
% figure
% title('Vector potential');
% hold on;
%
% % Left patch
% [euL, FL]=sp_eval(uFinal(gnum{1}), sp{1}, geometry(1), [80 80], 'value');
% [X, Y]  = deal(squeeze(FL(1,:,:)), squeeze(FL(2,:,:)));
% surf(X, Y, euL, 'EdgeColor', 'none');
%
% % Middle patch
% [euM, FM]=sp_eval(uFinal(gnum{2}), sp{2}, geometry(2), [80 80], 'value');
% [X, Y]  = deal(squeeze(FM(1,:,:)), squeeze(FM(2,:,:)));
% surf(X, Y, euM, 'EdgeColor', 'none');
%
% % Right patch
% [euR, FR]=sp_eval(uFinal(gnum{3}), sp{3}, geometry(3), [80 80], 'value');
% [X, Y]  = deal(squeeze(FR(1,:,:)), squeeze(FR(2,:,:)));
% surf(X, Y, euR, 'EdgeColor', 'none');
%
% view(2);

end

