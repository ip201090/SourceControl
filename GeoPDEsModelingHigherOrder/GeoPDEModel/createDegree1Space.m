## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

knotsX=[0,unique(knots{iptc}{1}),1];
knotsY=[0,unique(knots{iptc}{2}),1];
newKnots=cell(1,2);
newKnots{1}=knotsX;
newKnots{2}=knotsY;

sp{iptc} = sp_bspline_2d (newKnots, [1 1], msh{iptc});

clear newKnots knotsX knotsY;