## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ ] = createRabiTypeSternGerlachFEMM(type, turns, current, meshSize, folder, fileName, lengthFromOuterLimit)
% Add femm path to MATLAB
addpath C:\femm42\mfiles\

if nargin==5
    modelname='RabiTypeSternGerlach';
    lengthFromOuterLimit=500;
elseif nargin==6
    modelname=fileName;
    lengthFromOuterLimit=500;
elseif nargin==7
    modelname=fileName;
    %lengthFromOuterLimit=lengthFromOuterLimit;
end

openfemm();
main_minimize();
newdocument(0);

% Define or get materials from library
mi_addmaterial('Copper', 1, 1, 0, 0, 58, 0, 0, 0, 0, 0, 0, 0, 0);
mi_getmaterial('Air');
mi_addmaterial('Iron', 3756.04, 3756.04, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0);
% B=[
%     0.000000 ;
%     0.388330 ;
%     0.482524 ;
%     0.595293 ;
%     0.726634 ;
%     0.873453 ;
%     1.028101 ;
%     1.178099 ;
%     1.308718 ;
%     1.408663 ;
%     1.475645 ;
%     1.516957 ;
%     1.544297 ;
%     1.567545 ;
%     1.592042 ;
%     1.619381 ;
%     1.649135 ;
%     1.679984 ;
%     1.710511 ;
%     1.740077 ;
%     1.769441 ;
%     1.800555 ;
%     1.835625 ;
%     1.876121 ;
%     1.922187 ;
%     1.972386 ;
%     2.023674 ;
%     2.071950 ;
%     2.113538 ;
%     2.147083 ;
%     2.174427 ;
%     2.199604 ;
%     2.226937 ;
%     2.259850 ;
%     2.300931 ;
%     2.352597 ;
%     2.417636 ;
%     2.499516 ;
%     ];
% H=[
%     0.000000 ;
%     79.577472 ;
%     100.182101 ;
%     126.121793 ;
%     158.777930 ;
%     199.889571 ;
%     251.646061 ;
%     316.803620 ;
%     398.832128 ;
%     502.099901 ;
%     632.106325 ;
%     795.774715 ;
%     1001.821011 ;
%     1261.217929 ;
%     1587.779301 ;
%     1998.895710 ;
%     2516.460605 ;
%     3168.036204 ;
%     3988.321282 ;
%     5020.999013 ;
%     6321.063250 ;
%     7957.747155 ;
%     10018.210114 ;
%     12612.179293 ;
%     15877.793010 ;
%     19988.957103 ;
%     25164.606052 ;
%     31680.362037 ;
%     39883.212823 ;
%     50209.990127 ;
%     63210.632497 ;
%     79577.471546 ;
%     100182.101136 ;
%     126121.792926 ;
%     158777.930096 ;
%     199889.571030 ;
%     251646.060522 ;
%     316803.620370 ;
%     ];

% for i=1:length(B)
%     mi_addbhpoint('Iron', B(i), H(i));
% end

% Set problem definition
freq=0; precision=1e-8; depth=200; minangle=30; acsolver=0;
mi_probdef(freq,'millimeters','planar',precision,depth,minangle,acsolver)

