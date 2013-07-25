% [mu,mv] = hsme(f1,f2,mu,mv,N,c)
% Performs dense motion estimation by N Horn-Schunck relaxations
% with smoothness emphasis c. Default N is 10, default c is 15.
% mu and mv are initial motion estimates, computed for example
% using block matching and interpolation.
function [mu,mv] = hsme(f1,f2,mu,mv,N,c)

% Sanity checks
if(nargin<4),
	error('Need at least 4 arguments');
end;

if(nargin<5),
	N=10;
end;

if(nargin<6),
	c=15;
end;

% Sanity checking
[NY,NX]=size(f1);
if(size(f2)~=[NY,NX]),
	error('Hey dude, frames must be the same size!');
end;

% Temporal derivative estimation
St=f2-f1;

% Filter for spatial gradient estimation
[fx,fy]=meshgrid(-2:2,-2:2);
filto=exp(-(fx.^2+fy.^2)/5); filto=filto/sum(sum(filto));
f1=filter2(filto,f1);

% Estimate spatial gradient
Sx=[diff(f1(:,1:2)')' 0.5*(f1(:,3:end)-f1(:,1:end-2)) diff(f1(:,end-1:end)')'];
Sy=[diff(f1(1:2,:));0.5*(f1(3:end,:)-f1(1:end-2,:));diff(f1(end-1:end,:))];
SxSx=Sx.*Sx; SxSy=Sx.*Sy; SySy=Sy.*Sy; SxSt=Sx.*St; SySt=Sy.*St;

if(N>0),
	c=c*c;
	normsqrgrad=SxSx+SySy;
	idenom=1./(c+normsqrgrad);
end;

[fx,fy]=meshgrid(-1:1,-1:1);
filt=exp(-(fx.^2+fy.^2)); filt=filt/sum(sum(filt));
while(N>0),
	% filter with a fairly sharp 3x3 gaussian kernel
	muf=filter2(filt,[mu(1,1)   mu(1,:)   mu(1,end);
                          mu(:,1)   mu        mu(:,end);
                          mu(end,1) mu(end,:) mu(end,end)],'valid');
	mvf=filter2(filt,[mv(1,1)   mv(1,:)   mv(1,end);
                          mv(:,1)   mv        mv(:,end);
                          mv(end,1) mv(end,:) mv(end,end)],'valid');
	
	mu=muf-(SxSx.*muf+SxSy.*mvf+SxSt).*idenom;
	mv=mvf-(SxSy.*muf+SySy.*mvf+SySt).*idenom;
	
	N=N-1;
end;

