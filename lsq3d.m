function E=lsq3d(p, d)

%fits to z=ax+by+c; p(1)=a, p(2)=b; p(3)=c;
x=d(:,1);
y=d(:,2);
z=d(:,3);
sigmax=d(:,4);
sigmay=d(:,5);
sigmaz=d(:,6);
a=p(1);
b=p(2);
c=p(3);
num=(z -c -a*x -b*y).^2;
%den=sigmaz.^2 + (a^2)*(sigmax.^2) + (b^2)*(sigmay.^2);
den=sigmaz.^2;
E=sum(num./den);