% if strcmp(type,'weak') && 0
%     %% Draw geometry for weak type
%     % Calculate node positions for coil with radius r
%     r=0.5;
%     rConvex=2.67;
%     centerConvex=[-4.00, 0.00];
%     angleSubstracted=2*asin(r/(2*rConvex));
%     pointConvex(1)=centerConvex(1)+cos(pi/2-angleSubstracted)*rConvex;
%     pointConvex(2)=centerConvex(2)+sin(pi/2-angleSubstracted)*rConvex;
%
%     point4=[-17, 20];
%     point5=[-4.00, 2.67];
%     newPoint5=point5+(point4-point5)/norm(point4-point5)*r;
%
%
%
%     % Add the nodes for convex tip
%     mi_addnode(-1.33, 0);
%     mi_addnode(pointConvex(1), pointConvex(2));
%     mi_addnode(newPoint5(1), newPoint5(2));
%     mi_addnode(point5(1), point5(2)-r);
%     mi_addnode(point5(1), point5(2)+r);
%
%     % Draw coil
%     mi_addarc(point5(1), point5(2)-r, point5(1), point5(2)+r, 180, 2.5);
%     mi_addarc(point5(1), point5(2)+r, point5(1), point5(2)-r, 180, 2.5)
%
%
%     % Connect nodes with arc segment
%     mi_addarc(-1.33, 0, pointConvex(1), pointConvex(2), 90-angleSubstracted/(2*pi)*360, 1);
%
%     % Add nodes for left pole
%     mi_addnode(-17.00, 20.00);
%     mi_addnode(-44.33, 20.00);
%     mi_addnode(-44.33, 0);
%
%     % Add segments to connect nodes
%     mi_addsegment(newPoint5(1), newPoint5(2), -17.00, 20.00);
%     mi_addsegment(-17.00, 20.00, -44.33, 20.00);
%     mi_addsegment(-44.33, 20.00, -44.33, 0.00);
%     mi_addsegment(-44.33, 0.00, -1.33, 0.00);
%
%     % Add the nodes for concave tip
%     mi_addnode(-1.59, 3.31);
%     mi_addnode(-1.59, 5.31);
%     mi_addnode(1.33, 0.00);
%
%     % Connect nodes with arc segment
%     mi_addarc(1.33, 0.00, -1.59, 3.31, 90, 1);
%
%     % Add nodes for right pole
%     mi_addnode(17.00,20.00);
%     mi_addnode(46.05, 20.00);
%     mi_addnode(46.05, 0.00);
%
%     % Add segments to connect nodes
%     mi_addsegment(-1.59, 3.31, -1.59, 5.31);
%     mi_addsegment(-1.59, 5.31, 17.00, 20.00);
%     mi_addsegment(17.00, 20.00, 46.05, 20.00);
%     mi_addsegment(46.05, 20.00, 46.05, 0.00);
%     mi_addsegment(46.05, 0.00, 1.33, 0.00);
%
%     % Create Boundary
%     mi_addsegment(-1.33, 0.00, 1.33, 0.00);
%
%     % Add fixation of poles
%     mi_addnode(-39.14, 20.00);
%     mi_addnode(-39.14, 55);
%     mi_addnode(40.86, 55);
%     mi_addnode(40.86, 20);
%
%     mi_addnode(-59.14, 0.00);
%     mi_addnode(-59.14, 75.00);
%     mi_addnode(60.86, 75.00);
%     mi_addnode(60.86, 0.00);
%
%     % Connect nodes with segments
%     mi_addsegment(-39.14, 20.00, -39.14, 55);
%     mi_addsegment(-39.14, 55, 40.86, 55);
%     mi_addsegment(40.86, 55, 40.86, 20);
%
%     mi_addsegment(-44.33, 0.00, -59.14, 0.00);
%     mi_addsegment(-59.14, 0.00, -59.14, 75.00);
%     mi_addsegment(-59.14, 75.00, 60.86, 75.00);
%     mi_addsegment(60.86, 75.00, 60.68, 0.00);
%     mi_addsegment(46.05, 0.00, 60.68, 0.00);
%
%     % Set block labels and assign materials
%     mi_addcircprop('Coil', 3.9, 1);
%
%     mi_addblocklabel(point5(1), point5(2));
%     mi_selectlabel(point5(1), point5(2));
%     mi_setblockprop('Copper', 0, 0.5, 'Coil', 0, 0, 1);
%     mi_clearselected();
%
%     mi_addblocklabel(-3.3, 6.7);
%     mi_selectlabel(-3.3, 6.7);
%     mi_setblockprop('Air', 0, 0.5, '', 0, 0, 1);
%     mi_clearselected();
%
%     mi_addblocklabel(18, 9);
%     mi_selectlabel(18, 9);
%     mi_setblockprop('Iron', 0, 0.5, '', 0, 0, 1);
%     mi_clearselected();
%
%     mi_addblocklabel(-26, 9);
%     mi_selectlabel(-26, 9);
%     mi_setblockprop('Iron', 0, 0.5, '', 0, 0, 1);
%     mi_clearselected();
%
%     mi_addblocklabel(0, 65);
%     mi_selectlabel(0, 65);
%     mi_setblockprop('Iron', 0, 0.5, '', 0, 0, 1);
%     mi_clearselected();
%
%
%     % Set boundary condition and apply it to the boundary
%     mi_addboundprop('PrescribedAZero', 0, 0, 0, 0, 0, 0, 0, 0, 0);
%     %mi_setsegmentprop(2.5, 'PrescribedAZeros', 0, 0)
%


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
    point6=[poleTipPeak(1)-43, point4(2)];
    point7=[poleTipPeak(1)+47.38, point3(2)];
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
    point6=[poleTipPeak(1)-43, point4(2)];
    point7=[poleTipPeak(1)+47.38, point3(2)];
end

%% Draw geometry for weak type
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

% Add yoke
mi_addnode(point6(1)+5.19, point6(2));
mi_addnode(point6(1)+5.19, 55);
mi_addnode(point7(1)-5.19, 55);
mi_addnode(point7(1)-5.19, point6(2));

mi_addnode(point6(1)+5.19-20, 0.00);
mi_addnode(point6(1)+5.19-20, 75.00);
mi_addnode(point7(1)-5.19+20, 75.00);
mi_addnode(point7(1)-5.19+20, 0.00);


