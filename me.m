% out=me(f1,f2) returns a motion vector estimate produced
% by block correlation on the change detection mask, followed
% by Horn-Schunck iterations.
function [uh,vh] = me(f1,f2)

[NY,NX]=size(f1);

% Compute change detection mask
cdm  = compute_cdm(f1,f2,25);

% Do block correlation motion estimation on the mask
B=7;  % block size for BC ME
r=15; % search range for BC ME
spars=4; % sparsity of BC ME
[ix,iy]=find(cdm~=0);
xmin=max(1+B+r,min(ix)-spars); xmax=min(NX-B-r,max(ix)+spars);
ymin=max(1+B+r,min(iy)-spars); ymax=min(NY-B-r,max(iy)+spars);
xb=xmin:spars:xmax; yb=ymin:spars:ymax;
[ub,vb] = bcme(f1,f2,xb,yb,B,r);

% Refine the motion estimate to a dense one by Horn-Schunck
ud=interp2(xb,yb,ub,1:NX,(1:NY)','cubic');
vd=interp2(xb,yb,vb,1:NX,(1:NY)','cubic');
ud(isnan(ud))=0; vd(isnan(vd))=0;
[uh,vh]=hsme(f1,f2,ud,vd,10,31);