% Problem 2

% Part A
theta = [10, 15, 17, 20];
sigmaSq = 5;
modelSize = 1000;

mixedModels = zeros(modelSize, 1);
mixedModels(1:400) = normrnd(theta(1), sigmaSq, [400, 1]);
mixedModels(401:600) = normrnd(theta(2), sigmaSq, [200, 1]);
mixedModels(601:900) = normrnd(theta(3), sigmaSq, [300, 1]);
mixedModels(901:end) = normrnd(theta(4), sigmaSq, [100, 1]);
figure(1);
hist(mixedModels); xlabel('Sample Values'); ylabel('Frequency'); title('Histogram of the Data');

% Part D
mixedModels2 = mixedModels(randperm(modelSize));
figure(2);
plot(1:modelSize, mixedModels2); xlabel('Iteration'); ylabel('Sample Values'); title('Scatterplot Showing Randomized Samples');

% Part E & F
H0 = theta(1);
prior = zeros(length(theta), modelSize);
prior(:, 1) = log(1/4);
pval = zeros(length(theta), modelSize);
cummean = cumsum(mixedModels2)./(1:1000)';
prior(1, :) = exp((cummean - theta(1)).^2 .* ((1:1000)'/sigmaSq) .* (-1/2));
prior(2, :) = exp((cummean - theta(2)).^2 .* ((1:1000)'/sigmaSq) .* (-1/2));
prior(3, :) = exp((cummean - theta(3)).^2 .* ((1:1000)'/sigmaSq) .* (-1/2));
prior(4, :) = exp((cummean - theta(4)).^2 .* ((1:1000)'/sigmaSq) .* (-1/2));

for i=1:modelSize
    pval(:, i) = 2*(tcdf(-abs((mean(mixedModels2(1:i)) - theta))/(std(mixedModels2(1:i))/sqrt(i)), i));
end
normalize = sum(prior, 1);
prior(1, :) = prior(1, :) ./ normalize;
prior(2, :) = prior(2, :) ./ normalize;
prior(3, :) = prior(3, :) ./ normalize;
prior(4, :) = prior(4, :) ./ normalize;

%Part E
% Plot Posteriors
figure(3);
tmp = modelSize;
for i=1:length(theta)
    subplot(2, 2, i)
    plot(1:tmp, prior(i, 1:tmp)); 
    title(['\mu = ', num2str(theta(i))]); 
    xlabel('Iterations'); ylabel('Probability');
end
% Part F
% Plot P Values
figure(4);
for i=1:length(theta)
    subplot(2, 2, i)
    plot(1:tmp, pval(i, 1:tmp)); 
    title(['\mu = ', num2str(theta(i))]); 
    xlabel('Iterations'); ylabel('P Value');
end
