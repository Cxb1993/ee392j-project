% [xn,yn] = selectnodes(f1,f2,mu,mv,N);
% selects up to N nodes for a mesh representation based
% on f1, f2 and the motion vectors mu,mv from f1 to f2.
function [xn,yn]=selectnodes(f1,f2,mu,mv,N,cdm),

[NY,NX]=size(f1);
[xg,yg]=meshgrid(1:NX,1:NY);
mindist2=10;

% Initialization
%marked=zeros(size(f1)); % label all pixels 'unmarked'
marked=cdm;
xn=[]; yn=[]; % start with no node points
dist2tonearest=repmat(inf,size(f1)); % sqr distance to nearest node point
indlegal=1:(NY*NX);

% precompute node selection function
[Sx,Sy]=est_gradient(f1);
C=abs(Sx)+abs(Sy);

% Modify C to enforce screen edge node selections
NXnodes=sqrt(N)/2; NYnodes=NXnodes*3/4;
horizedgelocs=round(linspace(1,NX,round(NXnodes)));
vertedgelocs=round(linspace(1,NY,round(NYnodes)));
C(1,horizedgelocs)=inf;
C(end,horizedgelocs)=inf;
C(1,vertedgelocs)=inf;
C(end,vertedgelocs)=inf;

% Precompute motion compensated prediction
f2mcp=mcp(f1,mu,mv);

while(length(xn)<N)
	% index unmarked pixels
	unmarked=find(marked==0);

	% Compute the DFD
	DFD=f2mcp-f2;
	DFDunmarked=DFD(unmarked);
	DFDunmarkedenergy = DFDunmarked.*DFDunmarked;
	DFDenergy=DFD.*DFD;
	DFDavg = mean(DFDunmarkedenergy);
	
	% Find max-C point that's not too close to someone else.
	indlegal=find(dist2tonearest>=mindist2);
	if(isempty(indlegal))
		break; % we're done, no more nodes to add
   end;
   
	[maxC,indmaxC]=max(C(indlegal));
	indchoose=indlegal(min(indmaxC));
   
	% Add it to the node list
	xn=[xn;xg(indchoose)]; yn=[yn;yg(indchoose)];
   
	% Grow a circle around it till encircled DFDenergy exceeds DFDavg
	incircle=indchoose; radiustimes2=0; radiussqr=0;
	distsqr=(xg-xn(end)).^2+(yg-yn(end)).^2;
	while(sum(DFDenergy(incircle))<=DFDavg)
		radiussqr=radiussqr+radiustimes2+1;
		radiustimes2 = radiustimes2+2;
		incircle=find(distsqr<=radiussqr);
	end;
	marked(incircle)=1;
	dist2tonearest=min(dist2tonearest,(xg-xn(end)).^2+(yg-yn(end)).^2);
end;

figure(3);clf;hold off;
image(double(marked)*255);

figure(4);clf;hold off;
imagesc(sqrt(dist2tonearest));

figure(5);clf;hold off;
imagesc(C);