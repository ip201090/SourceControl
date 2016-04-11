function Y = uq_runge( X )
%UQ_RUNGE Implementation of Runge Function
%   Simple function that is used for testing 1D metamodelling
I = ones(size(X)) ;

Y = (I + 25* X.^2).^(-1) ;

