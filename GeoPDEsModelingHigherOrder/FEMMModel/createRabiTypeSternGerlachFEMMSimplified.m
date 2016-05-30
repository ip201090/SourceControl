## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ ] = createRabiTypeSternGerlachFEMMSimplified(type, meshSize, enforcedBoundaryPotential, folder, fileName)
% Add femm path to MATLAB
addpath C:\femm42\mfiles\

modelname='RabiTypeSternGerlachSimplified';

openfemm();
main_minimize();
newdocument(0);

% Define or get materials from library
mi_addmaterial('Copper', 1, 1, 0, 0, 58, 0, 0, 0, 0, 0, 0, 0, 0);
mi_getmaterial('Air');
mi_addmaterial('Iron', 1, 1, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0);
B=[
    0.000000 ;
    0.388330 ;
    0.482524 ;
    0.595293 ;
    0.726634 ;
    0.873453 ;
    1.028101 ;
    1.178099 ;
    1.308718 ;
    1.408663 ;
    1.475645 ;
    1.516957 ;
    1.544297 ;
    1.567545 ;
    1.592042 ;
    1.619381 ;
    1.649135 ;
    1.679984 ;
    1.710511 ;
    1.740077 ;
    1.769441 ;
    1.800555 ;
    1.835625 ;
    1.876121 ;
    1.922187 ;
    1.972386 ;
    2.023674 ;
    2.071950 ;
    2.113538 ;
    2.147083 ;
    2.174427 ;
    2.199604 ;
    2.226937 ;
    2.259850 ;
    2.300931 ;
    2.352597 ;
    2.417636 ;
    2.499516 ;
    ];
H=[
    0.000000 ;
    79.577472 ;
    100.182101 ;
    126.121793 ;
    158.777930 ;
    199.889571 ;
    251.646061 ;
    316.803620 ;
    398.832128 ;
    502.099901 ;
    632.106325 ;
    795.774715 ;
    1001.821011 ;
    1261.217929 ;
    1587.779301 ;
    1998.895710 ;
    2516.460605 ;
    3168.036204 ;
    3988.321282 ;
    5020.999013 ;
    6321.063250 ;
    7957.747155 ;
    10018.210114 ;
    12612.179293 ;
    15877.793010 ;
    19988.957103 ;
    25164.606052 ;
    31680.362037 ;
    39883.212823 ;
    50209.990127 ;
    63210.632497 ;
    79577.471546 ;
    100182.101136 ;
    126121.792926 ;
    158777.930096 ;
    199889.571030 ;
    251646.060522 ;
    316803.620370 ;
    ];

for i=1:length(B)
    mi_addbhpoint('Iron', B(i), H(i));
end

% Set problem definition
freq=0; precision=1e-8; depth=200; minangle=30; acsolver=0;
mi_probdef(freq,'millimeters','planar',precision,depth,minangle,acsolver)

% Calculate node positions for coil with radius r
if strcmp('weak', type)
    rConvex=2.67;
    rConcave=3.33;
    centerConvex=[-4.00, 0.00];
    centerConcave=[-2, 0];
    
    point4=[-17, 20];
    point3=[17, 20];
    point2=[-1.59, 5.31];
    point5=[-4.00, 2.67];
    point1=[-1.59, 3.31];
    poleTipPeak=[centerConvex(1)+rConvex, 0.00];
    % point6 and point7 translated
    point6=[point4(1)-10, point4(2)];
    point7=[point3(1)+10, point3(2)];
elseif strcmp('strong', type)
    rConvex=4;
    rConcave=5;
    centerConvex=[-6, 0.00];
    centerConcave=[-3, 0];
    
    point4=[-17, 20];
    point3=[17, 20];
    point2=[-2.38, 6.96];
    point5=[-6, 4];
    point1=[-2.38, 4.96];
    poleTipPeak=[centerConvex(1)+rConvex, 0.00];
    % point6 and point7 translated
    point6=[point4(1)-10, point4(2)];
    point7=[point3(1)+10, point3(2)];
end

%% Draw geometry
% Add the nodes for convex tip
mi_addnode(centerConvex(1)+rConvex, 0);
mi_addnode(point5(1), point5(2));


% Connect nodes with arc segment
mi_addarc(centerConvex(1)+rConvex, 0, point5(1), point5(2), 90, meshSize*0.25);

% Add nodes for left pole
mi_addnode(point4(1), point4(2));
mi_addnode(point6(1), point6(2));
mi_addnode(point6(1), 0);

% Add segments to connect nodes
mi_addsegment(point5(1), point5(2), point4(1), point4(2));
mi_addsegment(point4(1), point4(2), point6(1), point6(2));
mi_addsegment(point6(1), point6(2), point6(1), 0.00);
mi_addsegment(point6(1), 0.00, poleTipPeak(1), 0.00);

