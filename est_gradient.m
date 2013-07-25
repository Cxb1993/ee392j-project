% [Sx,Sy] = est_gradient(f);
% Estimates the image intensity gradient at each pixel
function [Sx,Sy] = est_gradient(f),

[NY,NX]=size(f);

% Filter for spatial gradient estimation
[fx,fy]=meshgrid(-1:1,-1:1);
filto=exp(-(fx.^2+fy.^2)); filto=filto/sum(sum(filto));
f=filter2(filto,[f(1,1) f(1,:) f(1,end); f(:,1) f f(:,end); f(end,1) f(end,:) f(end,end)],'valid');

% Estimate spatial gradient
Sx=[diff(f(:,1:2)')' 0.5*(f(:,3:end)-f(:,1:end-2))  diff(f(:,end-1:end)')'];
Sy=[diff(f(1:2,:));  0.5*(f(3:end,:)-f(1:end-2,:)); diff(f(end-1:end,:))];

