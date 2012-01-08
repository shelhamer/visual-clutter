function [im_tform] = transformImage(im, tform)
  % transform an image according to affine parameters
  % by backward mapping pixels to original image

  % transformed image
  im_sz = size(im);
  im_tform = zeros(im_sz);

  % create homogenous coordinates (for easy transformation via
  % matrix multiplication)
  [im_x im_y] = meshgrid(1:size(im, 2), 1:size(im, 1));
  coords = [im_x(:)' ; im_y(:)'];
  coords(3, :) = 1;

  % generate affine transformation matrix (invert for backward mapping)
  % along w/ to & from origin transforms (for proper rotation, etc.)
  tform_affine = generateTransform(tform);
  to_origin = generateTransform([-size(im) / 2 0 0 0 0 0]);
  from_origin = generateTransform([size(im) / 2 0 0 0 0 0]);
  tform_total = from_origin * tform_affine * to_origin;
  tform_back = inv(tform_total);

  % calculate backward affine mapping
  map = tform_back * coords;
  map = map(1:2, :);
  map = round(map); % nearest neighbor interpolation

  % separate valid and invalid (out of bounds) pixels
  is_valid = @(y,x,limits) ( ...
              (x >= 1) & (y >= 1) & (x <= limits(2)) & (y <= limits(1)));
  idx_valid = find(is_valid(map(2,:), map(1,:), im_sz));
  map_valid = map(:, idx_valid);

  % fill in backward mapped image pixels
  map_idx = sub2ind(im_sz, map_valid(2,:), map_valid(1,:));
  im_tform(idx_valid) = im(map_idx);
end