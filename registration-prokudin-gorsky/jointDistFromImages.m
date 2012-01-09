function [p] = jointDistFromImages(im1, im2, b)
  % calculate joint distribution of pixel values for two (same-size) images by
  % 1.binning pixel values
  % 2.calculating a "joint image" that combines the values at each pixel in the
  % images into a single value
  % 3.construct joint histogram, normalize, and reshape into co-occurence matrix

  im1 = ceil((im1+1) / (256 / b));
  im2 = ceil((im2+1) / (256 / b));
  im_joint = im2(:).*b + im1(:);

  histo = histc(im_joint(:), 1+b:b+b^2);
  p = histo ./ sum(histo);

  p = reshape(p, [b b]);
end