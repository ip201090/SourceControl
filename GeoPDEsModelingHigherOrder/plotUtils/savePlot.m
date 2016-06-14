% Copyright (c) 2015 Andreas Pels

function [  ] = savePlot( fileName, mode )





if nargin==1
    disp('Using EPS mode...')
    print ('-depsc', '-r600', fileName);
else
    if strcmp(mode, 'jpeg')
        disp('Using JPEG mode...');
        print ('-djpeg', '-r600', fileName);
    elseif strcmp(mode, 'eps')
        disp('Using EPS mode...');
        print ('-depsc', '-r600', fileName);
    else
        disp('Mode unkown!');
    end
end


end

