function    Y = uq_morris(U)

%   Morris function

[N,M] = size(U);
%     rand('state',0) ;

W = 2*(U-0.5) ;
W(:,[3 5 7]) = 2*(1.1*U(:,[3 5 7])./(U(:,[3 5 7])+0.1) - 0.5) ;
Y = 0 ;%qnorm(rand) ;

for i=1:20
    if i<=10
        bi = 20 ;
    else
        bi = (-1)^i ;%qnorm(rand) ;% (-1)^i ;
    end
    Y = Y + bi*W(:,i) ;
end
for i=1:19
    for j=i+1:20
        if (i<=6) && (j<=6)
            bij = -15 ;
        else
            bij = (-1)^(i+j) ;%qnorm(rand) ;%(-1)^(i+j) ;
        end
        Y = Y + bij*W(:,i).*W(:,j) ;
    end
end
for i=1:18
    for j=i+1:19
        for k=j+1:20
            if (i<=5) && (j<=5) && (k<=5)
                bijl = -10 ;
            else
                bijl = 0 ;
            end
            Y = Y + bijl*W(:,i).*W(:,j).*W(:,k) ;
        end
    end
end

bijls = 5 ;

Y = Y + ...
    bijls*W(:,1).*W(:,2).*W(:,3).*W(:,4) ;


% %     function (x)
% % {
% %     w <- 2 * (x - 0.5)
% %     w[, c(3, 5, 7)] <- 2 * (1.1 * x[, c(3, 5, 7)]/(x[, c(3, 5,
% %         7)] + 0.1) - 0.5)
% %     y <- b0
% %     for (i in 1:20) y <- y + b1[i] * w[, i]
% %     for (i in 1:19) for (j in (i + 1):20) y <- y + b2[i, j] *
% %         w[, i] * w[, j]
% %     for (i in 1:18) for (j in (i + 1):19) for (k in (j + 1):20) y <- y +
% %         b3[i, j, k] * w[, i] * w[, j] * w[, k]
% %     for (i in 1:17) for (j in (i + 1):18) for (k in (j + 1):19) for (l in (k +
% %         1):20) y <- y + b4[i, j, k, l] * w[, i] * w[, j] * w[,
% %         k] * w[, l]
% %     y
% % }
% %
% % %     end


