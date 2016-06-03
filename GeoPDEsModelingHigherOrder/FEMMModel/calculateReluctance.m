%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

createRabiTypeSternGerlachFEMMIron('strong', 65, 40, 0.8, './');

mi_analyze();
mi_loadsolution();

mo_addcontour(-27,20);
mo_addcontour(-27,0);
[flux]=mo_lineintegral(0)

% Wanted flux: 0.002524713843049
options = optimset('TolFun', 1e-10);

currentNew=fsolve(@newtonFunction, 20, options);

phiWanted=0.002524713843049;
Rtotal=65*currentNew/phiWanted;
mu0=4*pi*1e-7;
mueLow=3700;
mueHigh=3800;
mue=3727;
Rp=0.054/(mu0*mue*0.200*0.017);
RpLow=0.054/(mu0*mueLow*0.200*0.017);
RpHigh=0.054/(mu0*mueHigh*0.200*0.017);

RyLow=Rtotal-RpLow
RyHigh=Rtotal-RpHigh
Ry=Rtotal-Rp
