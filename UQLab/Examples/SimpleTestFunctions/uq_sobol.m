function Y = uq_sobol(X)
% Y = UQ_SOBOL(X) = simple vector implementation of the sobol function

[N,M] = size(X);

if M ~= 8
    error('uq_sobol: input must be a matrix of length 8 row vectors!');
end

c = [1 2 5 10 20 50 100 500]';
C = repmat(transpose(c),N,1);
Y_ = (abs(4*X-2)+C)./(1+C);
Y = prod(Y_,2);



