function [p] = distributionFromImage(im, b)
  % calculate probability distribution of image values
  % by binning, constructing a histogram, and normalizing
  
  im = ceil((im+1) ./ (256 / b));
  histo = histc(im(:), 1:b)
  p = histo ./ sum(histo);
end