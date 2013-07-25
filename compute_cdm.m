% cdm = compute_cdm(f1,f2,minregionsize)
% Computes the Change Detection Mask between the two given frames.
% If they're not equal-sized, I'm gonna kick your ass.
% The Change Detection Mask is the absolute value of the frame
% difference, thresholded, median-filtered, morphologically closed
% opened, and cleaned of regions smaller than minregionsize pixels.

function cdm = compute_cdm(f1,f2,minregionsize)

x=f1-f2;
x=abs(x-mean2(x))>std2(x)/1.5;
x=bwmorph(x,'close');
x=bwmorph(x,'open');
[labels,num]=bwlabel(x);
for i=1:num,
	regioninds=find(labels==i);
	if(length(regioninds)<minregionsize),
		x(regioninds)=0;
	end;
end;
cdm=x;

