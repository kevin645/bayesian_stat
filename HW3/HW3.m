%PART 1 %%%%%%%%%%%%%%%%%%
C = [1 0.8; 0.8 1;];
cauchy = mvtrnd(C, 1, 1000);
figure(1)
scatter(cauchy(:, 1), cauchy(:, 2));
title('1000 Pgoint Cauchy Simulation')
xlabel('X Coordinate')
ylabel('Y Coordinate')

%PART 2 %%%%%%%%%%%%%%%%%%
x = [ones(size(cauchy, 1), 1) cauchy(:, 1)];
y = cauchy(:, 2);
sigma = 1;
%beta = mvnrnd((x'*x)^(-1)*x'*y, sigma^2 * (x'*x)^(-1));
beta = ((x'*x)^(-1)*x'*y)';
y_plot = x * beta';
resid = y - y_plot;

figure(2);
subplot(1, 2, 1)
scatter(1:size(resid, 1), resid);
title('Residual Plot')
xlabel('Data Points')
ylabel('Error from Ground Truth')

subplot(1, 2, 2)
qqplot(resid);
