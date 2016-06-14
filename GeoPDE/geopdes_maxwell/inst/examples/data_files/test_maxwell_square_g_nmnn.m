% TEST_MAXWELL_SQUARE_G_NMNN: data function for Neumann boundary condition.

function g = test_maxwell_square_g_nmnn (x, y, ind)

g = zeros ([2, size(x)]);
switch (ind)
    case 1
        %g(2,:,:) = -exp(x) .* cos(y) + cos(y);
        g(2,:,:)=zeros(size(x));
    case 2
        % g(2,:,:) = exp(x) .* cos(y) - cos(y);
        g(2,:,:)=zeros(size(x));
    case 3
        % g(1,:,:) = exp(x) .* cos(y) - cos(y);
        g(1,:,:)=zeros(size(x));
    case 4
        % g(1,:,:) = -exp(x) .* cos(y) + cos(y);
        g(1,:,:)=zeros(size(x));
    otherwise
        error ('g_nmnn: unknown reference number')
end

end

