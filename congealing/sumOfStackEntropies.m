function [H] = sumOfStackEntropies(ims)
  % calculate the probability of an on pixel for each stack
  stack_ps = sum(ims, 3) ./ size(ims, 3);

  % calculate binary entropy of all stacks and sum
  stack_hs = -stack_ps.*log2(stack_ps) - (1-stack_ps).*log2((1-stack_ps));
  H = sum(stack_hs(:));
end