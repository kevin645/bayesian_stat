%PART 1 %%%%%%%%%%%%%%%%%%
%C = [1 0.8; 0.8 1;];
%cauchy = mvtrnd(C, 1, 1000); 
%X = [ones(size(cauchy, 1), 1) cauchy(:, 1)]; Y = cauchy(:, 2);
%figure(1)
%scatter(cauchy(:, 1), cauchy(:, 2));
%title('1000 Pgoint Cauchy Simulation')
%xlabel('X Coordinate')
%ylabel('Y Coordinate')

% Hyperparameter Tuning
T = 1000;
Burnin = 100;
phi0 = 1;
beta0 = [1, 1];
N = size(Y, 1);

gamma = zeros(T, N); 
beta = zeros(T+1, 2); beta(1, :) = beta0;
phi = zeros(T+1, 1); phi(1) = phi0;
% Note: Take Inverse of Gamma dist beta term because matlab sucks
for t=1:T
    gamma(t, :) = gamrnd(1,((phi(t)/2).*(Y - X * beta(t, :)').^2 + 0.5).^(-1));
    Gamma = diag(gamma(t, :));
    beta(t+1, :) = mvnrnd(inv(X'*Gamma*X)*X'*Gamma*Y, (1/phi(t))*inv(X'*Gamma*X));
    %x = X(:, 1);
    %beta(t+1,1) = normrnd((x'*Gamma*Y)*(inv((x'*Gamma*x))),sqrt(phi(t)*x'*Gamma*x)^(-1));
    %x = X(:, 2);
    %beta(t+1,2) = normrnd((x'*Gamma*Y)*(inv((x'*Gamma*x))),sqrt(phi(t)*x'*Gamma*x)^(-1));
    phi(t+1) = gamrnd(N/2, (0.5*((Y - X*beta(t+1, :)')' * Gamma * (Y - X*beta(t+1, :)')))^(-1));
end


figure(1);
clf;
subplot(2, 2, 1)
plot(Burnin+1:T, phi(Burnin+1:T)); 
xlabel('Iterations'); ylabel('Value'); title('\phi Trace Plot with Burn-in');
subplot(2, 2, 2)
plot(Burnin+1:T, beta(Burnin+1:T, :)); 
xlabel('Iterations'); ylabel('Value'); title('\beta Trace Plot with Burn-in'); 
legend('\beta_0', '\beta_1', 'Location', 'southeast');
subplot(2, 2, 3)
histogram(beta(Burnin+1:T, 1)); 
xlabel('\beta_0 Values'); ylabel('Frequency'); title('Marginal Distribution of \beta_0');
subplot(2, 2, 4)
histogram(beta(Burnin+1:T, 2)); 
xlabel('\beta_1 Values'); ylabel('Frequency'); title('Marginal Distribution of \beta_1');