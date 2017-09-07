clear
%rng default
burn_in = 500;
plot_frequency = 50;
diagnostic_freq = 10;
pause_length = .001;
iteration_max = 10000;

covariance = [1 .8; ...
    .8 1];

N = 1000;
xy = mvtrnd(covariance, 1, N);
x = xy(:,1);
y = xy(:,2);

actual_beta = ((x'*x)^-1)*(x'*y); 
actual_phi = .8;
actual_gamma = 1./(((actual_phi*(y-x*actual_beta).^2)/2)+.5);

figure; hold on;

scatter(actual_beta,actual_phi,70,[1 0 0], 'filled')
xlabel('beta')
ylabel('phi')

phi = zeros(iteration_max+1,1);
beta = zeros(iteration_max+1,1);
gamma = zeros(iteration_max+1,length(x));


phi(1) = 1;
beta(1) = 1;
gamma(1,:) = zeros(1,length(x));

for i = 2:iteration_max+1
    %simulate gamma
   
    gamma(i,:) = gamrnd(1, (  (   (phi(i-1) .* ( y - (x.*beta(i-1)) ).^2   )  ./  2) +   .5 )  .^  (-1));
    %gamma(i,:) = ones(1,N);
    %gammaMAT(:,:,i) = diag(gamma(i,:));
    %simulate beta
    beta(i,1) = normrnd((x'.*gamma(i,:)*y)*((x'.*gamma(i,:)*x)^(-1)),sqrt(phi(i-1)*x'.*gamma(i,:)*x)^(-1));
    
    %simulate phi
    phi(i,1) = gamrnd(((N)/2),(.5*((y-x*beta(i))' .* gamma(i,:) * (y-x*beta(i))))^(-1));
    
    if rem((i-1),plot_frequency)==0
        if i < burn_in
            plot([beta(i-plot_frequency) beta(i)],[phi(i-plot_frequency) phi(i)],'r')
        else
            plot([beta(i-plot_frequency) beta(i)],[phi(i-plot_frequency) phi(i)],'k')
        end
        pause(pause_length)
    end
    
end
figure; hold on;
scatter(beta(burn_in+1:end),phi(burn_in+1:end),30,[0 0 0],'filled')
%scatter(actual_beta,actual_phi,120,[1 0 0], 'filled')
xlabel('beta')
ylabel('phi')
figure; hold on;
histogram(beta(burn_in+1:end))
xlabel('beta')
yl = ylim;
%plot([actual_beta actual_beta], [ylim],'--k','LineWidth',1.5)