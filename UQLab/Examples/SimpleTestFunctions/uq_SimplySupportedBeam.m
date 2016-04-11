function V = uq_SimplySupportedBeam(X)
% function V = uq_SimplySupportedBeam(X)
%
%   Computes the midspan deflection of a simply supported beam under uniform
%   loading
%
%   Model with five input parameters  X= [b h L E p]
%         b:   beam width
%         h:   beam height
%         L:   beam span
%         E:   Young's modulus
%         p:   uniform load
%
%   Output:  V = (5/32)*pL^4/(E*b*h^3)
% 


% Retrieve  variables
% b = X(:, 1);
% h = X(:, 2);
% L = X(:, 3);
% E = X(:, 4);
% p = X(:, 5);

% Vectorized implementation
V = (5/32)*(X(:, 5).*X(:, 3).^4)./(X(:, 4).*X(:, 1).*X(:, 2).^3);
