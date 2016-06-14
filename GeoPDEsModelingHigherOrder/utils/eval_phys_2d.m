% Copyright (c) 2015 Andreas Pels

function [ eu, F ] = eval_phys_2d( u, space, geometry, geoPoint, options )

[ut, vt] = inv_map_2d(geometry.nurbs, geoPoint);

[eu, F] = sp_eval (u, space, geometry, {ut, vt}, options);

end