% Add the nodes for concave tip
mi_addnode(point1(1), point1(2));
mi_addnode(point2(1), point2(2));
mi_addnode(centerConcave(1)+rConcave, 0.00);

% Connect nodes with arc segment
angle=atan((point1(2)-centerConcave(2))/(point1(1)-centerConcave(1)))/pi*180
mi_addarc(centerConcave(1)+rConcave, 0.00, point1(1), point1(2), angle, meshSize*0.25);

% Add nodes for right pole
mi_addnode(point3(1), point3(2));
mi_addnode(point7(1), point3(2));
mi_addnode(point7(1), 0.00);

% Add segments to connect nodes
mi_addsegment(point1(1), point1(2), point2(1), point2(2));
mi_addsegment(point2(1), point2(2), point3(1), point3(2));
mi_addsegment(point3(1), point3(2), point7(1), point7(2));
mi_addsegment(point7(1), point7(2), point7(1), 0.00);
mi_addsegment(point7(1), 0.00, centerConcave(1)+rConcave, 0.00);

% Create Boundary in gap
mi_addsegment(poleTipPeak(1), 0.00, centerConcave(1)+rConcave, 0.00);

% Set block labels and assign materials
mi_addblocklabel(-4, 12);
mi_selectlabel(-4, 12);
mi_setblockprop('Air', 0, meshSize, '', 0, 0, 0);
mi_clearselected();

mi_addsegment(point5(1), point5(2), point2(1), point2(2));
mi_addblocklabel(0.00, 1);
mi_selectlabel(0.00, 1);
mi_setblockprop('Air', 0, meshSize*0.05, '', 0, 0, 0);
mi_clearselected();

mi_addblocklabel(18, 9);
mi_selectlabel(18, 9);
mi_setblockprop('Iron', 0, meshSize, '', 0, 0, 0);
mi_clearselected();

mi_addblocklabel(-26, 9);
mi_selectlabel(-26, 9);
mi_setblockprop('Iron', 0, meshSize, '', 0, 0, 0);
mi_clearselected();

% Set boundary condition and apply it to the boundary
mi_addboundprop('PrescribedAZero', 0, 0, 0, 0, 0, 0, 0, 0, 0);

% Boundary on top
mi_addsegment(point3(1), point3(2), point4(1), point4(2));

% Boundary at bottom
mi_selectsegment(0.00, 0.00);
mi_selectsegment(-20.00, 0.00);
mi_selectsegment(20.00, 0.00);

mi_setsegmentprop('PrescribedAZero', 0.5, 1, 0, 1);

mi_clearselected();

% Enforcing boundary condition using several nodes
% between which the potential on the segment is enforced as such that there is
% no jump in the potential at the nodes.
len=size(enforcedBoundaryPotential.A);
for i=1:len-1
   % Add node at certain position
    mi_addnode(enforcedBoundaryPotential.coord(i,1), enforcedBoundaryPotential.coord(i,2)); 
end

for i=1:len-1
    % Set values which are needed for convenience in simple variables
    var.p0=enforcedBoundaryPotential.A(i);
    var.p1=enforcedBoundaryPotential.A(i+1);
    var.x0=enforcedBoundaryPotential.coord(i,1);
    var.y0=enforcedBoundaryPotential.coord(i,2);
    var.x1=enforcedBoundaryPotential.coord(i+1,1);
    var.y1=enforcedBoundaryPotential.coord(i+1,2);
    
    % Select next segment and check if there is point3 or point4 in the
    % way. If so, change two segments to the current boundary condition.
    if (var.x0<point4(1) && var.x1>point4(1))
        mi_selectsegment((var.x0+point4(1))./2, (var.y0+point4(2))./2);
        mi_selectsegment((point4(1)+var.x1)./2, (var.y1+point4(2))./2);
    elseif (var.x0<point3(1) && var.x1>point3(1))
        mi_selectsegment((var.x0+point3(1))./2, (var.y0+point3(2))./2);
        mi_selectsegment((point3(1)+var.x1)./2, (var.y1+point3(2))./2);
    else
        mi_selectsegment((var.x1+var.x0)./2, (var.y1+var.y0)./2);
    end
    
    % Calculate A0, A1 and A2: Use linear potential on boundaries
    A0=0;
    A2=(var.p1*var.x0-var.p0*var.x1)./(var.y1*var.x0-var.y0*var.x1);
    A1=(var.p0*var.y1-var.p1*var.y0)./(var.x0*var.y1-var.x1*var.y0);
    
    % Create boundary condition and enforce it on the boundary
    string=sprintf('BC%d', i);
    mi_addboundprop(string, A0, A1, A2, 0, 0, 0, 0, 0, 0);
    mi_setsegmentprop(string, 0, 1, 0, 3);
    
    % Finally clear selected segment and move on to the next
    mi_clearselected();
end

% Save the file
string=sprintf('%s\\%s.fem', folder ,fileName);
mi_saveas(string);




end

