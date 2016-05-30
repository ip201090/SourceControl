## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [u, space, geometry, gnum] = TestNURBSLaplaceSolverMPNonIso(geometryAddress)

drchlt_sides = [3 4];
nmnn_sides   = [1 2];
B_color_vector = [0 1.2];

geometry = mp_geo_read_nurbs(geometryAddress);

% Build geometry for the laplace solver
problem_data.geo_name=geometryAddress;
problem_data.nmnn_sides=nmnn_sides;
problem_data.drchlt_sides=drchlt_sides;
problem_data.c_diff=@(x, y, patch, iel, npatch, nel_dir) inversePermeability(x,y, patch, iel, npatch, nel_dir);
problem_data.f=@(x, y) zeros(size(x));
problem_data.g=@(x, y, ind) zeros(size(x));
problem_data.h=@(x, y, ind) dirchletBC(x, y, ind);

method_data.nquad=geometry (1).nurbs.order;
method_data.nsub=[0 0];
method_data.regularity=[1 1];
method_data.degree=geometry(1).nurbs.order-1;

[geometry, msh, space, u, gnum]=mp_solve_laplace_2d_mod(problem_data, method_data);

% mp_sp_to_vtk (u, space, geometry, gnum, [80 80], 'MPLaplaceSolution.vts', 'gradient', 'value');

%% PLOT THE X GRADIENT

figure
title('Field gradient, X direction');
hold on;

% Left patch
[euL, FL]=sp_eval(u(gnum{1}), space{1}, geometry(1), [80 80], 'gradient');
[X, Y]  = deal(squeeze(FL(1,:,:)), squeeze(FL(2,:,:)));
gradientXL(:,:)=euL(1,:,:);
surf(X, Y, abs(gradientXL)*1000, 'EdgeColor', 'none','FaceColor','interp'); % *1000 to get Wb/m^2
view(2);

% Right patch
[euM, FM]=sp_eval(u(gnum{2}), space{2}, geometry(2), [80 80], 'gradient');
[X, Y]  = deal(squeeze(FM(1,:,:)), squeeze(FM(2,:,:)));
gradientXM(:,:)=euM(1,:,:);
surf(X, Y, abs(gradientXM)*1000, 'EdgeColor', 'none','FaceColor','interp'); % *1000 to get Wb/m^2
view(2);

% Middle patch
[euR, FR]=sp_eval(u(gnum{3}), space{3}, geometry(3), [80 80], 'gradient');
[X, Y]  = deal(squeeze(FR(1,:,:)), squeeze(FR(2,:,:)));
gradientXR(:,:)=euR(1,:,:);
surf(X, Y, abs(gradientXR)*1000, 'EdgeColor', 'none','FaceColor','interp'); % *1000 to get Wb/m^2
view(2);
caxis(B_color_vector);
% 
% %% PLOT THE Y GRADIENT
% 
% figure
% title('Field gradient, Y direction');
% hold on;
% 
% % Left patch
% [euL, FL]=sp_eval(u(gnum{1}), space{1}, geometry(1), [80 80], 'gradient');
% [X, Y]  = deal(squeeze(FL(1,:,:)), squeeze(FL(2,:,:)));
% gradientYL(:,:)=euL(2,:,:);
% surf(X, Y, abs(gradientYL)*1000, 'EdgeColor', 'none','FaceColor','interp'); % *1000 to get Wb/m^2
% view(2);
% 
% % Right patch
% [euM, FM]=sp_eval(u(gnum{2}), space{2}, geometry(2), [80 80], 'gradient'); 
% [X, Y]  = deal(squeeze(FM(1,:,:)), squeeze(FM(2,:,:)));
% gradientYM(:,:)=euM(2,:,:);
% surf(X, Y, abs(gradientYM)*1000, 'EdgeColor', 'none','FaceColor','interp');% *1000 to get Wb/m^2
% view(2);
% 
% % Middle patch
% [euR, FR]=sp_eval(u(gnum{3}), space{3}, geometry(3), [80 80], 'gradient'); 
% [X, Y]  = deal(squeeze(FR(1,:,:)), squeeze(FR(2,:,:)));
% gradientYR(:,:)=euR(2,:,:);
% surf(X, Y, abs(gradientYR)*1000, 'EdgeColor', 'none','FaceColor','interp'); % *1000 to get Wb/m^2
% view(2);
% caxis(B_color_vector);
% 
% %% PLOT THE B-FIELD
% 
% figure
% title('B-field');
% hold on;
% 
% % Left patch
% [euL, FL]=sp_eval(u(gnum{1}), space{1}, geometry(1), [80 80], 'gradient');
% [X, Y]  = deal(squeeze(FL(1,:,:)), squeeze(FL(2,:,:)));
% euAbsL(:,:)=sqrt(euL(1,:,:).^2+euL(2,:,:).^2);
% surf(X, Y, euAbsL*1000, 'EdgeColor', 'none');%,'FaceColor','interp'); % *1000 to get Wb/m^2
% caxis(B_color_vector);
% view(2);
% 
% % Right patch
% [euR, FR]=sp_eval(u(gnum{2}), space{2}, geometry(2), [80 80], 'gradient');
% [X, Y]  = deal(squeeze(FR(1,:,:)), squeeze(FR(2,:,:)));
% euAbsR(:,:)=sqrt(euR(1,:,:).^2+euR(2,:,:).^2);
% surf(X, Y, euAbsR*1000, 'EdgeColor', 'none');%,'FaceColor','interp'); % *1000 to get Wb/m^2
% caxis(B_color_vector);
% view(2);
% 
% % Middle patch
% [euM, FM]=sp_eval(u(gnum{3}), space{3}, geometry(3), [80 80], 'gradient');
% [X, Y]  = deal(squeeze(FM(1,:,:)), squeeze(FM(2,:,:)));
% euAbsM(:,:)=sqrt(euM(1,:,:).^2+euM(2,:,:).^2);
% surf(X, Y, euAbsM*1000, 'EdgeColor', 'none');%,'FaceColor','interp'); % *1000 to get Wb/m^2
% caxis(B_color_vector);
% view(2);
% % 
% %% PLOT THE POTENTIAL
% 
figure
title('Vector potential');
hold on;

% Left patch
[euL, FL]=sp_eval(u(gnum{1}), space{1}, geometry(1), [80 80], 'value');
[X, Y]  = deal(squeeze(FL(1,:,:)), squeeze(FL(2,:,:)));
surf(X, Y, euL, 'EdgeColor', 'none');

% Middle patch
[euM, FM]=sp_eval(u(gnum{2}), space{2}, geometry(2), [80 80], 'value');
[X, Y]  = deal(squeeze(FM(1,:,:)), squeeze(FM(2,:,:)));
surf(X, Y, euM, 'EdgeColor', 'none');

% Right patch
[euR, FR]=sp_eval(u(gnum{3}), space{3}, geometry(3), [80 80], 'value');
[X, Y]  = deal(squeeze(FR(1,:,:)), squeeze(FR(2,:,:)));
surf(X, Y, euR, 'EdgeColor', 'none');

view(2);
% 
% %% RETURN GRADIENT VALUES IN THE BEAM AREA
% if (returnGradient==1)
%     beamAreaGradient=gradientXM(:,:);
% end    
end


