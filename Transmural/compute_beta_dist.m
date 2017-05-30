function [ gamma ] = compute_beta_dist(mean, sd, theta)
    gamma = pdf(makedist('Normal', 'mu', mean, 'sigma', sd), theta);
end