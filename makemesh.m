% makemesh(xn,yn) -- makes a triangle map and an adjacency matrix for a
%                    Delaunay triangulation of the given set of nodes.
%                    This is blatant redundancy -- tri and adj express
%                    the same information, but they have different
%                    utility for different purposes.
function [tri,adj] = makemesh(xn,yn)

tri=delaunay(xn,yn);
numnodes=length(xn);
[N,dummy]=size(tri);
adj=spalloc(numnodes,numnodes,3*N); % never more than 3N edges
for i=1:N,
   adj(tri(N,1),tri(N,2))=1;
   adj(tri(N,2),tri(N,3))=1;
   adj(tri(N,3),tri(N,1))=1;
   adj(tri(N,3),tri(N,2))=1;
   adj(tri(N,1),tri(N,3))=1;
   adj(tri(N,2),tri(N,1))=1;
end;

