%Creating the random indendenten uniformly distributed variables for the
%Ishigami Function

pi = 3.14;

x1 = unifrnd(-pi,pi,1000,1);
x2 = unifrnd(-pi,pi,1000,1);
x3 = unifrnd(-pi,pi,1000,1);

X = [x1,x2,x3];

%Output of the Ishigami Function
y = uq_ishigami(X);

pd_uni = makedist('Uniform','lower',-pi,'upper',pi);

x = -pi:(2*pi)/999:pi;
y_uni = pdf(pd_uni,x);

%Uniform Output probability density...maybe we will need it one day
y_uni = y_uni';

%Plot of the probability densitiy of the output...obviously it is uniform
figure;
stairs(x,y_uni);
xlim([-5, 5]),ylim([-0.2,0.2]);

y_mean_tot = mean(y,1);

%Just to check whether the mean is computed correctly
y_mean_hand = 1/length(y)*sum(y,1);

if((y_mean_tot-y_mean_hand)<1e-15)
    
else
   print('Wrong mean...just Huston we have got a problem'); 
end

%Computation of the MC Simulation
s_tot_hand = sqrt(1/(length(y)-1) *(sum(y(:)-y_mean_tot))^2);

s_tot = std(y,1);

y_mean = 1:length(x);
sd = 1:length(x);
for i=1:length(x)
    y_mean(i) = mean(y(1:i,1));
    sd(i) = sqrt(1/(length(y_mean(i)-1))*sum(y_mean(i(:))-y_mean_tot)^2);
end

y_mean = y_mean';

sd = sd';

range = 1:length(x);

%Plot of the MC simulation...convergence toward the mean with increasing 
%sample numbers 
figure;
plot(range,y_mean_tot,'o');
hold on;
plot(y_mean);
xlabel('Amount of Samples'),ylabel('Mean of the Ishigami Output');
hold off;

%Plot of the MC simulation for the Standard Deviation
figure;
plot(range,s_tot_hand,'x');
hold on;
plot(sd);
xlabel('Amount of Samples'),ylabel('SD for the Ishigami Output');

% Presentation of the value s_tot...problem to calculate s_tot_hand
% automatically....
% figure;
% scatter(x,y);
% lsline;
% hold on;
% plot(y_mean_tot,'r');
% plot(s_tot,'g');
% hold off;

% Calculating the least squares 
x = x';

p = polyfit(x,y,15);

y_poly = polyval(p,x);

figure;
scatter(x,y);
lsline;
hold on;
plot(x,y_poly);
hold off;




