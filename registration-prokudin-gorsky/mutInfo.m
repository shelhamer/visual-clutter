function [I] = mutInfo(p)
  % calculate the mutual information from a joint distribution p,
  % where each entry is the joint probability between a single outcome of
  % each random var.

  % compute by entropies of marginals and joint
  x = marginalize(p, 1);
  y = marginalize(p, 2);

  I = entropy(x) + entropy(y) - entropy(p);
end