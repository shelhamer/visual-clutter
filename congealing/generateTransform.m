function [affine] = generateTransform(tform)
  % create and compose matrices for translation, rotation, scale, and shearing
  % applied in the fixed order of shear, scale, rotate, translate
  % s.t. each transformation is uniquely determined

  pos = tform(1:2);
  rot = tform(3);
  scl = tform(4:5);
  shear = tform(6:7);

  [shear_x shear_y] = mk_shear(shear);
  shear = shear_y * shear_x;
  shear_scale = shear * mk_scl(scl);
  shear_scale_rot = shear_scale * mk_rot(rot);
  affine = shear_scale_rot * mk_trans(pos);
end

%% transformation helper functions for construction affine matrices
function [tform] = mk_trans(pos)
  tform = [ 1 0 pos(2) ; 0 1 pos(1) ; 0 0 1 ];
end

function [tform] = mk_rot(theta)
  tform = [ cos(theta) -sin(theta) 0 ; sin(theta) cos(theta) 0 ; 0 0 1];
end

function [tform] = mk_scl(scl)
  tform = [ exp(scl(2)) 0 0 ; 0 exp(scl(1)) 0 ; 0 0 1];
end

function [tform_x tform_y] = mk_shear(shear)
  tform_x = [ 1 shear(2) 0 ; 0 1 0 ; 0 0 1 ];
  tform_y = [ 1 0 0 ; shear(1) 1 0 ; 0 0 1 ];
end