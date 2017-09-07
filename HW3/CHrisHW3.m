cauchy_samples = mvtrnd([1 0.8; 0.8 1], 1, 1000);
fig = figure(1);
scatter(cauchy_samples(:, 1), cauchy_samples(:, 2))
title('One Thousand Multivariate Cauchy Samples')
xlabel('X')
ylabel('Y')
saveas(fig, 'CauchySamples.pdf')

fig = figure(2);
X = [ones(1000,1) cauchy_samples(:, 1)];
Y = cauchy_samples(:, 2);
beta = (X'*X)^(-1)*X'*Y;
Yhat = X*beta;
residuals = Y - Yhat;
subplot(1,2,1)
scatter(X(:, 2), residuals)
title('Residuals of Least Squares Regression')
xlabel('X')
ylabel('Y - X * Beta')
subplot(1,2,2)
qqplot(residuals)
saveas(fig, 'ResidualAnalysis.pdf')
