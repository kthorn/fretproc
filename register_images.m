function new_offset = register_images(target, test, start_offset, search_range)
%test image shifted by test_offset pixels will maximize correlation with
%target image.

%assume target and test are the same size; throw out regions of image that
%do not overlap

% %do search in x
% off=start_offset(1)-search_range:start_offset(1)+search_range;
% offset_mat=repmat(start_offset, size(off,2), 1);
% offset_mat(:,1)=off';
% corr=zeros(size(offset_mat,1));
% for n=1:size(offset_mat,1)
%     corr(n)=imcorr(target, test, offset_mat(n,:))
% end
% [m,best]=max(corr);
% new_offset=offset_mat(best,:);
% 
% %do search in y
% off=new_offset(2)-search_range:new_offset(2)+search_range;
% offset_mat=repmat(new_offset, size(off,2), 1);
% offset_mat(:,2)=off';
% for n=1:size(offset_mat,1)
%     corr(n)=imcorr(target, test, offset_mat(n,:))
% end
% [m,best]=max(corr);
% new_offset=offset_mat(best,:);

%search in both directions
n=1;
for x=start_offset(1)-search_range:start_offset(1)+search_range;
    for y=start_offset(2)-search_range:start_offset(2)+search_range;
        corr(n)=imcorr(target, test, [x y]);
        offset_mat(n,:)=[x y];
        n=n+1;
    end
end
[m,best]=max(corr);
new_offset=offset_mat(best,:);

function corr = imcorr(target, test, offset)
%function to calculate correlation of two images after shifting test by
%offset

if (offset(1) >=0) && (offset(2) >=0)
    corr=corr2(target(1:end-offset(1),1:end-offset(2)),test(1+offset(1):end,1+offset(2):end));
elseif (offset(1) >=0) && (offset(2) <0)
    corr=corr2(target(1:end-offset(1),1+abs(offset(2)):end),test(1+offset(1):end,1:end-abs(offset(2))));
elseif (offset(1) <0) && (offset(2) >=0)
    corr=corr2(target(1+abs(offset(1)):end,1:end-offset(2)),test(1:end-abs(offset(1)),1+offset(2):end));
elseif (offset(1) <0) && (offset(2) <0)
    corr=corr2(target(1+abs(offset(1)):end,1+abs(offset(2)):end),test(1:end-abs(offset(1)),1:end-abs(offset(2))));
end 