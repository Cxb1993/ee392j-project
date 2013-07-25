% [U,V] = BCME(frame1,frame2,x_coords,y_coords,B,r)
% block correlation motion estimation with blocksize 2B+1
% at the coordinates x_coords,y_coords (vectors, not
% meshgrid-type things) over a search range of +-r pixels
% in each dimension, with the MAD criterion. By default
% B=7 and r=15.
function [mu,mv] = bcme(f1,f2,x,y,B,r)

if(size(f1)~=size(f2)),
   error('Frames need to be the same size!');
end;

if(length(size(f1))~=2),
   error('Frames need to be 2-D matrices!');
end;

if(nargin<4),
   error('Need at least 4 arguments!');
end;

if(nargin<5),
   B=7;
end;

if(nargin<6),
   r=7;
end;

NX=size(f1,2)
NY=size(f1,1)
nX=length(x);
nY=length(y);

if(max(x)>NX-B-r | max(y)>NY-B-r | min(x)<1+B+r | min(y)<1+B+r),
	error('Given coordinates would make me hit the boundaries!');
end;

mu=zeros(length(y),length(x));
mv=zeros(length(y),length(x));
score=zeros(r+r+1,r+r+1);
[gwx,gwy]=meshgrid(-r:r,-r:r);
igausswind=exp(-(gwx.*gwx+gwy.*gwy)/(16*B^2)); igausswind=max(max(igausswind))./igausswind;
% Loop over the blocks
disp(['We''ll be done at i=' num2str(nX)]);
for i=1:nX,
   disp(['i=' num2str(i)]);
   for j=1:nY,
      xc=x(i)-B:x(i)+B; yc=y(j)-B:y(j)+B;
      currmin=1e10;
      for u=-r:r,
         for v=-r:r,
            absdiffo=sum(sum(abs(f2(yc+v,xc+u)-f1(yc,xc))))*igausswind(u+r+1,v+r+1);
            if(absdiffo<currmin),
               currmin=absdiffo;
               currminu=u;
               currminv=v;
            end;
         end;
      end;
      mu(j,i)=currminu;
      mv(j,i)=currminv;
   end;
end;

