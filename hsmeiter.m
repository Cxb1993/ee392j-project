% [v1,v2] = hsmeiter(v1,v2,f1,f2,c,Sx,Sy,St,SxSx,SxSy,SySy,SxSt,SySt)
% Performs one relaxation of the Horn-Schunck method,
% updating the estimated dense motion field [v1,v2]
% with smoothing and gradient descent. The emphasis
% on the smoothness constraint is set by c.
%
% All that Sx,Sy,St and products stuff needs to be
% passed in, since I'm expecting that they've already
% been computed when the initial motion field was
% constructed.
function [v1n,v2n] = hsmeiter(v1,v2,f1,f2,c,Sx,Sy,St,SxSx,SxSy,SxSt,SySt)

[fx,fy]=meshgrid(-1:1,-1:1);
filt=exp(-(fx.^2+fy.^2)/3); filt=filt/norm(filt(:));
v1f=filter2(filt,v1);
v2f=filter2(filt,v2);

idenom=1/(c+SxSx+SySy);
v1n=v1f-(SxSx.*v1f+SxSy.*v2f+SxSt).*idenom;
v2n=v2f-(SxSy.*v1f+SySy.*v2f+SySt).*idenom;
