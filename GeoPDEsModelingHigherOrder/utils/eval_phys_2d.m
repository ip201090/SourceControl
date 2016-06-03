%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ eu, F ] = eval_phys_2d( u, space, geometry, geoPoint, options )

[ut, vt] = inv_map_2d(geometry.nurbs, geoPoint);

[eu, F] = sp_eval (u, space, geometry, {ut, vt}, options);

end

