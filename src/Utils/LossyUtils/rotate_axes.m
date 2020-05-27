function Vr = rotate_axes(V,tx,ty,tz)
rot_yz = [  1       0       0      ;
            0     cos(tx)  sin(tx) ;
            0    -sin(tx)  cos(tx)];
      
rot_xz = [cos(ty)    0     sin(ty) ;
            0        1       0     ;
         -sin(ty)    0     cos(ty)];
     
rot_xy = [cos(tz)  sin(tz)    0  ;
         -sin(tz)  cos(tz)    0  ;
            0       0         1 ];
        
rotM = rot_yz * rot_xz * rot_xy;

Vr = round(V * rotM, 8);
end %function
