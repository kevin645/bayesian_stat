K = 10000;
P = 0.5;
T = 10000;
storage = nbinrnd(1, 0.5, K, T);
winnings = 2.^storage;
avgwin = mean(winnings, 2);
tmp = K*ones(T, 1);
subplot(1,2,1)
scatter(tmp, avgwin);
xlabel('Number of Games for which average was computed')
ylabel('Expected Winnings')
title('Average Winnings over 10,000 Trials')
subplot(1,2,2)
scatter(tmp, log(avgwin));
xlabel('Number of Games for which average was computed')
ylabel('Expected Winnings in Log Scale')
title('Average Winnings over 10,000 Trials')

a = unique(storage);
out = [a,histc(storage(:),a)];
out(:, 1) = 2.^out(:, 1);

subplot(1,2,1)
scatter(out(:, 2), out(:, 1));
xlabel('Number of Occurances of Winnings')
ylabel('Expected Winnings')
title('Occurances of Winnings')
subplot(1,2,2)
scatter(log(out(:, 2)), log(out(:, 1)));
xlabel('Number of Occurances of Winnings in Log Scale')
ylabel('Expected Winnings in Log Scale')
title('Occurances of Winnings in Log Scale')
