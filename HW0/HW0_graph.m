theta = [-3 -2 -1 0 1 2 3 4];
prior = [0.1 0.3 0.05 0.15 0.05 0.1 0.2 0.05];
likelihood = [0.5 2 1 3 1 3 2 0.5];
post = likelihood.*prior;
expected_value = sum(post.*theta);

plot(theta, likelihood, 'r-.o', theta, prior, 'b-.o', theta, post, '-og');
legend('L(\Theta|X)', 'p(\Theta)', 'p(X|\Theta)', 'Location', 'northwest')
xlabel('Theta');
ylabel('Probablitiy/Likelihood Values');
title('Graphs of Prior/Likelihood/Posterior Distributions');
print -depsc Problem2Graph.eps