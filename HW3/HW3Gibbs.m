mu = 200;
phi = 0.5;
x = normrnd(mu, 1/sqrt(phi), [100 1]);
xbar = sum(x)/100;
N = 100;
run = 100;
burnin = 10;
mu0 = zeros(run, 1);
phi0 = zeros(run, 1);
mu0(1) = 0;
phi0(1) = 5;
for i=2:run
    mu0(i) = normrnd(xbar, 1/(phi0(i-1)*N));
    beta = sum(bsxfun(@minus, x, mu0(i)).^2)/2;
    phi0(i) = gamrnd(N/2, 1/beta);
end
subplot(2, 2, 1)
plot(1:run, mu0)
hold on
line([burnin burnin], [0, 300], 'Color', 'r');
hold off
ylabel('\mu Values')
xlabel('Iterations')
title('\mu Traceplot')
legend('\mu', 'Burnin End', 'Location', 'southeast')
subplot(2, 2, 2)
plot(1:run, phi0)
hold on
line([burnin burnin], [0, 6], 'Color', 'r');
hold off
ylabel('\phi Values')
xlabel('Iterations')
title('\phi Traceplot')
legend('\phi', 'Burnin End', 'Location', 'northeast')
subplot(2, 2, 3)
histogram(mu0)
ylabel('\mu Occurences')
xlabel('\mu Bins')
title('\mu Histogram')
subplot(2, 2, 4)
histogram(phi0)
ylabel('\phi Occurences')
xlabel('\phi Bins')
title('\phi Histogram')