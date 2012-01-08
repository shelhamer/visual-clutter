function [colors] = select_colors(test_im, training_ims, b)
  % determine the correct mapping of color plates by picking the
  % the ordering with the lowest kl divergence from a color distribution
  % estimated from another set of prokudin-gorski images
  % return mapping of channels to rgb (ex: [1 2 3] = rgb, [2 3 1] = brg)
  
  color_dist = estimate_color_dist(training_ims, b);
  prms = perms(1:3);
  
  min_d = Inf;
  min_perm = [0 0 0];
  for i=1:6
    color_im = swap_colors(test_im, prms(i,:));
    % figure ; imagesc(color_im)
    d = kl_divergence(estimate_color_dist(color_im, b), color_dist);
    
    if d < min_d
      min_d = d;
      min_perm = prms(i,:);
    end
  end
  
  colors = min_perm;
end

function [p] = estimate_color_dist(ims, b)
  sclr_pix = scalarize(ims, b);
  color_histo = histc(sclr_pix(:), 1+b+b^2:b+b^2+b^3);
  p = color_histo ./ sum(color_histo);
end

function [d] = kl_divergence(p, q)
  % filter out zeros (infinite KL divergence)
  p = p(p > 0);
  q = q(p > 0);
  p = p(q > 0);
  q = q(q > 0);

  % calculate
  d = sum(p .* log2(p./q));
end

function [sclr_pix] = scalarize(ims, b)
  ims = double(ims);
  ims = ceil((ims+1) ./ (256 / b));
  sclr_pix = ims(:,:,1,:) * b^2 + ...
             ims(:,:,2,:) * b + ...
             ims(:,:,3,:);
end