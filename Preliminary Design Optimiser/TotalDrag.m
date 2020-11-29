

function [CD_i,CD_Total]=TotalDrag(AspectRatio,ARhoriz,CL_a,i_w_approx,SHoriz,Sref,CD_0)
e_wing=0.74;
e_tail=0.86;
K=1/(pi*AspectRatio*e_wing);
Kh=1/(pi*ARhoriz*e_tail);
eta_h=0.9;
i_w_approx_rad=i_w_approx*(pi/180);
alpha=0.0775; % Assumed
CL_h=0.04; % Assumed
CD_i=K.*(CL_a.*(alpha+i_w_approx_rad)).^2+((eta_h).*(SHoriz/Sref).*Kh*(CL_h).^2);
CD_Total=CD_0+CD_i;
end 