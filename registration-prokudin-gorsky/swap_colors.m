function [im_swap] = swap_colors(im, ord)
  im_swap(:,:,1) = im(:,:,ord(1));
  im_swap(:,:,2) = im(:,:,ord(2));
  im_swap(:,:,3) = im(:,:,ord(3));
end