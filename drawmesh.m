function drawmesh(tri,xn,yn,col,linewidth)

if(nargin<5),
   linewidth=1.5;
	if(nargin<4),
      col=[1 1 1];
      if(nargin<3),
         error('Need at least 3 arguments!');
      end;
   end;
end;

line([[xn(tri(:,1))';xn(tri(:,2))'] [xn(tri(:,2))';xn(tri(:,3))'] [xn(tri(:,3))';xn(tri(:,1))']],[[yn(tri(:,1))';yn(tri(:,2))'] [yn(tri(:,2))';yn(tri(:,3))'] [yn(tri(:,3))';yn(tri(:,1))']],'LineWidth',linewidth,'Color',col);
