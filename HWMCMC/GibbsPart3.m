K = 2;
N = 100;
p = ones(K,1)*(1/K);
sampleMu = linspace(1, 15, K);
sampleSigma = linspace(1, 10, K); %[1.5, 2.25, 1.75, 2.5, 2.75];
sampSpace = mnrnd(N, p, 1);
mixedModel = cell(K, 1);
for k=1:K
    mixedModel{k} = normrnd(sampleMu(k), sampleSigma(k), sampSpace(k), 1);
end
mixedModel = cell2mat(mixedModel); 
mixedModel = mixedModel(randperm(N));

T = 10000;
Burnin = 200;
thetaj = zeros(T, K, 2); % Iterations x Modes x [mu, phi]
thetaj(1, :, 1) = linspace(1, 25, K) + 15; %1:K; %[1, 2, 3, 4, 5]; % mu init
thetaj(1, :, 2) = linspace(1, 10, K) + 5; %1:K; %[1, 2, 3, 4, 5]; % phi init

% Generate Cluster Assignments
clusterI = mnrnd(1, p, N)>0; 
clusters = zeros(T, N);
for k=1:K
    clusters(1, clusterI(:, k)) = k;
end

for t=2:T
    % Step 1: Generate New Cluster Assignments with proposed mu's/phi's
    % Generate logPDFs for the entire dataset 
    logPDFs = zeros(K, N);
    for k=1:K
       logPDFs(k, :) = log(normpdf(mixedModel, thetaj(t-1, k, 1), sqrt(1/thetaj(t-1, k, 2))));
    end
    maxPDFs = max(logPDFs,[], 1);
    % log pi_max + log(sum(e^(log pi_max - log pi_i))
    marginalModes = maxPDFs' + log(sum(exp(bsxfun(@minus, logPDFs', maxPDFs')), 2));
    % prob(C_i = j) = exp(log piPDFs - log marginal) probability for a
    % given sample to be in any cluster
    clusterProb = exp(bsxfun(@minus, logPDFs', marginalModes));
    % To provide stability and clearing up round off errors for mnrnd
    clusterProb(:, end) = 1 - sum(clusterProb(:, 1:end-1), 2);
    % For a given sample acquire the probabilities and categorically pick
    % them and perform an assignment for that sample.
    clusterI = mnrnd(1, clusterProb)>0;
    for k=1:K
       clusters(t, clusterI(:, k)) = k;
    end

    % Step 2: Update the mu's/phi's with proposed cluster assignments
    for k =1:K
        % Acquire the clustered data for a given cluster
        currX = mixedModel(clusters(t, :) == k);
        if length(currX) == 0
            disp([t, length(currX)])
        end
        % Updating the Mu/Phi's for the given Cluster
        thetaj(t, k, 1) = normrnd(mean(currX), sqrt(1/(length(currX)*thetaj(t-1, k, 2))));
        thetaj(t, k, 2) = gamrnd(length(currX)/2, 2/(sum((currX - thetaj(t, k, 1)).^2)));
    end
end
subplot(2,2,1)
plot(1:T, thetaj(1:T, :, 1))
xlabel('Iterations'); ylabel('\mu Values'); title('Before Burn-in: \mu Trace Plots')
subplot(2,2,2)
plot(1:T, sqrt(1./thetaj(1:T, :, 2)))
xlabel('Iterations'); ylabel('\sigma Values'); title('Before Burn-in: \sigma Trace Plots')
subplot(2,2,3)
plot(Burnin:T, thetaj(Burnin:T, :, 1))
xlabel('Iterations'); ylabel('\mu Values'); title('After Burn-in: \mu Trace Plots')
subplot(2,2,4)
plot(Burnin:T, sqrt(1./thetaj(Burnin:T, :, 2)))
xlabel('Iterations'); ylabel('\sigma Values'); title('After Burn-in: \sigma Trace Plots')