% Connect nodes with segments
mi_addsegment(point6(1)+5.19, point6(2), point6(1)+5.19, 55);
mi_addsegment(point6(1)+5.19, 55, point7(1)-5.19, 55);
mi_addsegment(point7(1)-5.19, 55, point7(1)-5.19, 20);

mi_addsegment(point6(1), 0.00, point6(1)+5.19-20, 0.00);
mi_addsegment(point6(1)+5.19-20, 0.00, point6(1)+5.19-20, 75.00);
mi_addsegment(point6(1)+5.19-20, 75.00, point7(1)-5.19+20, 75.00);
mi_addsegment(point7(1)-5.19+20, 75.00, point7(1)-5.19+20, 0.00);
mi_addsegment(point7(1), 0.00, point7(1)-5.19+20, 0.00);

% Add coils
mi_addnode(point6(1)+5.19+5, point6(2)+5);
mi_addnode(point6(1)+5.19+5, 55);
mi_addnode(point7(1)-5.19-5, 55);
mi_addnode(point7(1)-5.19-5, 20+5);

mi_addnode(point6(1)+5.19+5, 75.00);
mi_addnode(point6(1)+5.19+5, 105.00);
mi_addnode(point7(1)-5.19-5, 105.00);
mi_addnode(point7(1)-5.19-5, 75.00);

% Add segments for coil
mi_addsegment(point6(1)+5.19+5, point6(2)+5, point6(1)+5.19+5, 55);
mi_addsegment(point7(1)-5.19-5, 55, point7(1)-5.19-5, point7(2)+5);
mi_addsegment(point7(1)-5.19-5, point7(2)+5, point6(1)+5.19+5, point6(2)+5);

mi_addsegment(point6(1)+5.19+5, 75.00, point6(1)+5.19+5, 105.00);
mi_addsegment(point6(1)+5.19+5, 105.00, point7(1)-5.19-5, 105.00);
mi_addsegment(point7(1)-5.19-5, 105.00, point7(1)-5.19-5, 75.00);

% Set block labels and assign materials
mi_addcircprop('Coil', current, 1);

mi_addblocklabel(0, 40);
mi_selectlabel(0, 40);
mi_setblockprop('Copper', 0, meshSize, 'Coil', 0, 0, turns);
mi_clearselected();

mi_addblocklabel(0, 90);
mi_selectlabel(0, 90);
mi_setblockprop('Copper', 0, meshSize, 'Coil', 0, 0, -turns);
mi_clearselected();

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

mi_addblocklabel(0, 65);
mi_selectlabel(0, 65);
mi_setblockprop('Iron', 0, meshSize, '', 0, 0, 0);
mi_clearselected();


% Set boundary condition and apply it to the boundary
radiusShell=(point7(1)-5.19+20+lengthFromOuterLimit-(point6(1)+5.19-20-lengthFromOuterLimit))/2;

mi_addboundprop('PrescribedAZero', 0, 0, 0, 0, 0, 0, 0, 0, 0);
mi_addboundprop('OpenBoundary', 0, 0, 0, 0, 0, 0, 1/(4*pi*1e-7*radiusShell*1e-3), 0, 2);


mi_addnode(point6(1)+5.19-20-lengthFromOuterLimit, 0.00);
mi_addnode(point7(1)-5.19+20+lengthFromOuterLimit, 0.00);
mi_addsegment(point6(1)+5.19-20, 0.00, point6(1)+5.19-20-lengthFromOuterLimit, 0.00);
mi_addsegment(point7(1)-5.19+20, 0.00, point7(1)-5.19+20+lengthFromOuterLimit, 0.00);
mi_addarc(point7(1)-5.19+20+lengthFromOuterLimit, 0.00, point6(1)+5.19-20-lengthFromOuterLimit, 0.00, 180, 5);

mi_addblocklabel(90, 30);
mi_selectlabel(90, 30);
mi_setblockprop('Air', 1, 0, '', 0, 0, 0);
mi_clearselected();

mi_selectsegment(0.00, 0.00);
mi_selectsegment(-40.00, 0.00);
mi_selectsegment(40.00, 0.00);
mi_selectsegment(-50.00, 0.00);
mi_selectsegment(52.00, 0.00);
mi_selectsegment(point7(1)-5.19+20+lengthFromOuterLimit/2, 0.00);
mi_selectsegment(point6(1)+5.19-20-lengthFromOuterLimit/2, 0.00);

mi_setsegmentprop('PrescribedAZero', 0.5, 0, 0, 1);
mi_clearselected();

mi_selectarcsegment(0.00, point7(1)-5.19+20+lengthFromOuterLimit);
mi_setarcsegmentprop(2.5, 'OpenBoundary', 0, 2);
mi_clearselected();



% Save the file
string=sprintf('%s\\%s.fem', folder ,modelname);
mi_saveas(string);



end

