function [marginal] = marginalize(p, d)
  % compute marginal distribution of a random var. from a joint distribution

  marginal = sum(p, d);
end