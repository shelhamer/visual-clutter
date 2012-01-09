function [H] = entropy(p)
  % calculate entropy of a discrete probability distribution p (as avector)
  
  p = p(p > 0); % strip out zeros to sidestep log(0)
  H = -sum(p .* log2(p));
end