function [im trans] = alignMaxMutInfo(im_combined, b)
  % align prokudin-gorski plates by maximization of mutual information
  % between one "base" plate and the other two plates
  % by grid search of the translations in +-15 in x, y

  % plates are provided as a combined image of each channel, stacked vertically:
  % separate into 3-channel pixel matrix (even if 3 doesn't divide the height)
  im = slice_ims(im_combined);

  % find max mutual information translations against "base" plate
  trans = zeros([2 2]);
  trans(1,:) = findMaxInfoTrans(im(:,:,1), im(:,:,2), b);
  trans(2,:) = findMaxInfoTrans(im(:,:,1), im(:,:,3), b);

  % register the plates according to max mutual info translations
  im(:,:,2) = circshift(im(:,:,2), trans(1,:));
  im(:,:,3) = circshift(im(:,:,3), trans(2,:));

  % convert final image to truecolor mapping [0,1]
  % and set correct color channels
  im = swap_colors(im ./ 255, [3 2 1]);
end

function [im] = slice_ims(im_combined)
  % slice vertically stacked images into a 3-channel pixel matrix

  im_dims = floor(size(im_combined) ./ [3 1]);
  im = zeros([im_dims 3]);
  for i=1:3
    im(1:im_dims(1),:,i) = im_combined((i-1)*im_dims(1)+1:i*im_dims(1), :);
  end
end

function [trans] = findMaxInfoTrans(im1, im2, b)
  % find maximum mutual information for translations
  % in +-15 in x, y

  mi_best = 0;
  trans = [0 0];

  for x=-15:15
    for y=-15:15
      im2_trans = circshift(im2, [y x]);
      mi = mutInfo(jointDistFromImages(im1, im2_trans, b));

      if mi > mi_best
        mi_best = mi;
        trans = [y x];
      end
    end
  end
end