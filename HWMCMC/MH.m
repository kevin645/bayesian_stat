
% Generate the Data
N = 100;
X = normrnd(200, sqrt(2), [N, 1]);
Xbar = mean(X);

T = 2000000;
Burnin = 200;
mu = zeros(T, 1); 
mu(1) = 0;
phi = zeros(T, 1); 
phi(1) = 5;
proposeVarMu = 1000;
proposeVarPhi = 1;
temp = 0;
for t=2:T
   %disp(t)
   mustar = normrnd(mu(t-1), sqrt(proposeVarMu));
   phistar = -1;
   while phistar < 0
       phistar = normrnd(phi(t-1), sqrt(proposeVarPhi));
   end
   %disp(phistar)
   %pistar = phistar^(N/2 - 1)*exp((-phistar/2)*(sum(X.^2) - 2*mustar*N*Xbar + N*mustar.^2)) * normcdf(phistar);
   %pit = phi(t-1)^(N/2 - 1)   *exp((-phi(t-1)/2)*(sum(X.^2) - 2*mu(t-1)*N*Xbar + N*mu(t-1).^2)) * normcdf(phi(t-1));
   pistar = log(phistar)*(N/2 - 1) + (-phistar/2)*(sum(X.^2) - 2*mustar*N*Xbar + N*mustar.^2) + log(normcdf(phistar/proposeVarPhi));
   pit = log(phi(t-1))*(N/2 - 1)  + (-phi(t-1)/2)*(sum(X.^2) - 2*mu(t-1)*N*Xbar + N*mu(t-1).^2) + log(normcdf(phi(t-1)/proposeVarPhi));
   %disp([pistar, pit])
   if (log(rand) <= (pistar - pit))
       mu(t) = mustar;
       phi(t) = phistar;
   else
       mu(t) = mu(t-1);
       phi(t)= phi(t-1);
   end
   disp(mu(t))
end
subplot(3,2,1)
plot(1:T, mu(1:T));
xlabel('Iterations');ylabel('\mu Value'); title('\mu Trace Before Burn-in ');
subplot(3,2,2)
plot(1:T, phi(1:T))
xlabel('Iterations');ylabel('\phi Value'); title('\phi Trace Before Burn-in ');
subplot(3,2,3)
plot(Burnin:T, mu(Burnin:T));
xlabel('Iterations');ylabel('\mu Value'); title('\mu Trace After Burn-in ');
subplot(3,2,4)
disp(Burnin)
plot(Burnin:T, phi(Burnin:T))
xlabel('Iterations');ylabel('\phi Value'); title('\phi Trace After Burn-in ');
subplot(3,2,5)
histogram(mu(Burnin:T), 30);
xlabel('\mu Bins'); ylabel('Frequencies'); title('\mu Histogram After Burn-in');
subplot(3,2,6)
histogram(phi(Burnin:T), 30);
xlabel('\phi Bins'); ylabel('Frequencies'); title('\phi Histogram After Burn-in');