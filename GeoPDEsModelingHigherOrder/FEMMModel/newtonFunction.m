%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [residual]=newtonFunction(current)
    createRabiTypeSternGerlachFEMMIron('strong', 65, current, 0.8, './');
    current
    
    mi_analyze();
    mi_loadsolution();

    mo_addcontour(-27,20);
    mo_addcontour(-27,0);
    [flux]=mo_lineintegral(0);
    
    residual=abs(0.002524713843049-flux(1))
    
end