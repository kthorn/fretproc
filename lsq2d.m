function E=lsq2d(p, z)

%fits to y=ax+b; p(1)=a, p(2)=b
x=z(:,1);
y=z(:,2);
sigmax=z(:,3);
sigmay=z(:,4);
a=p(1);
b=p(2);
num=(y-b-a*x).^2;
%den=(sigmay.^2) + (a^2)*(sigmax.^2);
den=sigmay.^2;
E=sum(num./den);
