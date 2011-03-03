function [new_target, new_test1, new_test2]=overlay_images(target, test1, test2, offset1, offset2)

%do x offset
x1=offset1(1);
x2=offset2(1);
if (x1>=0) & (x2>=0)
    shrink=max(x1,x2);
    new_target=target(1:end-shrink,:);
    new_test1=test1(1+x1:end-(shrink-x1),:);
    new_test2=test2(1+x2:end-(shrink-x2),:);
elseif (x1<0) & (x2<0)
    shrink=max(abs(x1),abs(x2));
    new_target=target(1+shrink:end,:);
    new_test1=test1(1+(shrink-abs(x1)):end-abs(x1),:);
    new_test2=test2(1+(shrink-abs(x2)):end-abs(x2),:);
elseif (x1<0) & (x2>=0)
    shrink=abs(x1)+abs(x2);
    new_target=target(1+abs(x1):end-x2,:);
    new_test1=test1(1:end-shrink,:);
    new_test2=test2(1+shrink:end,:);
elseif (x1>=0) & (x2<0)
    shrink=abs(x1)+abs(x2);
    new_target=target(1+abs(x2):end-x1,:);
    new_test1=test1(1+shrink:end,:);
    new_test2=test2(1:end-shrink,:);
end

%do y offset
y1=offset1(2);
y2=offset2(2);
if (y1>=0) & (y2>=0)
    shrink=max(y1,y2);
    new_target=new_target(:,1:end-shrink);
    new_test1=new_test1(:,1+y1:end-(shrink-y1));
    new_test2=new_test2(:,1+y2:end-(shrink-y2));
elseif (y1<0) & (y2<0)
    shrink=max(abs(y1),abs(y2));
    new_target=new_target(:,1+shrink:end);
    new_test1=new_test1(:,1+(shrink-abs(y1)):end-abs(y1));
    new_test2=new_test2(:,1+(shrink-abs(y2)):end-abs(y2));
elseif (y1<0) & (y2>=0)
    shrink=abs(y1)+abs(y2);
    new_target=new_target(:,1+abs(y1):end-y2);
    new_test1=new_test1(:,1:end-shrink);
    new_test2=new_test2(:,1+shrink:end);
elseif (y1>=0) & (y2<0)
    shrink=abs(y1)+abs(y2);
    new_target=new_target(:,1+abs(y2):end-y1);
    new_test1=new_test1(:,1+shrink:end);
    new_test2=new_test2(:,1:end-shrink);
end
    