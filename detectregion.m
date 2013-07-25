% region = detectregion(f,stddevthresh,minregionsize)
% Creates a boolean map of regions whose intensity deviation from
% the mean exceeds stddevthresh standard deviations. The regions
% are median-filtered, morphologically closed and opened, and
% those that are smaller than minregionsize pixels are thrown out.
function x = detectregion(f,stddevthresh,minregionsize)

x=abs(f-mean2(f))>(std2(f)*stddevthresh);
x=bwmorph(x,'close');
x=bwmorph(x,'open');
[labels,num]=bwlabel(x);
for i=1:num,
	regioninds=find(labels==i);
	if(length(regioninds)<minregionsize),
		x(regioninds)=0;
	end;
end;
