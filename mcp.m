% MCP(f1,mu,mv) - motion-compensated prediction of next
%                 frame given the motion vectors (mu,mv).
function f2 = mcp(f1,mu,mv)

[NY,NX]=size(f1);
[xg,yg]=meshgrid(1:NX,1:NY);
xgp=xg-mu;
ygp=yg-mv;
xgp(xgp<1)=1; xgp(xgp>NX)=NX;
ygp(ygp<1)=1; ygp(ygp>NY)=NY;

f2 = griddata(xgp,ygp,f1,xg,yg,'linear');
f2(isnan(f2))=0;

