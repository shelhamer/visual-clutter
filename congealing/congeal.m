function [ims_congealed] = congeal(ims)
  % find a joint alignment of a set of binary images by minimizing
  % the entropy of the pixel stacks throughout the set

  % keep original images for generating transformations
  orig_ims = ims;
  num_ims = size(ims,3);

  % append a "gray" (half black / half white) image to sequence
  % for smoothing entropy estimates (this image is never transformed)
  im_gray = zeros([size(ims, 1) size(ims, 2)]) + .5;
  ims(:,:,end+1) = im_gray;

  % initialize transformation params to identity transformation
  % y, x, rot, scale y, scale x, shear y, shear x
  tform = zeros([num_ims 7]);

  % set param gradations
  d_trans = 1;
  d_rot = pi/32;
  d_scl = .1;
  d_shear = .1;

  % congeal until convergence
  iter = 1;
  improved = true;
  while improved

    h_min = sumOfStackEntropies(ims);
    improved = false;

    fprintf('iteration %d entropy %f\n', iter, h_min)

    % take a gradient step for each image by picking
    % entropy minimizing transformation
    for im=1:num_ims
      this_tform = tform(im,:);

      % transformations & sum of stack entropies for each parameter step
      step_tform = zeros([14 7]);
      step_h = zeros([14 1]);

      % translation
      step_tform(1,:) = this_tform + [d_trans 0 0 0 0 0 0];
      step_tform(2,:) = this_tform + [-d_trans 0 0 0 0 0 0];
      step_tform(3,:) = this_tform + [0 d_trans 0 0 0 0 0];
      step_tform(4,:) = this_tform + [0 -d_trans 0 0 0 0 0];
      step_h(1) = evalTransform(im, step_tform(1,:), ims, orig_ims);
      step_h(2) = evalTransform(im, step_tform(2,:), ims, orig_ims);
      step_h(3) = evalTransform(im, step_tform(3,:), ims, orig_ims);
      step_h(4) = evalTransform(im, step_tform(4,:), ims, orig_ims);

      % rotation
      step_tform(5,:) = this_tform + [0 0 d_rot 0 0 0 0];
      step_tform(6,:) = this_tform + [0 0 -d_rot 0 0 0 0];
      step_h(5) = evalTransform(im, step_tform(5,:), ims, orig_ims);
      step_h(6) = evalTransform(im, step_tform(6,:), ims, orig_ims);

      % scale
      step_tform(7,:) = this_tform + [0 0 0 d_scl 0 0 0];
      step_tform(8,:) = this_tform + [0 0 0 -d_scl 0 0 0];
      step_tform(9,:) = this_tform + [0 0 0 0 d_scl 0 0];
      step_tform(10,:) = this_tform + [0 0 0 0 -d_scl 0 0];
      step_h(7) = evalTransform(im, step_tform(7,:), ims, orig_ims);
      step_h(8) = evalTransform(im, step_tform(8,:), ims, orig_ims);
      step_h(9) = evalTransform(im, step_tform(9,:), ims, orig_ims);
      step_h(10) = evalTransform(im, step_tform(10,:), ims, orig_ims);

      % shear
      step_tform(11,:) = this_tform + [0 0 0 0 0 d_shear 0];
      step_tform(12,:) = this_tform + [0 0 0 0 0 -d_shear 0];
      step_tform(13,:) = this_tform + [0 0 0 0 0 0 d_shear];
      step_tform(14,:) = this_tform + [0 0 0 0 0 0 -d_shear];
      step_h(11)  = evalTransform(im, step_tform(11,:), ims, orig_ims);
      step_h(12) = evalTransform(im, step_tform(12,:), ims, orig_ims);
      step_h(13) = evalTransform(im, step_tform(13,:), ims, orig_ims);
      step_h(14) = evalTransform(im, step_tform(14,:), ims, orig_ims);

      % keep the transformation and image that
      % minimize the sum of stack entropies
      % (if such a transformation exists)
      [h_new idx] = min(step_h);
      if h_new < h_min
        h_min = h_new;

        ims(:,:,im) = transformImage(orig_ims(:,:,im), step_tform(idx,:));
        tform(im,:) = step_tform(idx,:);

        improved = true;
      end
    end

    % avoid parameter drift by rebalancing each param to have mean = 0
    tform = tform - repmat(mean(tform), [num_ims 1]);

    iter = iter + 1;
  end

  ims_congealed = ims(:,:,1:end-1);
end

function [H] = evalTransform(im_idx, tform, ims, orig_ims)
  % calculate the sum of stack entropies for a transformation of a single image
  im_tformed = transformImage(orig_ims(:,:,im_idx), tform);
  ims(:,:,im_idx) = im_tformed;
  H = sumOfStackEntropies(ims);
end
