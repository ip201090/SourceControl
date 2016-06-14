% This script file automatically adds all the subfolders for GeoPDEs packages
% Change in the file the variable "my_path" and run the script from Matlab command window.
%
% The script DOES NOT save the path for the NURBS toolbox. 
% Do not forget to save it somewhere in your path.

% Set the path of the folder where you have uncompressed the files
  my_path = 'E:\Seafile\ProjectSeminarE-CAD\GeoPDE';
  %my_path = '/home/vazquez/tmp/';

% Path for geopdes_base
  addpath (genpath (fullfile (my_path, 'geopdes_base', 'inst')));

% Path for geopdes_multipatch
  if (isdir (fullfile (my_path, 'geopdes_multipatch')))
    addpath (genpath (fullfile (my_path, 'geopdes_multipatch', 'inst')));
  end

% Path for geopdes_elasticity
  if (isdir (fullfile (my_path, 'geopdes_elasticity')))
    addpath (genpath (fullfile (my_path, 'geopdes_elasticity', 'inst')));
  end

% Path for geopdes_fluid
  if (isdir (fullfile (my_path, 'geopdes_fluid')))
    addpath (genpath (fullfile (my_path, 'geopdes_fluid', 'inst')));
  end

% Path for geopdes_maxwell
  if (isdir (fullfile (my_path, 'geopdes_maxwell')))
    addpath (genpath (fullfile (my_path, 'geopdes_maxwell', 'inst')));
  end

% Remove this line if you don't want the new path to be saved permanently
  savepath()
