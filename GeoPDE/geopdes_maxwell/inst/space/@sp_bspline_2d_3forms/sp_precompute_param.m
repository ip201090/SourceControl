% SP_PRECOMPUTE_PARAM: precompute all the fields, as in the space structure of the technical report, before mapping to the physical domain.
%  This function is used before applying the map.
%
%     space = sp_precompute_param (space, msh);
%     space = sp_precompute_param (space, msh, 'option');
%
% INPUT:
%     
%    space: object representing the discrete function space (see sp_bspline_2d_3forms).
%    'option', value: additional optional parameters, the available options are:
%        nsh, connectivity, value (shape_functions).
%     The value must be true or false. All the values are false by default.
%
% OUTPUT:
%
%    space: object containing the information of the input object, plus the 
%            fields of the old structure, that are listed below. If no option
%            is given all the fields are computed. If an option is given,
%            only the selected fields will be computed.
%
%    FIELD_NAME      (SIZE)                             DESCRIPTION
%    nsh             (1 x msh.nel vector)               actual number of shape functions per each element
%    connectivity    (nsh_max x msh.nel vector)         indices of basis functions that do not vanish in each element
%    shape_functions (msh.nqn x nsh_max x msh.nel)      basis functions evaluated at each quadrature node in each element
%
% Copyright (C) 2009, 2010 Carlo de Falco
% Copyright (C) 2011 Rafael Vazquez
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

function sp = sp_precompute_param (sp, msh, varargin)

  if (isempty (varargin))
    nsh = true;
    connectivity = true;
    value = true;
  else
    if (~rem (length (varargin), 2) == 0)
      error ('sp_precompute: options must be passed in the [option, value] format');
    end
    nsh = false;
    connectivity = false;
    value = false;
    for ii=1:2:length(varargin)-1
      if (strcmpi (varargin{ii}, 'connectivity'))
        connectivity = varargin{ii+1};
      elseif (strcmpi (varargin{ii}, 'nsh'))
        nsh = varargin{ii+1};
      elseif (strcmpi (varargin{ii}, 'value'))
        value = varargin{ii+1};
      else
        error ('sp_precompute_param: unknown option %s', varargin {ii});
      end
    end    
  end

  nelu = msh.nel_dir(1); nelv = msh.nel_dir(2);
  nel = msh.nel;
  nqnu = msh.nqn_dir(1); nqnv = msh.nqn_dir(2);
  nqn = msh.nqn;

  spu = sp.spu; spv = sp.spv;
  nsh_max = sp.nsh_max;

  if (nsh)
    nsh  = spu.nsh' * spv.nsh;
    sp.nsh  = nsh(:)';
  end

  if (connectivity)
    conn_u = reshape (spu.connectivity, spu.nsh_max, 1, nelu, 1);
    conn_u = repmat  (conn_u, [1, spv.nsh_max, 1, nelv]);
    conn_u = reshape (conn_u, [], nel);

    conn_v = reshape (spv.connectivity, 1, spv.nsh_max, 1, nelv);
    conn_v = repmat  (conn_v, [spu.nsh_max, 1, nelu, 1]);
    conn_v = reshape (conn_v, [], nel);

    connectivity = zeros (nsh_max, nel);
    indices = (conn_u ~= 0) & (conn_v ~= 0);
    connectivity(indices) = ...
        sub2ind ([spu.ndof, spv.ndof], conn_u(indices), conn_v(indices));
    sp.connectivity = reshape (connectivity, nsh_max, nel);

    clear conn_u conn_v connectivity
  end

  if (value)
    shp_u = reshape (spu.shape_functions, nqnu, 1, spu.nsh_max, 1, nelu, 1);
    shp_u = repmat  (shp_u, [1, nqnv, 1, spv.nsh_max, 1, nelv]);
    shp_u = reshape (shp_u, nqn, nsh_max, nel);

    shp_v = reshape (spv.shape_functions, 1, nqnv, 1, spv.nsh_max, 1, nelv);
    shp_v = repmat  (shp_v, [nqnu, 1, spu.nsh_max, 1, nelu, 1]);
    shp_v = reshape (shp_v, nqn, nsh_max, nel);

    sp.shape_functions = shp_u .* shp_v;
  end

end
