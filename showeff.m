function showeff(set,imnum)
s=16383;
thresh=600;
G=1/3.05;
D=double(set.image(imnum).donor);
F=double(set.image(imnum).FRETc);
DIC=double(set.image(imnum).dic);
Ib=im2bw(D/s,thresh/s);
Ib2=im2bw(F/s,0);
Ib=Ib.*Ib2;
E=(F*G)./((F*G)+D);
figure(1)
imshow(DIC,[])
figure(2)
imshow(E.*Ib,[0 0.6]);colormap('jet')
