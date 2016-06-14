% Copyright (c) 2015 Andreas Pels
function [  ] = parsave( filename, u, space, geometry, gnum )
%PARSAVE Save variables into mat-file
%   PARSAVE(filename, u, space, geometry, gnum) saves the GeoPDEs files
%   necessary to calculate the field values into a matlab mat-file.

save(filename, 'u', 'space', 'geometry', 'gnum');

end

