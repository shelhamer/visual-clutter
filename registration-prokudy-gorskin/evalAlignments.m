function [ims trans] = evalAlignments(im_combined)
  ims = zeros([floor(size(im_combined) ./ [3 1]) 3 4]);
  trans = zeros([2 2 4]);

  for i=[1 4 6 8]
    idx = ceil(i/2);
    [ims(:,:,:,idx) trans(:,:,idx)] = alignMaxMutInfo(im_combined, 2^i);
  end
end