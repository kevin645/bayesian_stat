N = 30;
frequency = zeros(99, 1);
temp = 1;
%{
for p=0.01:0.01:0.99
    for i=1:10000
        x = binornd(N, p);
        p_hat = x/N;
        sigma_hat = sqrt((p_hat*(1-p_hat))/N);
        upper_bound = p_hat + 1.96* sigma_hat;
        lower_bound = p_hat - 1.96* sigma_hat;
        if p >= lower_bound && p <= upper_bound
            frequency(temp, 1) = frequency(temp, 1) + 1;
        end      
    end
    temp = temp + 1;
end
p = 0.01:0.01:0.99;
plot(p, frequency)
xlabel('Probabilities p')
ylabel('Frequency of Coverage')
%}
%HW2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
alpha = 0.5;
beta = 0.5;
frequency = zeros(99, 1);
N = 30;
totalX = zeros(10000, 1);
temp = 1;
for p=0.50:0.01:0.52
    for j=1:10000
        x = binornd(N, p);
        totalX(j) = betarnd(x(j) + alpha, beta + N - x; 10000, 1);
        aSort = sort(totalX, 'ascend');
        upper_bound = aSort(9750);
        lower_bound = aSort(250);
        if p >= lower_bound && p <= upper_bound
            frequency(temp, 1) = frequency(temp, 1) + 1;
        end
    end
    plot(frequency(temp,1));
    break;
    temp = temp + 1;
end
%}

alpha = 0.5;
beta = 0.5;
frequency = zeros(99, 1);
N = 100;
totalX = zeros(10000, 10000, 1);
temp = 1;
for p=0.01:0.01:0.99
    p
    x = binornd(N, p, 10000, 1);
    alphaStar = x + alpha;
    betaStar = beta + N - x;
    for j=1:10000
        totalX(:, j) = betarnd(alphaStar, betaStar);
    end
    aSort = sort(totalX, 2);
    upper_bound = aSort(:, 9750) >= p;
    lower_bound = aSort(:, 250) <= p;
    frequency(temp, 1) = sum(upper_bound == lower_bound);
    temp = temp + 1;
end
p = 0.01:0.01:0.99;
plot(p, frequency)
xlabel('Probabilities p')
ylabel('Frequency of Coverage')
