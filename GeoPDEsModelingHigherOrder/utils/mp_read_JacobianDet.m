% OP_GRADU_GRADV_TP: assemble the stiffness matrix A = [a(i,j)], a(i,j) = (epsilon grad u_j, grad v_i), exploiting the tensor product structure.
%
%   mat = op_gradu_gradv_tp (spu, spv, msh, epsilon);
%   [rows, cols, values] = op_gradu_gradv_tp (spu, spv, msh, epsilon);
%
% INPUT:
%
%   spu:     class representing the space of trial functions (see sp_bspline_2d)
%   spv:     class representing the space of test functions (see sp_bspline_2d)
%   msh:     class defining the domain partition and the quadrature rule (see msh_2d)
%   epsilon: function handle to compute the diffusion coefficient
%
% OUTPUT:
%
%   mat:    assembled stiffness matrix
%   rows:   row indices of the nonzero entries
%   cols:   column indices of the nonzero entries
%   values: values of the nonzero entries
% 
% Copyright (C) 2011, Carlo de Falco, Rafael Vazquez
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

function jacDeterminante = mp_read_JacobianDet (msh)

  for iel = 1:msh.nel_dir(1)
    msh_col = msh_evaluate_col (msh, iel);
    
    for i=1:msh_col.nqn
        for j=1:msh_col.nel
            jacDeterminante(iel, i, j)=det(msh_col.geo_map_jac(:,:,i,j));
        end
    end
    
  end
end
