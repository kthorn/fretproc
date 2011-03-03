function z=lsq3d_n(p, d)

%fits to z=ax+by+c; p(1)=a, p(2)=b; p(3)=c;
x=d(:,1);
y=d(:,2);
z=x*p(1)+y*p(2)+p(3);