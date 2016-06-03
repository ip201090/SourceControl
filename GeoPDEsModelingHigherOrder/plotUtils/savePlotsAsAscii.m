%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function []=savePlotsAsAscii(filename, arg1, arg2, arg3)

if nargin==4
    % 3D plot
    fid=fopen(filename, 'w+');
    
    if size(arg1,2)~=1 && size(arg1,1)==1
        arg1=arg1';
    elseif size(arg1,1)~=1 && size(arg1,2)==1
        %arg1=arg1;
    else
        disp('Error: x must be a vector');
        return;
    end
    if size(arg2,2)~=1 && size(arg2,1)==1
        arg2=arg2';
    elseif size(arg2,1)~=1 && size(arg2,2)==1
        %arg2=arg2;
    else
        disp('Error: y must be a vector');
        return;
    end
    if size(arg3,2)~=1 && size(arg3,1)==1
        arg3=arg3';
    elseif size(arg3,1)~=1 && size(arg3,2)==1
        %arg3=arg3;
    else
        disp('Error: y must be a vector');
        return;
    end
    
    if ~isequal(size(arg1),size(arg2)) || ~isequal(size(arg1),size(arg3)) || ~isequal(size(arg2),size(arg3))
       disp('Error: Matrix dimensions do not agree.');
    else
        data=[arg1,arg2,arg3];
        save(filename, 'data', '-ascii');
    end
    
    fclose(fid);
    return;
       
elseif nargin==3
    % Only 2D plot
    fid=fopen(filename, 'w+');
    
    if size(arg1,2)~=1 && size(arg1,1)==1
        arg1=arg1';
    elseif size(arg1,1)~=1 && size(arg1,2)==1
        %arg1=arg1;
    else
        disp('Error: x must be a vector');
        return;
    end
    if size(arg2,2)~=1 && size(arg2,1)==1
        arg2=arg2';
    elseif size(arg2,1)~=1 && size(arg2,2)==1
        %arg2=arg2;
    else
        disp('Error: y must be a vector');
        return;
    end
    
    if ~isequal(size(arg1),size(arg2))
       disp('Error: Matrix dimensions do not agree.');
       fclose(fid);
       return;
    else
        data=[arg1,arg2];
        save(filename, 'data', '-ascii');
    end
    
    fclose(fid);
    return;
else
    % Unknown format
end

end