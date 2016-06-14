% ActiveFEMM (C)2006 David Meeker, dmeeker@ieee.org

function mi_addboundprop(pname,a0,a1,a2,phi,mu,sig,c0,c1,fmt)
callfemm(['mi_addboundprop(' , quotec(pname) , numc(a0) , numc(a1) , numc(a2) , numc(phi) , numc(mu) , numc(sig) , numc(c0) , numc(c1) , num(fmt) , ')' ]);

