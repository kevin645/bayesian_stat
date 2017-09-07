%sigma = gamrnd(1/2, 1, [1000, 1]);
mu = 0;
gamma = 0.5;
post = normrnd(mu, sigma*gamma);
figure(1), histogram(post, 50)
axis([-4 4 0 500])
min(post)
max(post)