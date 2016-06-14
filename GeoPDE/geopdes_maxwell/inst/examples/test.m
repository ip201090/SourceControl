function [ value ] = test( x,y )
size(x)
size(y)
x
y

%value=cat(1, reshape (-exp(x) .* sin(y) + 2*sin(y), [1, size(x)]), zeros ([1, size(x)]));
value=cat(1, zeros ([1, size(x)]) , zeros ([1, size(x)]))

size(value)
value
end

